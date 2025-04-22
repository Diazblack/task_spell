# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
alias TaskSpell.Repo
alias TaskSpell.Data.{TodoList, TodoItem}

defmodule Seeds do
  def create_data do
    todo_lists_data = [
      %{
        title: "Grocery Shopping",
        description: "Weekly grocery run",
        items: [
          {"Buy eggs", "Organic large brown eggs for baking and breakfast."},
          {"Buy almond milk", "Unsweetened vanilla for smoothies and cereal."},
          {"Pick up bananas", "Look for ripe but not overripe bananas."},
          {"Restock coffee beans", "Preferably dark roast or espresso blend."},
          {"Get frozen veggies", "Mixed stir-fry bag for quick dinners."}
        ]
      },
      %{
        title: "Home Maintenance",
        description: "Tasks to keep the house in shape",
        items: [
          {"Change HVAC filter", "Replace with a MERV-8 filter, 20x25x1 size."},
          {"Clean gutters", "Clear leaves and debris to prevent water backup."},
          {"Test smoke detectors", "Ensure all alarms have working batteries."},
          {"Patch wall in hallway", "Use spackling paste and repaint over patch."}
        ]
      },
      %{
        title: "Work Projects",
        description: "Sprint planning and deliverables",
        items: [
          {"Prepare presentation for stakeholders", "Focus on Q2 metrics and OKRs."},
          {"Fix login bug", "Investigate token expiry and refresh logic."},
          {"Review PR #327", "Ensure code quality and test coverage are sufficient."},
          {"Write tests for new feature", "Include edge cases and property-based tests."}
        ]
      },
      %{
        title: "Vacation Prep",
        description: "Things to do before the beach trip",
        items: [
          {"Book Airbnb", "Look for pet-friendly places with ocean view."},
          {"Buy sunscreen", "Water-resistant SPF 50+ recommended."},
          {"Pack clothes", "Include both casual and evening outfits."},
          {"Print boarding passes", "Double-check passport expiration date."},
          {"Notify neighbor to pick up mail", "Leave mailbox key and instructions."}
        ]
      },
      %{
        title: "Self Care",
        description: "Personal tasks and wellness goals",
        items: [
          {"Read 10 pages", "Currently reading 'The Power of Now'."},
          {"Book therapy session", "Schedule for next Tuesday afternoon."},
          {"Go for a run", "Minimum 3 miles, preferably around the park."},
          {"Drink 2L of water", "Track via water reminder app."},
          {"Meditate for 10 minutes", "Use Headspace or Calm to guide session."}
        ]
      }
    ]

    Enum.each(todo_lists_data, fn %{title: title, description: desc, items: items} ->
      todo_list = Repo.insert!(%TodoList{
        title: title,
        description: desc
      })

      Enum.each(items, fn {item_title, item_desc} ->
        is_done = Enum.random([true, false])
        completed_at = if is_done, do: random_datetime_past(), else: nil

        Repo.insert!(%TodoItem{
          title: item_title,
          description: item_desc,
          is_done: is_done,
          completed_at: completed_at,
          due_at: random_future_datetime(),
          todo_list_id: todo_list.id
        })
      end)
    end)
  end

  def random_datetime_past do
    DateTime.utc_now()
    |> DateTime.add(-Enum.random(60..1_000_000), :second)
    |> DateTime.truncate(:second)
  end

  def random_future_datetime do
    DateTime.utc_now()
    |> DateTime.add(Enum.random(60..1_000_000), :second)
    |> DateTime.truncate(:second)
  end
end

Seeds.create_data()
