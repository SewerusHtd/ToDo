defmodule TodoWeb.ProjectsViewTest do
  use TodoWeb.ConnCase, async: true
  alias Todo.Projects

  @create_attrs %{color: "#000000", title: "some title"}

  def fixture(:project) do
    {:ok, project} = Projects.create_project(@create_attrs)
    project
  end

  test "Should prepare error message" do
    error = {:title, {"can't be nil", [validation: :required]}}
    assert TodoWeb.ProjectsView.error_message(error) == "title: can't be nil"
  end

  test "Should prepare project styles" do
    project = fixture(:project)
    assert TodoWeb.ProjectsView.prepare_styles(project) =~ "box-shadow: 0 0 15px #{project.color};"
  end

  defp create_project(_) do
    project = fixture(:project)
    %{project: project}
  end
end
