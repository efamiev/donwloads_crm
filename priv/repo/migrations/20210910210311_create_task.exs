defmodule DownloadsCrm.Repo.Migrations.CreateTask do
  use Ecto.Migration

  def change do
    execute("CREATE TYPE task_status AS ENUM ('initialized', 'processing', 'failed', 'finished')")

    create table(:tasks) do
      add(:uuid, :uuid, null: false)
      add(:name, :string, null: false)
      add(:description, :string)
      add(:price, :float)
      add(:urls, {:array, :string}, null: false)
      add(:status, :task_status)
      add(:progress, :integer)
    end

    create constraint(:tasks, :progress_must_be_in_range, check: "progress > 0 and progress <= 100")
  end
end
