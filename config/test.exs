import Config

config :downloads_crm, DownloadsCrm.Repo,
  database: "downloads_crm_test",
  username: "postgres",
  password: "postgres",
  hostname: "postgres",
  pool: Ecto.Adapters.SQL.Sandbox
