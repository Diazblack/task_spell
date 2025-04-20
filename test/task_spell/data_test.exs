defmodule TaskSpell.DataTest do
  use TaskSpell.DataCase

  alias TaskSpell.Data

  describe "todo_lists" do
    alias TaskSpell.Data.TodoList

    import TaskSpell.DataFixtures

    @invalid_attrs %{description: nil, title: nil}

    test "list_todo_lists/0 returns all todo_lists" do
      todo_list = todo_list_fixture()
      assert Data.list_todo_lists() == [todo_list]
    end

    test "get_todo_list!/1 returns the todo_list with given id and the preloaded todo_items" do
      tl = todo_list_fixture()
      ti1 = todo_item_fixture(%{todo_list_id: tl.id})
      ti2 = todo_item_fixture(%{todo_list_id: tl.id})
      ti3 = todo_item_fixture(%{todo_list_id: tl.id})
      ti4 = todo_item_fixture(%{todo_list_id: tl.id})
      db_tl = Data.get_todo_list!(tl.id)
      assert db_tl.id == tl.id
      assert assert db_tl.todo_items == [ti1, ti2, ti3, ti4]
    end

    test "create_todo_list/1 with valid data creates a todo_list" do
      valid_attrs = %{description: "some description", title: "some title"}

      assert {:ok, %TodoList{} = todo_list} = Data.create_todo_list(valid_attrs)
      assert todo_list.description == "some description"
      assert todo_list.title == "some title"
    end

    test "create_todo_list/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Data.create_todo_list(@invalid_attrs)
    end

    test "update_todo_list/2 with valid data updates the todo_list" do
      todo_list = todo_list_fixture()
      update_attrs = %{description: "some updated description", title: "some updated title"}

      assert {:ok, %TodoList{} = todo_list} = Data.update_todo_list(todo_list, update_attrs)
      assert todo_list.description == "some updated description"
      assert todo_list.title == "some updated title"
    end

    test "update_todo_list/2 with invalid data returns error changeset" do
      todo_list = todo_list_fixture()
      assert {:error, %Ecto.Changeset{}} = Data.update_todo_list(todo_list, @invalid_attrs)
      db_tl = Data.get_todo_list!(todo_list.id)
      assert todo_list.title == db_tl.title
      assert todo_list.description == db_tl.description
    end

    test "delete_todo_list/1 deletes the todo_list" do
      todo_list = todo_list_fixture()
      assert {:ok, %TodoList{}} = Data.delete_todo_list(todo_list)
      assert_raise Ecto.NoResultsError, fn -> Data.get_todo_list!(todo_list.id) end
    end

    test "change_todo_list/1 returns a todo_list changeset" do
      todo_list = todo_list_fixture()
      assert %Ecto.Changeset{} = Data.change_todo_list(todo_list)
    end
  end

  describe "todo_items" do
    alias TaskSpell.Data.TodoItem

    import TaskSpell.DataFixtures

    @invalid_attrs %{description: nil, title: nil, is_done: nil, completed_at: nil, due_at: nil, todo_list_id: nil}

    setup(context) do
      tl = todo_list_fixture()
      ti1 = todo_item_fixture(%{todo_list_id: tl.id})
      ti2 = todo_item_fixture(%{todo_list_id: tl.id})
      ti3 = todo_item_fixture(%{todo_list_id: tl.id})
      ti4 = todo_item_fixture(%{todo_list_id: tl.id})

      Map.merge(context, %{todo_list: tl, todo_items: [ti1, ti2, ti3, ti4]})
    end

    test "list_todo_items/0 returns all todo_items", %{todo_items: todo_items}  do
      assert Data.list_todo_items() == todo_items
    end

    test "get_todo_item!/1 returns the todo_item with given id", %{todo_items: [ti | _ ]} do
      assert Data.get_todo_item!(ti.id) == ti
    end

    test "create_todo_item/1 with valid data creates a todo_item", %{todo_list: tl } do
      valid_attrs = %{description: "some description", title: "some title", is_done: true, completed_at: ~U[2025-04-16 19:43:00Z], due_at: ~U[2025-04-16 19:43:00Z], todo_list_id: tl.id}

      assert {:ok, %TodoItem{} = todo_item} = Data.create_todo_item(valid_attrs)
      assert todo_item.description == "some description"
      assert todo_item.title == "some title"
      assert todo_item.is_done == true
      assert todo_item.completed_at == ~U[2025-04-16 19:43:00Z]
      assert todo_item.due_at == ~U[2025-04-16 19:43:00Z]
    end

    test "create_todo_item/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Data.create_todo_item(@invalid_attrs)
    end

    test "update_todo_item/2 with valid data updates the todo_item", %{todo_list: tl } do
      todo_item = todo_item_fixture(%{todo_list_id: tl.id})
      update_attrs = %{description: "some updated description", title: "some updated title", is_done: false, completed_at: ~U[2025-04-17 19:43:00Z], due_at: ~U[2025-04-17 19:43:00Z]}

      assert {:ok, %TodoItem{} = todo_item} = Data.update_todo_item(todo_item, update_attrs)
      assert todo_item.description == "some updated description"
      assert todo_item.title == "some updated title"
      assert todo_item.is_done == false
      assert todo_item.completed_at == ~U[2025-04-17 19:43:00Z]
      assert todo_item.due_at == ~U[2025-04-17 19:43:00Z]
    end

    test "update_todo_item/2 with invalid data returns error changeset", %{todo_list: tl } do
      todo_item = todo_item_fixture(%{todo_list_id: tl.id})
      assert {:error, %Ecto.Changeset{}} = Data.update_todo_item(todo_item, @invalid_attrs)
      assert todo_item == Data.get_todo_item!(todo_item.id)
    end

    test "delete_todo_item/1 deletes the todo_item", %{todo_list: tl } do
      todo_item = todo_item_fixture(%{todo_list_id: tl.id})
      assert {:ok, %TodoItem{}} = Data.delete_todo_item(todo_item)
      assert_raise Ecto.NoResultsError, fn -> Data.get_todo_item!(todo_item.id) end
    end

    test "change_todo_item/1 returns a todo_item changeset", %{todo_list: tl } do
      todo_item = todo_item_fixture(%{todo_list_id: tl.id})
      assert %Ecto.Changeset{} = Data.change_todo_item(todo_item)
    end
  end
end
