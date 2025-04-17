defmodule TaskSpell.Data.TodoItem do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "todo_items" do
    field :description, :string
    field :title, :string
    field :is_done, :boolean, default: false
    field :completed_at, :utc_datetime
    field :due_at, :utc_datetime
    field :todo_list_id, :binary_id

    timestamps(type: :utc_datetime_usec)
  end

  @doc false
  def changeset(todo_item, attrs) do
    todo_item
    |> cast(attrs, [:title, :description, :is_done, :completed_at, :due_at])
    |> validate_required([:title])
  end
end
