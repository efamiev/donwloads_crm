defmodule DownloadsCrm.Storage.Pg.Projects do
  import Ecto.Query

  alias DownloadsCrm.Repo
  alias DownloadsCrm.Storage.Pg.Schema.Project

  def list_projects do
    query = from(Project, preload: [:tasks])

    Repo.all(query)
  end

  def create_project(attrs) do
    %Project{}
    |> Project.changeset(attrs)
    |> Repo.insert()
  end
end
