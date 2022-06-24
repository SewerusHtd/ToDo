defmodule TodoWeb.Api.V1.ProjectsView do
  use TodoWeb, :view

  def render("show.json", %{project: project}) do
    %{ data: render_data(project) }
  end

  def render("index.json", %{projects: projects}) do
    %{ data: Enum.map(projects, fn project -> render_data(project) end) }
  end

  def render_data(project) do
    project_data = %{
      type: "project",
      id: project.id,
      title: project.title,
      color: project.color
    }
    items_data = case Ecto.assoc_loaded?(project.items) do
      true -> %{ items: Enum.map(project.items, fn item -> TodoWeb.Api.V1.ItemsView.render_data(item) end) }
      false -> %{}
    end
    Map.merge(project_data, items_data)
  end
end