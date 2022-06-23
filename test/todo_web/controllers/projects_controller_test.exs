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
      conn = get(conn, Routes.projects_path(conn, :show, project.id))
      assert html_response(conn, 200) =~ project.title
    end
  end

  describe "create project" do
    test "create project when data is valid", %{conn: conn} do
      conn = post(conn, Routes.projects_path(conn, :create), project: @create_attrs)
      assert Projects.count == 1
      assert response_content_type(conn, :javascript) =~ "charset=utf-8"
      assert response(conn, 200) == "$(\"#project_title\").val(\"\");\n$(\"#project-form-errors\").html(\"\");\n"
    end

    test "do not create project when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.projects_path(conn, :create), project: @invalid_attrs)
      assert Projects.count == 0
      assert response_content_type(conn, :javascript) =~ "charset=utf-8"
      assert response(conn, 200) =~ "$(\"#project_title\").val(\"\");"
      assert response(conn, 200) =~ "title: can&#39;t be blank"
      assert response(conn, 200) =~ "color: can&#39;t be blank"
    end
  end

  describe "edit" do
    setup [:create_project]

    test "GET /projects/:id/edit", %{conn: conn, project: project} do
      conn = get(conn, Routes.projects_path(conn, :edit, project.id))
      assert response_content_type(conn, :javascript) =~ "charset=utf-8"
      assert response(conn, 200) =~ project.title
      assert response(conn, 200) =~ project.color
      assert response(conn, 200) =~ "input"
    end
  end

  describe "update project" do
    setup [:create_project]

    test "update project when data is valid", %{conn: conn, project: project} do
      conn = put(conn, Routes.projects_path(conn, :update, project.id), project: @update_attrs)
      assert response_content_type(conn, :javascript) =~ "charset=utf-8"
      assert response(conn, 200) =~ @update_attrs[:title]
      assert response(conn, 200) =~ @update_attrs[:color]
    end

    test "do not update project when data is invalid", %{conn: conn, project: project} do
      conn = put(conn, Routes.projects_path(conn, :update, project.id), project: @invalid_attrs)
      assert response_content_type(conn, :javascript) =~ "charset=utf-8"
      assert response(conn, 200) =~ "title: can&#39;t be blank"
      assert response(conn, 200) =~ "color: can&#39;t be blank"
    end
  end

  describe "delete" do
    setup [:create_project]

    test "DELETE /projects/:id", %{conn: conn, project: project} do
      conn = delete(conn, Routes.projects_path(conn, :delete, project.id))
      assert Projects.count == 0
      assert redirected_to(conn) == Routes.projects_path(conn, :index)
    end
  end

  defp create_project(_) do
    project = fixture(:project)
    %{project: project}
  end
end
