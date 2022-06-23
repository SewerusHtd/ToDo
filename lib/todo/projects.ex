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
    (project
    |> Project.changeset(params)
    |> Repo.update)
  end

  def delete_project(id) do
    project = Repo.get(Project, id)
    Repo.delete(project)
  end

  def create_project(params) do
    (%Project{}
    |> Project.changeset(params)
    |> Repo.insert)
  end

  def count do
    Repo.aggregate(Project, :count, :id)
  end
end
