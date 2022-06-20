defmodule Todo.Items.Item do

  use Ecto.Schema
  import Ecto.Changeset

  schema "items" do
    field :description, :string
    field :completed, :boolean, default: false

    belongs_to :project, Todo.Projects.Project

    timestamps()
  end

  def changeset(item, params) do
    item
    |> cast(params, [:description, :completed, :project_id])
  end
end