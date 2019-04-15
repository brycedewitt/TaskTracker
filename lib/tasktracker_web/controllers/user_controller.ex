defmodule TasktrackerWeb.UserController do
  use TasktrackerWeb, :controller

  alias Tasktracker.Users
  alias Tasktracker.Users.User
  alias Tasktracker.Rosters
  alias Tasktracker.Tasks


  def index(conn, _params) do
    users = Users.list_users()
    render(conn, "index.html", users: users)
  end

  def new(conn, _params) do
    changeset = Users.change_user(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    IO.inspect(user_params)
    case Users.create_user(user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User created successfully.")
        |> put_session(:user_id, user.id)
        |> redirect(to: Routes.user_path(conn, :show, user))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    user = Users.get_user!(id)
    rosters =
      Tasktracker.Rosters.get_underlings(id)
      |> Enum.map(fn x -> Users.get_user!(x) end)

    supervisors =
      Tasktracker.Rosters.get_supervisors(id)
      |> Enum.map(fn x -> Users.get_user!(x) end)

    taskreport =
      Tasktracker.Rosters.get_underlings(id)
      |> Enum.map(fn x -> Tasks.get_task_by_user_id(Users.get_user!(x).name) end)
      |> List.flatten()

    tasks = Tasks.list_tasks()

    IO.inspect(taskreport)
    render(conn, "show.html", user: user, underlings: rosters, supervisor: supervisors, taskreport: taskreport, tasks: tasks)
  end

  def edit(conn, %{"id" => id}) do
    user = Users.get_user!(id)
    changeset = Users.change_user(user)
    render(conn, "edit.html", user: user, changeset: changeset)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Users.get_user!(id)

    case Users.update_user(user, user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User updated successfully.")
        |> redirect(to: Routes.user_path(conn, :show, user))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", user: user, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Users.get_user!(id)
    {:ok, _user} = Users.delete_user(user)

    conn
    |> put_flash(:info, "User deleted successfully.")
    |> redirect(to: Routes.user_path(conn, :index))
  end
end
