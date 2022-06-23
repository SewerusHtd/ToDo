defmodule TodoWeb.ProjectsViewTest do
  use TodoWeb.ConnCase, async: true

  test "Should prepare error message" do
    error = {:title, {"can't be nil", [validation: :required]}}
    assert TodoWeb.ProjectsView.error_message(error) == "title: can't be nil"
  end
end
