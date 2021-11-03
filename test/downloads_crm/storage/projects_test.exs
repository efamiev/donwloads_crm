defmodule DownloadsCrm.Storage.Pg.ProjectsTest do
  use DownloadsCrm.RepoCase, async: true

  alias DownloadsCrm.Storage.Pg.Projects

  test "list_projects returns projects list" do
    now = DateTime.utc_now() |> DateTime.truncate(:second)

    project1 = insert(:project, price: 3000, id: 1)
    attrs1 = %{project: project1, estimate_date: now}

    insert(:task, Map.merge(attrs1, %{status: "initialized"}))
    insert(:task, attrs1)
    insert(:task, Map.merge(attrs1, %{status: "finished"}))

    project2 = insert(:project, id: 5)
    attrs2 = %{project: project2, estimate_date: now}

    insert(:task, Map.merge(attrs2, %{status: "failed"}))
    insert(:task, Map.merge(attrs2, %{status: "processing"}))

    list_projects = Projects.list_projects()

    assert Enum.sort_by(list_projects, & &1["id"]) == [
             %{
               "estimate_date" => now,
               "id" => project1.id,
               "price" => project1.price,
               "progress" => nil,
               "status" => "initialized",
               "tasks_count" => 3
             },
             %{
               "estimate_date" => now,
               "id" => project2.id,
               "price" => project2.price,
               "progress" => nil,
               "status" => "processing",
               "tasks_count" => 2
             }
           ]
  end
end
