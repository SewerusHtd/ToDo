defmodule Todo.Items do
  alias Todo.Items.Item
  alias Todo.Repo
  import Ecto.Query

  def get_item(id) do
    Repo.get(Item, id)
  end

  def list_items() do
    query = Item |> order_by(desc: :id)
    Repo.all(query)
  end

  def mark_completed(id) do
    item = Repo.get(Item, id)
    item = Ecto.Changeset.change item, completed: true
    Repo.update(item)
  end

  def delete_item(id) do
    item = Repo.get(Item, id)
    Repo.delete(item)
  end

  def create_item(params) do
    {:ok, item}  = (%Item{}
    |> Item.changeset(params)
    |> Repo.insert)
    item
  end
end
