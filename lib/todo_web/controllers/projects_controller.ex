defmodule TodoWeb.ProjectsController do
  use TodoWeb, :controller

  alias Todo.Projects
  alias Todo.Projects.Project
  alias Todo.Items.Item

  def index(conn, _params) do
    projects = Projects.list_projects()
    changeset = Project.changeset(%Project{}, %{})
    render(conn, "index.html", projects: projects, changeset: changeset)
  end

  def show(conn, %{"id" => id}) do
    project = Projects.get_project(id)
    changeset = Item.changeset(%Item{}, %{})
    render(conn, "show.html", project: project, changeset: changeset)
  end

  def create(conn, %{"project" => project_params}) do
    case Projects.create_project(project_params) do
      {:ok, project} -> TodoWeb.ProjectsChannel.send_created(project)
                        render(conn, "create.js", errors: nil)
      {:error, changeset} -> render(conn, "create.js", errors: changeset.errors)
    end
  end

  def edit(conn, %{"id" => id}) do
    project = Projects.get_project(id)
    changeset = Project.changeset(project, %{})
    render(conn, "edit.js", project: project, changeset: changeset)
  end

  def update(conn, %{"id" => id, "project" => %{"color" => color, "title" => title}}) do
    case Projects.update_project(id, %{color: color, title: title}) do
      {:ok, project} ->
        TodoWeb.ProjectsChannel.send_updated(project)
        render(conn, "update.js", project: project, errors: nil)
      {:error, changeset} ->
        render(conn, "update.js", project: nil, errors: changeset.errors)
    end
  end

  def delete(conn, %{"id" => id}) do
    Projects.delete_project(id)
    TodoWeb.ProjectsChannel.send_destroy(id)
    redirect(conn, to: Routes.projects_path(conn, :index))
  end
end
