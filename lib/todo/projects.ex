defmodule Todo.Projects do
  alias Todo.Projects.Project
  alias Todo.Repo
  import Ecto.Query

  def get_project(id) do
    Repo.get(Project, id) |> Todo.Repo.preload(:items)
  end

  def list_projects() do
    query = Project |> order_by(desc: :id)
    Repo.all(query)
  end

  def update_project(id, params) do
    project = Repo.get(Project, id)
    project = Ecto.Changeset.change project, params
    {:ok, project}  = Repo.update(project)
    project
  end

  def delete_project(id) do
    project = Repo.get(Project, id)
    Repo.delete(project)
  end

  def create_project(params) do
    {:ok, project}  = (%Project{}
    |> Project.changeset(params)
    |> Repo.insert)
    project
  end
end
