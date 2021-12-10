defmodule DownloadsCrm.Application do
  use Application

  require Logger

  def start(_type, _args) do
    port = 4000

    children = [
      {Plug.Cowboy, scheme: :http, plug: DownloadsCrm.Router, options: [port: port, dispatch: dispatch()]},
      {Registry, keys: :duplicate, name: Registry.DownloadsCrm},
      {DownloadsCrm.Repo, []}
    ]

    opts = [strategy: :one_for_one, name: DownloadsCrm.Supervisor]

    Logger.info("Server running on port #{port}")

    Supervisor.start_link(children, opts)
  end

  defp dispatch do
    [
      _: [
        {"/websocket", DownloadsCrm.SocketHandler, []},
        {:_, Plug.Cowboy.Handler, {DownloadsCrm.Router, []}}
      ]
    ]
  end
end
