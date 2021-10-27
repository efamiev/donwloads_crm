defmodule DownloadsCrm.Router do
  use Plug.Router

  alias DownloadsCrm.Storage.Pg.Projects
  alias DownloadsCrm.Utils

  plug(Plug.Logger)

  plug(:match)

  plug(Plug.Parsers,
    parsers: [:json],
    pass: ["application/json"],
    json_decoder: Jason
  )

  plug(:dispatch)

  # TODO: add estimate date, status, progress, tasks_count fields
  get "/projects" do
    projects = Projects.list_projects()

    send_json(conn, 200, Utils.endpoint_success(%{projects: projects}))
  end

  post "/projects" do
    {status, body} =
      case Projects.create_project(conn.params) do
        {:ok, project} ->
          {200, Utils.endpoint_success(%{project: project})}

        {:error, %Ecto.Changeset{errors: errors}} ->
          {400, Utils.endpoint_error(400, Utils.format_changeset_errors(errors))}

        error ->
          IO.inspect(error, label: "Unexpected error")

          {500, Utils.endpoint_error(500, "Unexpected error")}
      end

    send_json(conn, status, body)
  end

  get "/tasks" do
    {status, body} = {200, Utils.endpoint_success(%{tasks: []})}

    send_json(conn, status, body)
  end

  post "/tasks/batch_create" do
    send_resp(conn, 200, "ok")
  end

  post "/tasks/batch_update" do
    send_resp(conn, 200, "ok")
  end

  match(_, do: send_resp(conn, 404, "Oops!"))

  defp send_json(conn, status, body) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(status, body)
  end
end
