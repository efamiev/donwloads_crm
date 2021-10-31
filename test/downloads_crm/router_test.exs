defmodule DownloadsCrm.RouterTest do
  use DownloadsCrm.RepoCase, async: true
  use Plug.Test

  alias DownloadsCrm.Router
  alias DownloadsCrm.Storage.Pg.Schema.Task, as: ProjectTask

  @opts Router.init([])

  test "GET /projects returns projects list" do
    conn =
      :get
      |> conn("/projects")
      |> Router.call(@opts)

    assert {200, _, body} = sent_resp(conn)

    assert Jason.decode!(body) == %{"data" => %{"projects" => []}, "status" => 200}
  end

  test "POST /projects returns created project" do
    req_body = %{"name" => "first", "price" => 1000, "description" => "first project description"}

    conn =
      :post
      |> conn("/projects", req_body)
      |> Router.call(@opts)

    assert {200, _, body} = sent_resp(conn)

    assert %{
             "data" => %{
               "project" => %{
                 "name" => "first",
                 "price" => 1.0e3,
                 "description" => "first project description",
                 "id" => _
               }
             },
             "status" => 200
           } = Jason.decode!(body)
  end
end
