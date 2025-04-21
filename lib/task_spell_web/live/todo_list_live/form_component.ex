defmodule TaskSpellWeb.TodoListLive.FormComponent do
  use TaskSpellWeb, :live_component

  alias TaskSpell.Data

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        {@title}
      </.header>

      <.simple_form
        for={@form}
        id="todo_list-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:title]} type="text" label="Title" />
        <.input field={@form[:description]} type="textarea" label="Description" />
        <:actions>
          <.button phx-disable-with="Saving...">Save to-do list</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{todo_list: todo_list} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(Data.change_todo_list(todo_list))
     end)}
  end

  @impl true
  def handle_event("validate", %{"todo_list" => todo_list_params}, socket) do
    changeset = Data.change_todo_list(socket.assigns.todo_list, todo_list_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"todo_list" => todo_list_params}, socket) do
    save_todo_list(socket, socket.assigns.action, todo_list_params)
  end

  defp save_todo_list(socket, :edit, todo_list_params) do
    case Data.update_todo_list(socket.assigns.todo_list, todo_list_params) do
      {:ok, todo_list} ->
        notify_parent({:saved, todo_list})

        {:noreply,
         socket
         |> put_flash(:info, "To-do list updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_todo_list(socket, :new, todo_list_params) do
    case Data.create_todo_list(todo_list_params) do
      {:ok, todo_list} ->
        notify_parent({:saved, todo_list})

        {:noreply,
         socket
         |> put_flash(:info, "To-do list created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
