defmodule TaskSpell.Repo.Migrations.CreateTodoLists do
  use Ecto.Migration

  def change do
    create table(:todo_lists, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :title, :string
      add :description, :text

      timestamps(type: :utc_datetime_usec)
    end
  end
end
