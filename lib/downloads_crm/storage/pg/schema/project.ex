defmodule DownloadsCrm.Storage.Pg.Schema.Project do
  use Ecto.Schema

  import Ecto.Changeset

  @derive {Jason.Encoder, except: [:__meta__, :__struct__, :tasks]}
  schema "projects" do
    field(:uuid, Ecto.UUID, autogenerate: true)
    field(:name, :string)
    field(:description, :string)
    field(:price, :float)
    has_many(:tasks, DownloadsCrm.Storage.Pg.Schema.Task)
  end

  def changeset(project, attrs \\ %{}) do
    project
    |> cast(attrs, [:name, :description, :price])
    |> validate_required([:name, :price])
  end
end
