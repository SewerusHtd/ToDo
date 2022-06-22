defmodule Todo.Projects.Project do

  use Ecto.Schema
  import Ecto.Changeset

  schema "projects" do
    field :title, :string
    field :color, :string

    has_many :items, Todo.Items.Item

    timestamps()
  end

  @required_fields ~w(title color)a

  def changeset(project, params) do
    project
    |> cast(params, [:title, :color])
    |> validate_required(@required_fields)
  end
end
