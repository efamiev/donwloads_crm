defmodule DownloadsCrm.Plug.Logger do
  @moduledoc """
  Логируем данные запроса в одной строке info-лога.

  Копипаста из модулей Plug.Logger и Phoenix.Logger
  """
  alias Plug.Conn
  require Logger

  @spec init(Keyword.t()) :: Keyword.t()
  def init(opts) do
    Keyword.get(opts, :log, :info)
  end

  @spec call(Plug.Conn.t(), level :: atom) :: Plug.Conn.t()
  def call(conn, level) do
    Logger.log(level, fn ->
      [conn.method, ?\s, conn.request_path, " with query ", inspect(conn.query_string)]
    end)

    start = System.monotonic_time()

    Conn.register_before_send(conn, fn conn ->
      Logger.log(level, fn ->
        stop = System.monotonic_time()
        diff = System.convert_time_unit(stop - start, :native, :microsecond)
        status = Integer.to_string(conn.status)

        result =
          case Map.get(conn.private, :_result) do
            nil ->
              ""

            term ->
              " " <> inspect(term)
          end

        [
          conn.method,
          ?\s,
          conn.request_path,
          " with ",
          params(conn.params),
          ?\s,
          connection_type(conn),
          ?\s,
          status,
          result,
          " in ",
          formatted_diff(diff)
        ]
      end)

      conn
    end)
  end

  defp params(%Conn.Unfetched{}), do: "[UNFETCHED]"
  defp params(params), do: params |> filter_values() |> inspect()

  defp filter_values(values, params \\ Application.get_env(:phoenix, :filter_parameters, []))
  defp filter_values(values, {:discard, params}), do: discard_values(values, params)
  defp filter_values(values, {:keep, params}), do: keep_values(values, params)
  defp filter_values(values, params), do: discard_values(values, params)

  defp discard_values(%{__struct__: mod} = struct, _params) when is_atom(mod) do
    struct
  end

  defp discard_values(%{} = map, params) do
    Enum.into(map, %{}, fn {k, v} ->
      if is_binary(k) and String.contains?(k, params) do
        {k, "[FILTERED]"}
      else
        {k, discard_values(v, params)}
      end
    end)
  end

  defp discard_values([_ | _] = list, params) do
    Enum.map(list, &discard_values(&1, params))
  end

  defp discard_values(other, _params), do: other

  defp keep_values(%{__struct__: mod}, _params) when is_atom(mod), do: "[FILTERED]"

  defp keep_values(%{} = map, params) do
    Enum.into(map, %{}, fn {k, v} ->
      if is_binary(k) and k in params do
        {k, discard_values(v, [])}
      else
        {k, keep_values(v, params)}
      end
    end)
  end

  defp keep_values([_ | _] = list, params) do
    Enum.map(list, &keep_values(&1, params))
  end

  defp keep_values(_other, _params), do: "[FILTERED]"

  defp formatted_diff(diff) when diff > 1000, do: [diff |> div(1000) |> Integer.to_string(), "ms"]
  defp formatted_diff(diff), do: [Integer.to_string(diff), "µs"]

  defp connection_type(%{state: :set_chunked}), do: "chunked"
  defp connection_type(_), do: "sent"
end
