import Config

config :downloads_crm, ecto_repos: [DownloadsCrm.Repo]

config :downloads_crm, DownloadsCrm.Repo,
  database: "downloads_crm",
  username: "postgres",
  password: "postgres",
  hostname: "postgres"

try do
  import_config "#{Mix.env()}.exs"
rescue
  e in Code.LoadError -> e
end
