defmodule DownloadsCrm.Router do
  use Plug.Router

  alias DownloadsCrm.Repo
  alias DownloadsCrm.Storage.Pg.Schema.Project

  plug(:match)

  plug(Plug.Parsers,
    parsers: [:json],
    pass: ["application/json"],
    json_decoder: Jason
  )

  plug(:dispatch)

  get "/projects" do
    send_resp(conn, 200, "ok")
  end

  post "/projects" do
    with %{valid?: true} = changeset <- Project.changeset(%Project{}, conn.params),
         {:ok, project} <- Repo.insert(changeset) do
      render_json(conn, project)
    else
      %Ecto.Changeset{errors: errors} = res ->
        send_resp(conn, 400, format_errors(errors))

      error ->
        IO.inspect(error, label: "Unexpected error")
        send_resp(conn, 500, "Unexpected error")
    end
  end

  match(_, do: send_resp(conn, 404, "Oops!"))

  defp format_errors(errors) do
    errors
    |> Enum.map(fn {attr_name, {msg, _opts}} -> "#{attr_name}: #{msg}" end)
  end

  defp render_json(%{status: status} = conn, data) do
    body = Jason.encode!(data)
    send_resp(conn, status || 200, body)
  end
end
