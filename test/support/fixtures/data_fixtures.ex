defmodule TaskSpell.DataFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `TaskSpell.Data` context.
  """

  @doc """
  Generate a todo_list.
  """
  def todo_list_fixture(attrs \\ %{}) do
    {:ok, todo_list} =
      attrs
      |> Enum.into(%{
        description: "some description",
        title: "some title"
      })
      |> TaskSpell.Data.create_todo_list()

    todo_list
  end

  @doc """
  Generate a todo_item.
  """
  def todo_item_fixture(attrs \\ %{}) do
    {:ok, todo_item} =
      attrs
      |> Enum.into(%{
        completed_at: ~U[2025-04-16 19:43:00Z],
        description: "some description",
        due_at: ~U[2025-04-16 19:43:00Z],
        is_done: true,
        title: "some title"
      })
      |> TaskSpell.Data.create_todo_item()

    todo_item
  end
end
