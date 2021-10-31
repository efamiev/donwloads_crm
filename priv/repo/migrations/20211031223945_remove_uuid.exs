defmodule DownloadsCrm.Repo.Migrations.RemoveUuid do
  use Ecto.Migration

  def change do
    alter table(:projects) do
      remove(:uuid)
    end

    alter table(:tasks) do
      remove(:uuid)
    end
  end
end
