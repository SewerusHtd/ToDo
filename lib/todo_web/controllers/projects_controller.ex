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
    Projects.create_project(project_params)
    |> IO.inspect
    |> TodoWeb.ProjectsChannel.send_created()
    render(conn, "create.js")
  end

  def edit(conn, %{"id" => id}) do
    project = Projects.get_project(id)
    changeset = Project.changeset(project, %{})
    render(conn, "edit.js", project: project, changeset: changeset)
  end

  def update(conn, %{"id" => id, "project" => %{"color" => color, "title" => title}}) do
    project = Projects.update_project(id, %{color: color, title: title})
    TodoWeb.ProjectsChannel.send_updated(project)
    render(conn, "update.js", project: project)
  end

  def delete(conn, %{"id" => id}) do
    Projects.delete_project(id)
    TodoWeb.ProjectsChannel.send_destroy(id)
    redirect(conn, to: "/projects")
  end
end
