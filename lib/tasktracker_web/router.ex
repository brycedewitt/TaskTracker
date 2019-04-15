defmodule TasktrackerWeb.Router do
  use TasktrackerWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Tasktracker.Plugs.FetchSession
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", TasktrackerWeb do
    pipe_through :browser

    get "/", PageController, :index
    resources "/users", UserController
    resources "/tasks", TaskController
    resources "/rosters", RosterController
    resources "/sessions", SessionController, only: [:create, :delete], singleton: true

  end

  pipeline :ajax do
    plug :accepts, ["json"]
    plug :fetch_session
    plug :fetch_flash
  end

  scope "/ajax", TasktrackerWeb do
    pipe_through :ajax
    resources "/times", TimeController, except: [:new, :edit]
  end


  # Other scopes may use custom stacks.
  scope "/api", TaskTrackerWeb do
    # designate api pipe
    pipe_through :api

    # add route for editing tasks and users
    resources "/tasks", TaskController, except: [:new, :edit]
    resources "/users", UserController, except: [:new, :edit]

    # enable login through an authcontroller
    post "/auth", AuthController, :authenticate
  end


end
