defmodule TodoWeb.ProjectsControllerTest do
  use TodoWeb.ConnCase

  alias Todo.Projects
  alias Todo.Projects.Project
  alias Todo.Items.Item

  @create_attrs %{color: "#000000", title: "some title"}
  @update_attrs %{color: "#111111", title: "some updated title"}
  @invalid_attrs %{body: nil, title: nil}

  def fixture(:project) do
    {:ok, project} = Project.create_project(@create_attrs)
    project
  end

  describe "index" do
    test "GET /projects", %{conn: conn} do
      conn = get(conn, "/projects")
      assert html_response(conn, 200) =~ "Add a new project:"
    end
  end

#  describe "show" do
#    test "GET /projects/:id", %{conn: conn, project: project} do
#      conn = get(conn, "/projects/#{project.id}")
#      assert html_response(conn, 200) =~ project.title
#    end
#  end

#  describe "create project" do
#    test "redirects to show when data is valid", %{conn: conn} do
#      conn = post(conn, Routes.projects_path(conn, :create), post: @create_attrs)
#
#      assert %{id: id} = redirected_params(conn)
#      assert redirected_to(conn) == Routes.project_path(conn, :show, id)
#
#      conn = get(conn, Routes.project_path(conn, :show, id))
#      assert html_response(conn, 200) =~ "Show Post"
#    end
#
#    test "renders errors when data is invalid", %{conn: conn} do
#      conn = post(conn, Routes.projects_path(conn, :create), post: @invalid_attrs)
#      assert html_response(conn, 200) =~ "New Post"
#    end
#  end
end
