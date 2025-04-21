defmodule TaskSpellWeb.API.V1.TodoItemJSON do
  alias TaskSpell.Data.TodoItem

  @doc """
  Renders a list of todo_items.
  """
  def index(%{todo_items: todo_items}) do
    %{data: for(todo_item <- todo_items, do: data(todo_item))}
  end

  @doc """
  Renders a single todo_item.
  """
  def show(%{todo_item: todo_item}) do
    %{data: data(todo_item)}
  end

  defp data(%TodoItem{} = todo_item) do
    %{
      id: todo_item.id,
      title: todo_item.title,
      description: todo_item.description,
      is_done: todo_item.is_done,
      completed_at: todo_item.completed_at,
      due_at: todo_item.due_at
    }
  end
end
