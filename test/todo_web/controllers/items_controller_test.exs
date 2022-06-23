defmodule TodoWeb.ItemsControllerTest do
  use TodoWeb.ConnCase

  alias Todo.Items
  alias Todo.Items.Item
  alias Todo.Projects

  @project_attr %{color: "#000000", title: "some title"}
  @valid_item_attr %{description: "some description"}
  @invalid_item_attr %{description: nil}

  def fixture(:project) do
    {:ok, project} = Projects.create_project(@project_attr)
    project
  end

  def fixture(:item) do
    project = fixture(:project)
    {:ok, item} = Items.create_item(Map.merge(@valid_item_attr, %{ project_id: project.id}))
    item
  end

  test "GET /items", %{conn: conn} do
    conn = get(conn, "/items")
    assert html_response(conn, 200) =~ "All tasks are here"
  end

  describe "create item" do
    test "create item when data is valid", %{conn: conn} do
      project = fixture(:project)
      conn = post(conn, Routes.items_path(conn, :create), item: Map.merge(@valid_item_attr, %{ project_id: project.id}))
      assert Items.count == 1
      assert response_content_type(conn, :javascript) =~ "charset=utf-8"
      assert response(conn, 200) == "$(\"#item-form-errors\").html(\"\");\n"
    end

    test "do not create item when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.items_path(conn, :create), item: @invalid_item_attr)
      assert Items.count == 0
      assert response_content_type(conn, :javascript) =~ "charset=utf-8"
      assert response(conn, 200) =~ "$(\"#item-form-errors\").html(\"\");\n"
      assert response(conn, 200) =~ "project_id: can&#39;t be blank"
      assert response(conn, 200) =~ "description: can&#39;t be blank"
    end
  end

  describe "delete" do
    setup [:create_item]

    test "DELETE /items/:id", %{conn: conn, item: item} do
      conn = delete(conn, Routes.items_path(conn, :delete, item.id))
      assert Items.count == 0
      assert response(conn, 200)
    end
  end

  describe "complete" do
    setup [:create_item]

    test "PATCH /items/:id/complete", %{conn: conn, item: item} do
      conn = patch(conn, Routes.items_path(conn, :complete, item.id))
      assert Items.get_item(item.id).completed == true
      assert response(conn, 200)
    end
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
