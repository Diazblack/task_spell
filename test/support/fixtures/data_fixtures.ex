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
end
