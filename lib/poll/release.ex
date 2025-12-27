defmodule Poll.Release do
  @moduledoc """
  Used for executing DB release tasks when run in production without Mix
  installed.
  """
  @app :poll

  def migrate do
    load_app()

    for repo <- repos() do
      {:ok, _, _} = Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :up, all: true))
    end
  end

  def rollback(repo, version) do
    load_app()
    {:ok, _, _} = Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :down, to: version))
  end

  def seed do
    load_app()

    for repo <- repos() do
      {:ok, _, _} = Ecto.Migrator.with_repo(repo, fn _repo ->
        seed_script = Application.app_dir(@app, "priv/repo/seeds.exs")
        if File.exists?(seed_script) do
          Code.eval_file(seed_script)
        end
      end)
    end
  end

  def reset_and_seed do
    load_app()

    for repo <- repos() do
      {:ok, _, _} = Ecto.Migrator.with_repo(repo, fn _repo ->
        # Delete existing data
        Poll.Repo.delete_all(Poll.Polls.Option)
        Poll.Repo.delete_all(Poll.Polls.Poll)

        # Re-run seeds
        seed_script = Application.app_dir(@app, "priv/repo/seeds.exs")
        if File.exists?(seed_script) do
          Code.eval_file(seed_script)
        end
      end)
    end
  end

  defp repos do
    Application.fetch_env!(@app, :ecto_repos)
  end

  defp load_app do
    # Many platforms require SSL when connecting to the database
    Application.ensure_all_started(:ssl)
    Application.ensure_loaded(@app)
  end
end
