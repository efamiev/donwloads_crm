defmodule DownloadsCrm.Storage.Pg.Schema.Project do
  use Ecto.Schema

  schema "projects" do
    field(:uuid, Ecto.UUID, autogenerate: true)
    field(:name, :string)
    field(:description, :string)
    field(:price, :float)
  end
end
