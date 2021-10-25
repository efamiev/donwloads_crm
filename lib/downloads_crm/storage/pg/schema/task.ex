defmodule DownloadsCrm.Storage.Pg.Schema.Task do
  use Ecto.Schema

  schema "tasks" do
    field(:uuid, Ecto.UUID, autogenerate: true)
    field(:name, :string)
    field(:description, :string)
    field(:price, :float)
    field(:urls, {:array, :string})
    field(:status, :string)
    field(:progress, :integer)
    field(:estimate_date, :utc_datetime)
    belongs_to(:project, DownloadsCrm.Storage.Pg.Schema.Project)
  end
end
