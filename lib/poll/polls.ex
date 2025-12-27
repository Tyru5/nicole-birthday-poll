defmodule Poll.Polls do
  @moduledoc """
  The Polls context for managing polls and voting.
  """

  @pubsub Poll.PubSub

  import Ecto.Query, warn: false

  alias Poll.Repo
  alias Poll.Polls.{Poll, Option}

  @doc """
  Gets a single poll with its options.
  """
  def get_poll!(id) do
    Poll
    |> Repo.get!(id)
    |> Repo.preload(:options)
  end

  @doc """
  Gets the first poll (for the simple single-poll display).
  """
  def get_current_poll do
    Poll
    |> first()
    |> Repo.one()
    |> Repo.preload(:options)
  end

  @doc """
  Creates a poll with options.
  """
  def create_poll(attrs \\ %{}) do
    %Poll{}
    |> Poll.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Creates an option for a poll.
  """
  def create_option(poll, attrs) do
    %Option{}
    |> Option.changeset(Map.put(attrs, :poll_id, poll.id))
    |> Repo.insert()
  end

  @doc """
  Votes for an option by incrementing its vote count.
  """
  def vote_for_option(option_id) do
    option = Repo.get!(Option, option_id)

    option
    |> Ecto.Changeset.change(votes_count: option.votes_count + 1)
    |> Repo.update()
  end

  @doc """
  Removes a vote from an option by decrementing its vote count.
  """
  def unvote_option(option_id) do
    option = Repo.get!(Option, option_id)

    option
    |> Ecto.Changeset.change(votes_count: max(option.votes_count - 1, 0))
    |> Repo.update()
  end

  @doc """
  Changes a vote from one option to another.
  Returns {:ok, new_option} on success.
  """
  def change_vote(from_option_id, to_option_id) do
    Repo.transaction(fn ->
      {:ok, _} = unvote_option(from_option_id)
      {:ok, new_option} = vote_for_option(to_option_id)
      new_option
    end)
  end

  @doc """
  Gets the total votes for a poll.
  """
  def total_votes(poll) do
    Enum.reduce(poll.options, 0, fn opt, acc -> acc + opt.votes_count end)
  end

  @doc """
  Calculates the percentage for an option.
  """
  def vote_percentage(option, poll) do
    total = total_votes(poll)

    if total == 0 do
      0
    else
      round(option.votes_count / total * 100)
    end
  end

  @doc """
  Broadcasts poll updates via PubSub.
  """
  def broadcast_poll_update(poll_id) do
    Phoenix.PubSub.broadcast(@pubsub, "poll:#{poll_id}", {:poll_updated, poll_id})
  end

  @doc """
  Subscribes to poll updates.
  """
  def subscribe_to_poll(poll_id) do
    Phoenix.PubSub.subscribe(@pubsub, "poll:#{poll_id}")
  end
end
