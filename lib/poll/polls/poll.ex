defmodule Poll.Polls.Poll do
  use Ecto.Schema
  import Ecto.Changeset

  schema "polls" do
    field :title, :string
    field :description, :string

    has_many :options, Poll.Polls.Option, on_delete: :delete_all

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(poll, attrs) do
    poll
    |> cast(attrs, [:title, :description])
    |> validate_required([:title])
  end
end
