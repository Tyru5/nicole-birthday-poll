defmodule PollWeb.PollLive do
  use PollWeb, :live_view

  alias Poll.Polls

  embed_templates "live/*"

  @max_vote_changes 3

  @impl true
  def mount(_params, _session, socket) do
    poll = Polls.get_current_poll()

    if poll do
      if connected?(socket) do
        Polls.subscribe_to_poll(poll.id)
      end

      {:ok,
       assign(socket,
         poll: poll,
         voted_option_id: nil,
         vote_changes_remaining: @max_vote_changes,
         changing_vote: false,
         current_scope: nil
       )}
    else
      {:ok,
       assign(socket,
         poll: nil,
         voted_option_id: nil,
         vote_changes_remaining: @max_vote_changes,
         changing_vote: false,
         current_scope: nil
       )}
    end
  end

  @impl true
  def handle_event("vote", %{"option_id" => option_id}, socket) do
    option_id = String.to_integer(option_id)

    if socket.assigns.changing_vote do
      # User is changing their vote
      {:ok, _} = Polls.change_vote(socket.assigns.voted_option_id, option_id)

      poll = Polls.get_poll!(socket.assigns.poll.id)
      Polls.broadcast_poll_update(poll.id)

      {:noreply,
       assign(socket,
         poll: poll,
         voted_option_id: option_id,
         vote_changes_remaining: socket.assigns.vote_changes_remaining - 1,
         changing_vote: false
       )}
    else
      # Initial vote
      {:ok, _option} = Polls.vote_for_option(option_id)

      poll = Polls.get_poll!(socket.assigns.poll.id)
      Polls.broadcast_poll_update(poll.id)

      {:noreply, assign(socket, poll: poll, voted_option_id: option_id)}
    end
  end

  @impl true
  def handle_event("start_change_vote", _params, socket) do
    {:noreply, assign(socket, changing_vote: true)}
  end

  @impl true
  def handle_event("cancel_change_vote", _params, socket) do
    {:noreply, assign(socket, changing_vote: false)}
  end

  @impl true
  def handle_info({:poll_updated, poll_id}, socket) do
    poll = Polls.get_poll!(poll_id)
    {:noreply, assign(socket, poll: poll)}
  end
end
