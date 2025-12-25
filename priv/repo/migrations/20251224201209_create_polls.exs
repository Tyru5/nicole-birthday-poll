defmodule Poll.Repo.Migrations.CreatePolls do
  use Ecto.Migration

  def change do
    create table(:polls) do
      add :title, :string, null: false
      add :description, :text

      timestamps(type: :utc_datetime)
    end

    create table(:poll_options) do
      add :text, :string, null: false
      add :votes_count, :integer, default: 0, null: false
      add :poll_id, references(:polls, on_delete: :delete_all), null: false

      timestamps(type: :utc_datetime)
    end

    create index(:poll_options, [:poll_id])
  end
end
