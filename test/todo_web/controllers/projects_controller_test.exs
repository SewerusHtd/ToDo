defmodule TodoWeb.ProjectsControllerTest do
  use TodoWeb.ConnCase

  alias Todo.Projects
  alias Todo.Projects.Project
  alias Todo.Items.Item

  @create_attrs %{color: "#000000", title: "some title"}
  @update_attrs %{color: "#111111", title: "some updated title"}
  @invalid_attrs %{color: nil, title: nil}

  def fixture(:project) do
    {:ok, project} = Projects.create_project(@create_attrs)
    project
  end

  describe "index" do
    test "GET /projects", %{conn: conn} do
      conn = get(conn, "/projects")
      assert html_response(conn, 200) =~ "Add a new project:"
    end
  end

  describe "show" do
    setup [:create_project]

    test "GET /projects/:id", %{conn: conn, project: project} do
      conn = get(conn, "/projects/#{project.id}")
      assert html_response(conn, 200) =~ project.title
    end
  end

  describe "create project" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.projects_path(conn, :create), project: @create_attrs)
      assert Projects.count == 1
      assert response_content_type(conn, :javascript) =~ "charset=utf-8"
      assert response(conn, 200) =~ "$(\"#project_title\").val(\"\");"
    end

    test "do not create project", %{conn: conn} do
      conn = post(conn, Routes.projects_path(conn, :create), project: @invalid_attrs)
      assert Projects.count == 0
      assert response_content_type(conn, :javascript) =~ "charset=utf-8"
      assert response(conn, 200) =~ "$(\"#project_title\").val(\"\");"
    end
  end

  defp create_project(_) do
    project = fixture(:project)
    %{project: project}
  end
end
