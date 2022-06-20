defmodule TodoWeb.ItemsController do
  use TodoWeb, :controller

  alias Todo.Items
  alias Todo.Items.Item

  def index(conn, _params) do
    items = Items.list_items()
    render(conn, "index.html", items: items)
  end

  def create(conn, %{"item" => item_params}) do
    Items.create_item(item_params)
    |> IO.inspect
    |> TodoWeb.ItemsChannel.send_created()
    render(conn, "create.js")
  end

  def complete(conn, %{"id" => id}) do
    Items.mark_completed(id)
    TodoWeb.ItemsChannel.send_completed(id)
    render(conn, "complete.js", item_id: id)
  end

  def delete(conn, %{"id" => id}) do
    project_id = Todo.Items.get_item(id).project_id
    Items.delete_item(id)
    TodoWeb.ItemsChannel.send_destroy(id, project_id)
    render(conn, "delete.js", item_id: id)
  end
end
