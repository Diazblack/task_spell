defmodule TaskSpellWeb.API.V1.TodoItemController do
  use TaskSpellWeb, :controller

  alias TaskSpell.Data
  alias TaskSpell.Data.TodoItem
  alias TaskSpell.Data.TodoList

  action_fallback TaskSpellWeb.FallbackController

  def index(conn, %{"todo_list_id" => tlid}) do
    with %TodoList{id: id} <- Data.get_todo_list!(tlid),
      todo_items <- Data.list_todo_items_by_list(id) do
        render(conn, :index, todo_items: todo_items)
    end
  end

  def create(conn, %{"todo_item" => todo_item_params, "todo_list_id" => tl_id}) do
    params = Map.put(todo_item_params, "todo_list_id", tl_id)
    with {:ok, %TodoItem{} = todo_item} <- Data.create_todo_item(params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/v1/todo_lists/#{tl_id}/todo_items/#{todo_item}")
      |> render(:show, todo_item: todo_item)
    end
  end

  def show(conn, %{"id" => id}) do
    todo_item = Data.get_todo_item!(id)
    render(conn, :show, todo_item: todo_item)
  end

  def update(conn, %{"id" => id, "todo_item" => todo_item_params}) do
    todo_item = Data.get_todo_item!(id)

    with {:ok, %TodoItem{} = todo_item} <- Data.update_todo_item(todo_item, todo_item_params) do
      render(conn, :show, todo_item: todo_item)
    end
  end

  def delete(conn, %{"id" => id}) do
    todo_item = Data.get_todo_item!(id)

    with {:ok, %TodoItem{}} <- Data.delete_todo_item(todo_item) do
      send_resp(conn, :no_content, "")
    end
  end
end
