# 🪄 TaskSpell

TaskSpell is an enchanted to-do list application built with Elixir, Phoenix, and LiveView, designed to help you conjure order from chaos. With real-time interactions, magical task management, and an intuitive UI, TaskSpell makes your daily planning feel like spellcasting.
Features (under construction):
  * ✨ Create, update, and complete tasks in real time
  * 🔮 Deadlines and reminders for each task (a.k.a. temporal enchantments)
  * 📜 Organize your tasks into categories (a.k.a. spellbooks)
  * 🧙‍♂️ Built with the power of Elixir & Phoenix LiveView for a smooth UX
  * 📦 Easily deployable and extensible—ready for your own potions

Whether you’re a productivity wizard or just a humble spell-slinger trying to manage your day, TaskSpell has you covered.
To start your Phoenix server:

# Installation 
  Follow the instructions to install Elixir 1.18.3-otp-27 [Elixir Lang Org Page](https://elixir-lang.org/install.html) 
  If you have a different version of Elixir installed, I recommend using asdf for version management. 
  For more information visit [asdf homepage](https://asdf-vm.com/guide/getting-started.html)

### Elixir/Phoenix
  Follow the [Phoenix](https://hexdocs.pm/phoenix/installation.html) installation guide to install all the required dependencies.

  * This application requires Elixir version 1.18.3-otp-27 [Elixir Lang Org Page](https://elixir-lang.org/install.html) and Erlang version 27.3.1
  * If you have a different version of Elixir and Erlang installed, I recommend using asdf for version management. For more information visit [asdf homepage](https://asdf-vm.com/guide/getting-started.html)

### Postgres & DB Setup

1. You will need PostgreSQL running in you local machine. If you are in an IOS environment homebrew is onw of the easiest ways to install by `brew install postgresql`. [Here] is a wiki link with more information about how to install PostgreSQL

2. Follow the homebrew install advice on how to run the database manually when needed, or for convenience, you can run it automatically on boot by running `brew services start postgresql` once.

3. Create a `postgres` user for the database: `createuser -s postgres` if needed 

4. Create and migrate your database with `mix ecto.setup`

5. Seed your database by running `Run `mix seed` to run the seed file `

6. Start Phoenix server byt running `mix phx.server` or if you prefer to start the server along side IEx run `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000/todo_lists) from your browser.


# API Endpoints 

## TodoList 

### Index 

Send an HTTP `GET` request to the URL `http://localhost:4000/api/v1/todo_lists`. The endpoint will return a `200` response with the following body: 

```elixir
{
	"data": [
		{
			"id": "d1a3ae36-db40-4fca-b0ca-f8a414eaba5e",
			"description": "Weekly grocery run",
			"title": "Grocery Shopping"
		},
		{
			"id": "22bb68f1-ab82-49cb-aa38-d4b66588c84a",
			"description": "Tasks to keep the house in shape",
			"title": "Home Maintenance"
		},
		{
			"id": "49c437fd-a418-40a5-a5b2-68193fd6b755",
			"description": "Sprint planning and deliverables",
			"title": "Work Projects"
		},
		{
			"id": "1bd30b95-f8c2-489a-bf95-64d4f4f9bac9",
			"description": "Things to do before the beach trip",
			"title": "Vacation Prep"
		},
		{
			"id": "7bb2ef54-f329-4a94-a8cb-66f1c51a61df",
			"description": "Personal tasks and wellness goals",
			"title": "Self Care"
		}
	]
}
```

### Show 

Send an HTTP `GET` request to the URL `http://localhost:4000/api/v1/:id`, make sure to use the TodoList `id` exist in your DB. 

The endpoint will return a `200` response with:

```JSON
{
	"data": {
		"id": "d1a3ae36-db40-4fca-b0ca-f8a414eaba5e",
		"description": "Weekly grocery run",
		"title": "Grocery Shopping"
	}
}

```

### Create 

Send an HTTP `POST` request to the URL `http://localhost:4000/api/v1/`, with: 
```JSON
{
  "todo_list": {
		"title": "Home Renovation Projects",
  	"description": "A master list to track various small and big tasks for upgrading the house."
 	}
}
```

The endpoint will return a `201` response with:

```JSON
{
	"data": {
		"id": "7bd91916-277e-44c1-b357-8f09320ca091",
		"description": "A master list to track various small and big tasks for upgrading the house.",
		"title": "Home Renovation Projects"
	}
}
```
### Update 

Send an HTTP `PUT` or `PATCH` request to the URL `http://localhost:4000/api/:id` with: 
```JSON
{
  "todo_list": {
  	"description": "A master list to track various small and big tasks for upgrading the house. But lets be honest, you know that you never going to fully finish any of these."
 	}
}
```
Make sure to use the TodoList `id` exist in your DB. The endpoint will return a `200` response with:

```JSON
{
	"data": {
		"id": "7bd91916-277e-44c1-b357-8f09320ca091",
		"description": "A master list to track various small and big tasks for upgrading the house. But lets be honest, you know that you never going to fully finish any of these.",
		"title": "Home Renovation Projects"
	}
}
```

### Delete 
Send an HTTP `DELETE` request to the URL `http://localhost:4000/api/:id`. Make sure to use the TodoList `id` exist in your DB. 

The endpoint will return a `204` response with no body. 

## TodoItems 

### Index 

Send an HTTP `GET` request to the URL `http://localhost:4000/api/v1/todo_lists/:todo_list_id/todo_items`. The endpoint will return a `200` response with the following body: 

NOTE: Make sure to use the TodoList `todo_list_id` exist in your DB.

```elixir
{
	"data": [
		{
			"id": "af5d8337-0f42-4e14-b319-3414a6f681ca",
			"description": "Organic large brown eggs for baking and breakfast.",
			"title": "Buy eggs",
			"completed_at": null,
			"due_at": "2025-05-03T03:14:44Z",
			"is_done": false
		},
		{
			"id": "c023d2d7-c6e0-4ccf-b9e2-2f01d77eaa33",
			"description": "Unsweetened vanilla for smoothies and cereal.",
			"title": "Buy almond milk",
			"completed_at": null,
			"due_at": "2025-05-03T14:34:20Z",
			"is_done": false
		},
		{
			"id": "395fa991-67aa-4a26-ad62-83e952d87bf5",
			"description": "Look for ripe but not overripe bananas.",
			"title": "Pick up bananas",
			"completed_at": null,
			"due_at": "2025-05-01T08:59:28Z",
			"is_done": false
		},
		{
			"id": "15992634-d8ca-4fe7-acfa-415ad89e4ac3",
			"description": "Preferably dark roast or espresso blend.",
			"title": "Restock coffee beans",
			"completed_at": "2025-04-22T09:07:05Z",
			"due_at": "2025-04-24T01:05:48Z",
			"is_done": true
		},
		{
			"id": "b920ad54-b2ca-4a89-84dd-dc22311dd0e9",
			"description": "Mixed stir-fry bag for quick dinners.",
			"title": "Get frozen veggies",
			"completed_at": "2025-04-18T23:59:49Z",
			"due_at": "2025-04-23T10:51:06Z",
			"is_done": true
		}
	]
}
```

### Show 

Send an HTTP `GET` request to the URL `http://localhost:4000/api/v1/todo_lists/:todo_list_id/todo_items:id`, make sure to use the TodoList and TodoItem `ids` exist in your DB. 

The endpoint will return a `200` response with:

```JSON
{
	"data": {
		"id": "cfe428bd-f296-4323-8e5e-bc3413aff683",
		"description": "Choose a calming shade, prep the walls, and apply two coats of paint. Don’t forget the trim!",
		"title": "Paint the guest bedroom",
		"completed_at": "2025-04-11T12:00:00Z",
		"due_at": "2025-04-11T12:00:00Z",
		"is_done": false
	}
}

```

### Create 

Send an HTTP `POST` request to the URL `http://localhost:4000/api/v1/todo_lists/:todo_list_id/todo_items`, with: 
```JSON
{
 "todo_item": {
    "title": "Paint the guest bedroom",
    "description": "Choose a calming shade, prep the walls, and apply two coats of paint. Don’t forget the trim!",
    "due_at": "2025-04-11T12:00:00Z",
    "completed_at": "",
    "is_done": false
  }
}
```
Make sure to use the TodoList `id` exist in your DB

The endpoint will return a `201` response with:

```JSON
{
	"data": {
		"id": "cfe428bd-f296-4323-8e5e-bc3413aff683",
		"description": "Choose a calming shade, prep the walls, and apply two coats of paint. Don’t forget the trim!",
		"title": "Paint the guest bedroom",
		"completed_at": null,
		"due_at": "2025-04-11T12:00:00Z",
		"is_done": false
	}
}
```
### Update 

Send an HTTP `PUT` or `PATCH` request to the URL `http://localhost:4000/api/v1/todo_lists/:todo_list_id/todo_items/:id` with: 
```JSON
{
 "todo_item": {
    "completed_at": "2025-04-11T12:00:00Z"
  }
}
```
Make sure to use the TodoList and TodoItem `ids` exist in your DB. The endpoint will return a `200` response with:

```JSON
{
	"data": {
		"id": "cfe428bd-f296-4323-8e5e-bc3413aff683",
		"description": "Choose a calming shade, prep the walls, and apply two coats of paint. Don’t forget the trim!",
		"title": "Paint the guest bedroom",
		"completed_at": "2025-04-11T12:00:00Z",
		"due_at": "2025-04-11T12:00:00Z",
		"is_done": false
	}
}
```

### Delete 
Send an HTTP `DELETE` request to the URL `http://localhost:4000/api/v1/todo_lists/:todo_list_id/todo_items/:id`. Make sure to use the TodoList `id` exist in your DB. 

The endpoint will return a `204` response with no body. 
## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix
