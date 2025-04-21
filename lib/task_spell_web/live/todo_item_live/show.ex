defmodule TaskSpellWeb.TodoItemLive.Show do
  use TaskSpellWeb, :live_view

  alias TaskSpell.Data
  alias TaskSpell.Data.TodoItem

  @impl true
  def mount(_params, _session, socket) do
    {:ok,  socket}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :new, %{"todo_list_id" => tl_id}) do
    socket
    |> assign(:page_title, "New Item")
    |> assign(:todo_item, %TodoItem{todo_list_id: tl_id})
  end

  defp apply_action(socket, action, %{"id" => id}) when action in ~w[show edit]a do
    socket
    |> assign(:page_title, page_title(socket.assigns.live_action))
    |> assign(:todo_item, Data.get_todo_item!(id))
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    todo_item = Data.get_todo_item!(id)
    {:ok, _} = Data.delete_todo_item(todo_item)

    {:noreply,
    socket
    |> put_flash(:info, "To-do Item successfully deleted")
    |> push_navigate(to: socket.assings.navigate)}
  end

  @impl true
  def handle_info({TaskSpellWeb.TodoItemLive.FormComponent, {:saved, todo_item}}, socket) do
    {:noreply, stream_insert(socket, :todo_items, todo_item)}
  end

  defp page_title(:show), do: "Show To-do item"
  defp page_title(:edit), do: "Edit To-do item"
end
