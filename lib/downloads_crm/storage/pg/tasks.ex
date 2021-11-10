defmodule DownloadsCrm.Storage.Pg.Tasks do
  alias DownloadsCrm.Repo
  alias DownloadsCrm.Storage.Pg.Schema.Task

  def list_tasks do
    Repo.all(Task) |> Repo.preload(:project)
  end

  def create_task(attrs) do
    %Task{}
    |> Task.changeset(attrs)
    |> Repo.insert()
  end

  def batch_create_tasks(tasks) do
    try do
      Repo.transaction(fn ->
        Enum.each(tasks, fn task ->
          create_task(task)
        end)
      end)
    rescue
      e in Postgrex.Error ->
        {:error, e.postgres.message}
    end
  end
end
