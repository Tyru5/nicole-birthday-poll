defmodule Poll.Polls.Option do
  use Ecto.Schema
  import Ecto.Changeset

  schema "poll_options" do
    field :text, :string
    field :votes_count, :integer, default: 0

    belongs_to :poll, Poll.Polls.Poll

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(option, attrs) do
    option
    |> cast(attrs, [:text, :votes_count, :poll_id])
    |> validate_required([:text, :poll_id])
  end
end
