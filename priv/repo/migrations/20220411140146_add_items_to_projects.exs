defmodule Todo.Repo.Migrations.AddItemsToProjects do
  use Ecto.Migration

  def change do
    alter table(:items) do
      add :project_id, references(:projects, on_delete: :delete_all)
    end

    create index(:items, [:project_id])
  end
end
