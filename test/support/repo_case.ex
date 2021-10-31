defmodule DownloadsCrm.RepoCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      alias DownloadsCrm.Repo

      import Ecto
      import Ecto.Query
      import DownloadsCrm.RepoCase
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(DownloadsCrm.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(DownloadsCrm.Repo, {:shared, self()})
    end

    :ok
  end
end
