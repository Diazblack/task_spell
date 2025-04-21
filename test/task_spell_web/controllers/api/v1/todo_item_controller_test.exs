defmodule TaskSpellWeb.API.V1.TodoItemControllerTest do
  use TaskSpellWeb.ConnCase

  import TaskSpell.DataFixtures

  alias TaskSpell.Data.TodoItem

  @create_attrs %{
    description: "some description",
    title: "some title",
    is_done: true,
    completed_at: ~U[2025-04-20 18:52:00Z],
    due_at: ~U[2025-04-20 18:52:00Z],
    todo_list_id: nil
  }
  @update_attrs %{
    description: "some updated description",
    title: "some updated title",
    is_done: false,
    completed_at: ~U[2025-04-21 18:52:00Z],
    due_at: ~U[2025-04-21 18:52:00Z]
  }
  @invalid_attrs %{description: nil, title: nil, is_done: nil, completed_at: nil, due_at: nil, todo_list_id: nil}

  setup %{conn: conn} = context do
    todo_list = todo_list_fixture()

    {:ok, Map.merge(context, %{ conn: put_req_header(conn, "accept", "application/json"), todo_list: todo_list})}
  end

  describe "index" do
    test "lists all todo_items in the todo_list", %{conn: conn, todo_list: tl} do
      ti1 = todo_item_fixture(%{todo_list_id: tl.id})
      ti2 = todo_item_fixture(%{todo_list_id: tl.id})
      ti3 = todo_item_fixture(%{todo_list_id: tl.id})
      ti4 = todo_item_fixture(%{todo_list_id: tl.id})

      conn = get(conn, ~p"/api/v1/todo_lists/#{tl}/todo_items")
      [item_1, item_2, item_3, item_4] = json_response(conn, 200)["data"]
      assert item_1["id"] == ti1.id
      assert item_2["id"] == ti2.id
      assert item_3["id"] == ti3.id
      assert item_4["id"] == ti4.id
    end
  end

  describe "create todo_item" do
    test "renders todo_item when data is valid", %{conn: conn, todo_list: tl} do
      conn = post(conn, ~p"/api/v1/todo_lists/#{tl}/todo_items", todo_item: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/v1/todo_lists/#{tl}/todo_items/#{id}")

      assert %{
               "id" => ^id,
               "completed_at" => "2025-04-20T18:52:00Z",
               "description" => "some description",
               "due_at" => "2025-04-20T18:52:00Z",
               "is_done" => true,
               "title" => "some title"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, todo_list: tl} do
      conn = post(conn, ~p"/api/v1/todo_lists/#{tl}/todo_items", todo_item: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update todo_item" do
    setup [:create_todo_item]

    test "renders todo_item when data is valid", %{conn: conn, todo_list: tl, todo_item: %TodoItem{id: id} = todo_item} do
      conn = put(conn, ~p"/api/v1/todo_lists/#{tl}/todo_items/#{todo_item}", todo_item: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/v1/todo_lists/#{tl}/todo_items/#{id}")

      assert %{
               "id" => ^id,
               "completed_at" => "2025-04-21T18:52:00Z",
               "description" => "some updated description",
               "due_at" => "2025-04-21T18:52:00Z",
               "is_done" => false,
               "title" => "some updated title"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, todo_list: tl, todo_item: todo_item} do
      conn = put(conn, ~p"/api/v1/todo_lists/#{tl}/todo_items/#{todo_item}", todo_item: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete todo_item" do
    setup [:create_todo_item]

    test "deletes chosen todo_item", %{conn: conn, todo_list: tl, todo_item: todo_item} do
      conn = delete(conn, ~p"/api/v1/todo_lists/#{tl}/todo_items/#{todo_item}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/v1/todo_lists/#{tl}/todo_items/#{todo_item}")
      end
    end
  end

  defp create_todo_item(%{todo_list: todo_list}) do
    todo_item = todo_item_fixture(%{todo_list_id: todo_list.id})
    %{todo_item: todo_item, todo_list: todo_list}
  end
end
