defmodule DownloadsCrm.RouterTest do
  use DownloadsCrm.RepoCase, async: true
  use Plug.Test

  alias DownloadsCrm.Router

  @opts Router.init([])

  test "GET /projects" do
    conn =
      :get
      |> conn("/projects")
      |> Router.call(@opts)

    assert {200, _, body} = sent_resp(conn)

    assert Jason.decode!(body) == %{"data" => %{"projects" => []}, "status" => 200}
  end

  test "POST /projects" do
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

  test "POST /tasks/batch_create" do
    req_body = %{
      "tasks" => [
        %{
          "name" => "task one",
          "urls" => ["url one", "url two"]
        },
        %{
          "name" => "task two",
          "urls" => ["url one", "url two", "url three"]
        }
      ]
    }

    conn =
      :post
      |> conn("/tasks/batch_create", req_body)
      |> Router.call(@opts)

    assert {200, _, body} = sent_resp(conn)

    assert %{
             "data" => "ok",
             "status" => 200
           } = Jason.decode!(body)
  end

  test "POST /tasks/batch_create returns error for wrong task" do
    req_body = %{
      "tasks" => [
        %{
          "name" => "task one",
          "urls" => ["url one", "url two"]
        },
        %{
          "name" => "task two",
          "urls" => "url"
        }
      ]
    }

    conn =
      :post
      |> conn("/tasks/batch_create", req_body)
      |> Router.call(@opts)

    assert {400, _, body} = sent_resp(conn)

    assert %{
             "fail_reason" => [%{"urls" => "is invalid"}],
             "status" => 400
           } = Jason.decode!(body)
  end
end
