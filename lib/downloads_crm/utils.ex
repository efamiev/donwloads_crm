defmodule DownloadsCrm.Utils do
  def endpoint_success(data) do
    Jason.encode!(%{
      "status" => 200,
      "data" => data
    })
  end

  def endpoint_error(status, error) do
    Jason.encode!(%{
      "status" => status,
      "fail_reason" => error
    })
  end

  def format_changeset_errors(errors) do
    Enum.map(errors, fn {attr_name, {msg, _opts}} -> %{attr_name => msg} end)
  end
end
