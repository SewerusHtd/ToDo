defmodule TodoWeb.ProjectsChannel do
  use TodoWeb, :channel
#  user Phoenix.Channel

  def join("projects:lobby", _message, socket) do
    {:ok, socket}
  end

#  @impl true
#  def join("projects:lobby", payload, socket) do
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
#  # broadcast to everyone in the current topic (projects:lobby).
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

  def send_destroy(project_id) do
    payload = %{ "id" => project_id }
    TodoWeb.Endpoint.broadcast("projects:lobby", "destroy_project", payload)
  end

  def send_created(project) do
    payload = %{ "id" => project.id, "title" => project.title, "color" => project.color }
    TodoWeb.Endpoint.broadcast("projects:lobby", "create_project", payload)
  end

  def send_updated(project) do
    payload = %{ "id" => project.id, "title" => project.title, "color" => project.color }
    TodoWeb.Endpoint.broadcast("projects:lobby", "update_project", payload)
  end
end
