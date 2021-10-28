defmodule DownloadsCrm.Storage.Pg.Tasks do
  alias DownloadsCrm.Repo
  alias DownloadsCrm.Storage.Pg.Schema.Task

  def list_tasks do
    Repo.all(Task)
  end

  def create_task(attrs) do
    %Task{}
    |> Task.changeset(attrs)
    |> Repo.insert()
  end
end
