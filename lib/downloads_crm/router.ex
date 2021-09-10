defmodule DownloadsCrm.Router do
  use Plug.Router

  plug(:match)
  plug(:dispatch)

  plug(Plug.Parsers,
    parsers: [:json],
    pass: ["application/json"],
    json_decoder: Jason
  )

  get "/projects" do
    send_resp(conn, 200, "ok")
  end

  match(_, do: send_resp(conn, 404, "Oops!"))
end
