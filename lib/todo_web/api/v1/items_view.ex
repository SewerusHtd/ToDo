defmodule TodoWeb.Api.V1.ItemsView do
  use TodoWeb, :view

  def render("show.json", %{item: item}) do
    %{ data: render_data(item) }
  end

  def render("index.json", %{items: items}) do
    %{ data: Enum.map(items, fn item -> render_data(item) end) }
  end

  def render_data(item) do
    %{
      type: "item",
      id: item.id,
      description: item.description,
      completed: item.completed,
      project_id: item.project_id
    }
  end
end