defmodule TaskSpellWeb.TodoItemLive.FormComponent do
  use TaskSpellWeb, :live_component

  alias TaskSpell.Data

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        {@title}
        <:subtitle>Add all the relevant information.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="todo_item-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:title]} type="text" label="Title" />
        <.input field={@form[:description]} type="textarea" label="Description" />
        <.input field={@form[:completed_at]} type="datetime-local" label="Completed at" />
        <.input field={@form[:due_at]} type="datetime-local" label="Due at" />
        <.input field={@form[:is_done]} type="checkbox" label="Checked" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Item</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{todo_item: todo_item} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(Data.change_todo_item(todo_item))
     end)}
  end

  @impl true
  def handle_event("validate", %{"todo_item" => todo_item_params}, socket) do
    changeset = Data.change_todo_item(socket.assigns.todo_item, todo_item_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"todo_item" => todo_item_params}, socket) do
    save_todo_item(socket, socket.assigns.action, todo_item_params)
  end

  defp save_todo_item(socket, :edit, todo_item_params) do
    case Data.update_todo_item(socket.assigns.todo_item, todo_item_params) do
      {:ok, todo_item} ->
        notify_parent({:saved, todo_item})

        {:noreply,
         socket
         |> put_flash(:info, "Todo Item updated successfully")
         |> push_navigate(to: socket.assigns.navigate)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_todo_item(socket, :new, todo_item_params) do
    case Data.create_todo_item(socket.assigns.todo_item, todo_item_params) do
      {:ok, todo_item} ->
        notify_parent({:saved, todo_item})

        {:noreply,
         socket
         |> put_flash(:info, "Todo Item created successfully")
         |> push_navigate(to: socket.assigns.navigate)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
