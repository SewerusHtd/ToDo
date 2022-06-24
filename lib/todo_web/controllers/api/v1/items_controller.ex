defmodule TodoWeb.Api.V1.ItemsController do
  use TodoWeb, :controller

  alias Todo.Items
  alias Todo.Items.Item

  def index(conn, _params) do
    items = Items.list_items()
    render conn, "index.json", items: items
  end

  def show(conn, %{"id" => id}) do
    item = Todo.Items.get_item(id)
    render conn, "show.json", item: item
  end
end
