defmodule TodoWeb.ItemsViewTest do
  use TodoWeb.ConnCase, async: true
  alias Todo.Items
  alias Todo.Projects

  @project_attr %{color: "#000000", title: "some title"}
  @item_attr %{description: "some description"}

  def fixture(:project) do
    {:ok, project} = Projects.create_project(@project_attr)
    project
  end

  def fixture(:item) do
    project = fixture(:project)
    {:ok, item} = Items.create_item(Map.merge(@item_attr, %{ project_id: project.id}))
    item
  end

  test "Should prepare error message" do
    error = {:description, {"can't be nil", [validation: :required]}}
    assert TodoWeb.ItemsView.error_message(error) == "description: can't be nil"
  end

  test "Should prepare item styles" do
    assert TodoWeb.ItemsView.prepare_styles =~ "animation-duration: "
  end

  test "Should prepare item classes" do
    item = fixture(:item)
    assert TodoWeb.ItemsView.prepare_classes(item) == 'item incompleted'

    {:ok, item} = Items.mark_completed(item.id)
    assert TodoWeb.ItemsView.prepare_classes(item) == 'item completed'
  end

  test "Should prepare moving-item classes" do
    item = fixture(:item)
    assert TodoWeb.ItemsView.prepare_moving_item_classes(item) == "moving-item moving-item-#{ rem(item.id, 4) + 1 }"
  end

  defp create_item(_) do
    item = fixture(:item)
    %{item: item}
  end

  defp create_project(_) do
    project = fixture(:project)
    %{project: project}
  end
end
