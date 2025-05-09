defmodule TaskSpellWeb.API.V1.TodoListController do
  use TaskSpellWeb, :controller

  alias TaskSpell.Data
  alias TaskSpell.Data.TodoList

  action_fallback TaskSpellWeb.FallbackController

  def index(conn, _params) do
    todo_lists = Data.list_todo_lists()
    render(conn, :index, todo_lists: todo_lists)
  end

  def create(conn, %{"todo_list" => todo_list_params}) do
    with {:ok, %TodoList{} = todo_list} <- Data.create_todo_list(todo_list_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/v1/todo_lists/#{todo_list}")
      |> render(:show, todo_list: todo_list)
    end
  end

  def show(conn, %{"id" => id}) do
    todo_list = Data.get_todo_list!(id)
    render(conn, :show, todo_list: todo_list)
  end

  def update(conn, %{"id" => id, "todo_list" => todo_list_params}) do
    todo_list = Data.get_todo_list!(id)

    with {:ok, %TodoList{} = todo_list} <- Data.update_todo_list(todo_list, todo_list_params) do
      render(conn, :show, todo_list: todo_list)
    end
  end

  def delete(conn, %{"id" => id}) do
    todo_list = Data.get_todo_list!(id)

    with {:ok, %TodoList{}} <- Data.delete_todo_list(todo_list) do
      send_resp(conn, :no_content, "")
    end
  end
end
