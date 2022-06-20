defmodule TodoWeb.ItemsControllerTest do
  use TodoWeb.ConnCase

  test "GET /items", %{conn: conn} do
    conn = get(conn, "/items")
    assert html_response(conn, 200) =~ "All tasks are here"
  end
end
