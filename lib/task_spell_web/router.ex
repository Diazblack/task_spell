defmodule TaskSpellWeb.Router do
  use TaskSpellWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {TaskSpellWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", TaskSpellWeb do
    pipe_through :browser

    get "/", PageController, :home

    # To-do Lists Routes
    live "/todo_lists", TodoListLive.Index, :index
    live "/todo_lists/new", TodoListLive.Index, :new
    live "/todo_lists/:id/edit", TodoListLive.Index, :edit

    live "/todo_lists/:id", TodoListLive.Show, :show
    live "/todo_lists/:id/show/edit", TodoListLive.Show, :edit

    # To-do Items Routes
    live "/todo_items/:id", TodoItemLive.Show, :show
    live "/todo_lists/:todo_list_id/todo_items/new", TodoItemLive.Show, :new
    live "/todo_items/:id/show/edit", TodoItemLive.Show, :edit
  end

  scope "/api/v1", TaskSpellWeb.API.V1, as: :api_v1 do
    pipe_through :api

    resources "/todo_lists", TodoListController, only: ~w[index create show update delete]a
  end
  # Other scopes may use custom stacks.
  # scope "/api", TaskSpellWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:task_spell, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: TaskSpellWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
