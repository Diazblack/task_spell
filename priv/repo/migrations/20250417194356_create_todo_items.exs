defmodule TaskSpell.Repo.Migrations.CreateTodoItems do
  use Ecto.Migration

  def change do
    create table(:todo_items, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :title, :string
      add :description, :text
      add :is_done, :boolean, default: false, null: false
      add :completed_at, :utc_datetime
      add :due_at, :utc_datetime
      add :todo_list_id, references(:todo_lists, on_delete: :nothing, type: :binary_id)

      timestamps(type: :utc_datetime_usec)
    end

    create index(:todo_items, [:todo_list_id])
  end
end
