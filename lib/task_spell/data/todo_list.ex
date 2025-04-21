defmodule TaskSpell.Data.TodoList do
  use Ecto.Schema
  import Ecto.Changeset

  alias TaskSpell.Data.TodoItem

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "todo_lists" do
    field :description, :string
    field :title, :string

    has_many :todo_items, TodoItem
    timestamps(type: :utc_datetime_usec)
  end

  @doc false
  def changeset(todo_list, attrs) do
    todo_list
    |> cast(attrs, [:title, :description])
    |> validate_required([:title])
  end
end
