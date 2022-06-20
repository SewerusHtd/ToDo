defmodule TodoWeb.ItemsChannel do
  use TodoWeb, :channel
#  user Phoenix.Channel

  def join("items:lobby", _message, socket) do
    {:ok, socket}
  end

  def join("items:" <> project_id, _payload, socket) do
    {:ok, socket}
  end

#  @impl true
#  def join("items:lobby", payload, socket) do
#    if authorized?(payload) do
#      {:ok, socket}
#    else
#      {:error, %{reason: "unauthorized"}}
#    end
#  end
#
#  # Channels can be used in a request/response fashion
#  # by sending replies to requests from the client
#  @impl true
#  def handle_in("ping", payload, socket) do
#    {:reply, {:ok, payload}, socket}
#  end
#
#  # It is also common to receive messages from the client and
#  # broadcast to everyone in the current topic (items:lobby).
#  @impl true
#  def handle_in("shout", payload, socket) do
#    broadcast(socket, "shout", payload)
#    {:noreply, socket}
#  end
#
#  # Add authorization logic here as required.
#  defp authorized?(_payload) do
#    true
#  end

  def send_destroy(item_id, project_id) do
    payload = %{ "id" => item_id }
    TodoWeb.Endpoint.broadcast("items:lobby", "destroy_item", payload)
    TodoWeb.Endpoint.broadcast("items:#{project_id}", "destroy_item", payload)
  end

  def send_completed(item_id) do
    payload = %{ "id" => item_id }
    TodoWeb.Endpoint.broadcast("items:lobby", "complete_item", payload)
    TodoWeb.Endpoint.broadcast("items:#{Todo.Items.get_item(item_id).project_id}", "complete_item", payload)
  end

  def send_created(item) do
    payload = %{ "id" => item.id, "description" => item.description, "completed" => item.completed }
    TodoWeb.Endpoint.broadcast("items:lobby", "create_item", payload)
    TodoWeb.Endpoint.broadcast("items:#{item.project_id}", "create_item", payload)
  end
end
