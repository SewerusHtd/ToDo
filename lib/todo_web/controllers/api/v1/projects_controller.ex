defmodule TodoWeb.Api.V1.ProjectsController do
  use TodoWeb, :controller

  alias Todo.Projects
  alias Todo.Projects.Project

  def index(conn, _params) do
    projects = Projects.list_projects()
    render conn, "index.json", projects: projects
  end

  def show(conn, %{"id" => id}) do
    project = Todo.Projects.get_project(id)
    render conn, "show.json", project: project
  end
end
