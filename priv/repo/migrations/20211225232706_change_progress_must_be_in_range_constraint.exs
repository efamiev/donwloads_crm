defmodule DownloadsCrm.Repo.Migrations.ChangeProgressMustBeInRangeConstraint do
  use Ecto.Migration

  def up do
    drop constraint(:tasks, :progress_must_be_in_range)
    create constraint(:tasks, :progress_must_be_in_range, check: "progress >= 0 and progress <= 100")
  end

  def down do
    drop constraint(:tasks, :progress_must_be_in_range)
    create constraint(:tasks, :progress_must_be_in_range, check: "progress > 0 and progress <= 100")
  end
end
