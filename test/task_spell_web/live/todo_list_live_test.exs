defmodule TaskSpellWeb.TodoListLiveTest do
  use TaskSpellWeb.ConnCase

  import Phoenix.LiveViewTest
  import TaskSpell.DataFixtures

  @create_attrs %{description: "some description", title: "some title"}
  @update_attrs %{description: "some updated description", title: "some updated title"}
  @invalid_attrs %{description: nil, title: nil}

  describe "Index" do
    setup [:create_todo_list]

    test "lists all todo_lists", %{conn: conn, todo_list: todo_list} do
      {:ok, _index_live, html} = live(conn, ~p"/todo_lists")

      assert html =~ "To-do Lists"
      assert html =~ todo_list.description
    end

    test "saves new todo_list", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/todo_lists")

      assert index_live |> element("a", "New List") |> render_click() =~
               "New List"

      assert_patch(index_live, ~p"/todo_lists/new")

      assert index_live
             |> form("#todo_list-form", todo_list: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#todo_list-form", todo_list: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/todo_lists")

      html = render(index_live)
      assert html =~ "To-do list created successfully"
      assert html =~ "some description"
    end

    test "updates todo_list in listing", %{conn: conn, todo_list: todo_list} do
      {:ok, index_live, _html} = live(conn, ~p"/todo_lists")

      assert index_live |> element("#todo_lists-#{todo_list.id} a", "Edit") |> render_click() =~
               "Edit List"

      assert_patch(index_live, ~p"/todo_lists/#{todo_list}/edit")

      assert index_live
             |> form("#todo_list-form", todo_list: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#todo_list-form", todo_list: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/todo_lists")

      html = render(index_live)
      assert html =~ "To-do list updated successfully"
      assert html =~ "some updated description"
    end

    test "deletes todo_list in listing", %{conn: conn, todo_list: todo_list} do
      {:ok, index_live, _html} = live(conn, ~p"/todo_lists")

      assert index_live |> element("#todo_lists-#{todo_list.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#todo_lists-#{todo_list.id}")
    end
  end

  describe "Show" do
    setup [:create_todo_list]

    test "displays todo_list", %{conn: conn, todo_list: todo_list} do
      {:ok, _show_live, html} = live(conn, ~p"/todo_lists/#{todo_list}")

      assert html =~ "Show List"
      assert html =~ todo_list.description
    end

    test "updates todo_list within modal", %{conn: conn, todo_list: todo_list} do
      {:ok, show_live, _html} = live(conn, ~p"/todo_lists/#{todo_list}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit List"

      assert_patch(show_live, ~p"/todo_lists/#{todo_list}/show/edit")

      assert show_live
             |> form("#todo_list-form", todo_list: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#todo_list-form", todo_list: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/todo_lists/#{todo_list}")

      html = render(show_live)
      assert html =~ "To-do list updated successfully"
      assert html =~ "some updated description"
    end
  end

  defp create_todo_list(_) do
    todo_list = todo_list_fixture()
    %{todo_list: todo_list}
  end
end
