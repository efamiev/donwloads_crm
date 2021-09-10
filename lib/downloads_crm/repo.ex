defmodule DownloadsCrm.Repo do
  use Ecto.Repo,
    otp_app: :downloads_crm,
    adapter: Ecto.Adapters.Postgres
end
