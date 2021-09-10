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
  end
end
