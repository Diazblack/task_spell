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
        description: Faker.Commerce.product_name(),
        title: Faker.Lorem.Shakespeare.romeo_and_juliet()
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
        description: Faker.Lorem.Shakespeare.as_you_like_it(),
        due_at: random_datetime(),
        completed_at: Enum.random([nil, DateTime.utc_now()]),
        is_done: Enum.random([true, false]),
        title: Faker.Lorem.sentence(1)
      })
      |> TaskSpell.Data.create_todo_item()

    todo_item
  end

  defp random_datetime() do
    Faker.DateTime.between(~U[1985-04-03 10:35:00Z], ~U[2025-04-03 10:35:00Z])
  end
end
