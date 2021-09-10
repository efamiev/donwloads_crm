defmodule DownloadsCrm.Repo.Migrations.CreateProject do
  use Ecto.Migration

  def change do
    create table(:projects) do
      add(:uuid, :uuid, null: false)
      add(:name, :string, null: false)
      add(:description, :string)
      add(:price, :float, null: false)
    end
  end
end
