defmodule DownloadsCrm.SocketHandler do
  @behaviour :cowboy_websocket

  def init(request, _state) do
    state = %{registry_key: request.path}

    {:cowboy_websocket, request, state}
  end

  def websocket_init(state) do
    Registry.DownloadsCrm
    |> Registry.register(state.registry_key, {})

    IO.inspect(self())

    {:ok, state}
  end

  def websocket_handle({:text, json}, state) do
    payload = json
    # payload = Jason.decode!(json)
    message = payload
    # message = payload["data"]["message"]

    # для отправки сообщений на всем другим слушателям сокета
    Registry.DownloadsCrm
    |> Registry.dispatch(state.registry_key, fn entries ->
      for {pid, _} <- entries do
        if pid != self() do
          Process.send(pid, message, [])
        end
      end
    end)

    {:reply, {:text, message}, state}
  end

  def websocket_info(info, state) do
    {:reply, {:text, info}, state}
  end
end
