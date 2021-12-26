defmodule DownloadsCrm.Storage.Pg.Tasks do
  alias DownloadsCrm.Repo
  alias DownloadsCrm.Storage.Pg.Schema.Task

  require Logger

  def list_tasks do
    Repo.all(Task) |> Repo.preload(:project)
  end

  def create_task(attrs) do
    %Task{}
    |> Task.changeset(attrs)
    |> Repo.insert()
  end

  def create_task!(attrs) do
    %Task{}
    |> Task.changeset(attrs)
    |> Repo.insert!()
  end

  def update_task(id, attrs) do
    Repo.get!(Task, id)
    |> Task.changeset(attrs)
    |> Repo.update()
  end

  def batch_create_tasks(tasks) do
    try do
      Repo.transaction(fn ->
        Enum.each(tasks, fn task ->
          create_task!(task)
        end)
      end)
    rescue
      e in Postgrex.Error ->
        Logger.error(fn -> "#{inspect(__MODULE__)} error #{inspect(e)}" end)
        {:error, e.postgres.message}

      e in Ecto.InvalidChangesetError ->
        Logger.error(fn -> "#{inspect(__MODULE__)} error #{inspect(e)}" end)
        {:error, e}

      e ->
        Logger.error(fn -> "#{inspect(__MODULE__)} error #{inspect(e)}" end)
        {:error, e}
    end
  end
end
