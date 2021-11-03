defmodule DownloadsCrm.Factory do
  use ExMachina.Ecto, repo: DownloadsCrm.Repo

  use DownloadsCrm.ProjectsFactory
  use DownloadsCrm.TasksFactory
end
