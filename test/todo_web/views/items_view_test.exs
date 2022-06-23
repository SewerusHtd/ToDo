defmodule TodoWeb.ItemsViewTest do
  use TodoWeb.ConnCase, async: true

  test "Should prepare error message" do
    error = {:description, {"can't be nil", [validation: :required]}}
    assert TodoWeb.ItemsView.error_message(error) == "description: can't be nil"
  end
end
