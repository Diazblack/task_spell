defmodule TaskSpellWeb.TodoItemLive.Show do
  use TaskSpellWeb, :live_view

  # alias TaskSpell.Data
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

  @impl true
  def handle_info({TaskSpellWeb.TodoItemLive.FormComponent, {:saved, todo_item}}, socket) do
    {:noreply, stream_insert(socket, :todo_items, todo_item)}
  end
end
