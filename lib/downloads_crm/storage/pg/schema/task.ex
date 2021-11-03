defmodule DownloadsCrm.Storage.Pg.Schema.Task do
  use Ecto.Schema

  import Ecto.Changeset

  schema "tasks" do
    field(:name, :string)
    field(:description, :string)
    field(:price, :float)
    field(:urls, {:array, :string})
    field(:status, :string)
    field(:progress, :integer)
    field(:estimate_date, :utc_datetime)
    belongs_to(:project, DownloadsCrm.Storage.Pg.Schema.Project)
  end

  @valid_statuses ["initialized", "processing", "failed", "finished"]

  def changeset(task, attrs \\ %{}) do
    task
    |> cast(attrs, [
      :name,
      :description,
      :price,
      :urls,
      :status,
      :progress,
      :estimate_date,
      :project_id
    ])
    |> validate_required([:name])
    |> validate_inclusion(:status, @valid_statuses)
  end

  def valid_statuses, do: @valid_statuses
end
