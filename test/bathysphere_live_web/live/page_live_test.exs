defmodule BathysphereLiveWeb.PageLiveTest do
  use BathysphereLiveWeb.ConnCase

  import Phoenix.LiveViewTest

  test "disconnected and connected render", %{conn: conn} do
    {:ok, _page_live, _disconnected_html} = live(conn, "/")
    # TODO
    # assert disconnected_html =~ "Welcome to Phoenix!"
    # assert render(page_live) =~ "Welcome to Phoenix!"
  end
end
