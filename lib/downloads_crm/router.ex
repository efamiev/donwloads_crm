defmodule DownloadsCrm.Router do
  use Plug.Router
  use Plug.ErrorHandler

  alias DownloadsCrm.Storage.Pg.Projects
  alias DownloadsCrm.Storage.Pg.Tasks
  alias DownloadsCrm.Utils

  require Logger

  plug(Plug.Parsers,
    parsers: [:json],
    pass: ["application/json"],
    json_decoder: Jason
  )

  plug(DownloadsCrm.Plug.Logger)

  plug(:match)
  plug(:dispatch)

  # TODO: add estimate date, status, progress, tasks_count fields
  get "/projects" do
    projects = Projects.list_projects()

    send_json_resp(conn, 200, Utils.endpoint_success(%{projects: projects}))
  end

  post "/projects" do
    {status, body} =
      case Projects.create_project(conn.body_params) do
        {:ok, project} ->
          {200, Utils.endpoint_success(%{project: project})}

        {:error, %Ecto.Changeset{errors: errors}} ->
          {400, Utils.endpoint_error(400, Utils.format_changeset_errors(errors))}
      end

    send_json_resp(conn, status, body)
  end

  get "/tasks" do
    {status, body} = {200, Utils.endpoint_success(%{tasks: []})}

    send_json_resp(conn, status, body)
  end

  post "/tasks/batch_create" do
    case conn.body_params do
      %{"tasks" => tasks} ->
        status =
          Enum.each(tasks, fn task ->
            Tasks.create_task(task)
          end)

        conn
        |> put_resp_content_type("application/json")
        |> send_json_resp(200, Utils.endpoint_success(status))

      _ ->
        conn
        |> put_resp_content_type("application/json")
        |> send_json_resp(400, Utils.endpoint_error(400, "Missing tasks"))
    end
  end

  post "/tasks/batch_update" do
    send_resp(conn, 200, "ok")
  end

  match(_, do: send_resp(conn, 404, "Oops!"))

  defp handle_errors(conn, %{kind: _kind, reason: %{__struct__: e} = error, stack: _stack})
       when e in [
              Plug.Parsers.RequestTooLargeError,
              Plug.Parsers.UnsupportedMediaTypeError,
              Plug.Parsers.BadEncodingError,
              Plug.Parsers.ParseError
            ] do
    Logger.warn(inspect(error))

    resp_data = Utils.endpoint_error(400, "invalid request format")
    conn = Plug.Conn.put_status(conn, 400) |> put_private(:_result, resp_data)

    send_json_resp(conn, 400, resp_data)
  end

  defp handle_errors(conn, %{kind: kind, reason: reason, stack: stack}) do
    Logger.warn("error=#{kind} reason=#{inspect(reason)}")
    Logger.debug(inspect(stack))

    resp_data = Utils.endpoint_error(500, "Internal server error")
    conn = Plug.Conn.put_status(conn, 500) |> put_private(:_result, resp_data)

    send_json_resp(conn, 500, resp_data)
  end

  defp send_json_resp(conn, status, body) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(status, body)
  end
end
