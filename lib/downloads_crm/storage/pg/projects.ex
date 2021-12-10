defmodule DownloadsCrm.Storage.Pg.Projects do
  import Ecto.Query

  alias DownloadsCrm.Repo
  alias DownloadsCrm.Storage.Pg.Schema.Project

  def list_projects do
    # TODO: сейчас не возвращает проекты без задач, нужно исправить
    query =
      from(p in Project,
        join: t in assoc(p, :tasks),
        select: %{
          "id" => p.id,
          "price" => p.price,
          "tasks_count" => count(),
          "estimate_date" => max(t.estimate_date),
          "progress" => min(t.progress),
          "status" => min(t.status)
        },
        group_by: [p.id]
      )

    Repo.all(query)
  end

  def create_project(attrs) do
    %Project{}
    |> Project.changeset(attrs)
    |> Repo.insert()
  end
end
