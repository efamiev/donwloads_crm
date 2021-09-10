import Config

config :downloads_crm, ecto_repos: [DownloadsCrm.Repo]

config :downloads_crm, DownloadsCrm.Repo,
  database: "downloads_crm",
  username: "postgres",
  password: "postgres",
  hostname: "postgres"
