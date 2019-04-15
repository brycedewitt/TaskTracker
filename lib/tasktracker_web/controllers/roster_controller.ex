defmodule TasktrackerWeb.RosterController do
  use TasktrackerWeb, :controller

  alias Tasktracker.Rosters
  alias Tasktracker.Roster
  alias Tasktracker.Users
  alias Tasktracker.Users.User


  def index(conn, _params) do
    rosters =
      Rosters.list_rosters()
      |> Enum.map(fn x -> %{user: Users.get_user!(x.user), supervisor: Users.get_user!(x.supervisor)} end)

    IO.inspect(rosters)
    render(conn, "index.html", rosters: rosters)
  end

  def new(conn, _params) do
    changeset = Rosters.change_roster(%Roster{})
    roster =
      Users.list_users()
      |> Enum.map(&{"#{&1.name}", &1.id})

    render(conn, "new.html", changeset: changeset, roster: roster)
  end

  def create(conn, %{"roster" => roster_params}) do
    IO.inspect(roster_params)
    case Rosters.create_roster(roster_params) do
      {:ok, roster} ->
        conn
        |> put_flash(:info, "Roster created successfully.")
        |> redirect(to: Routes.roster_path(conn, :show, roster))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    user = Users.get_user!(Rosters.get_roster!(id).id).name
    supervisor = Users.get_user!(Rosters.get_roster!(id).supervisor).name
    IO.inspect(user)
    IO.inspect(supervisor)
    roster = struct(%Roster{}, user: user, supervisor: supervisor, id: 0)
    render(conn, "show.html", roster: roster)
  end

  def edit(conn, %{"id" => id}) do
    roster = Rosters.get_roster!(id)
    changeset = Rosters.change_roster(roster)
    render(conn, "edit.html", roster: roster, changeset: changeset)
  end

  def update(conn, %{"id" => id, "roster" => roster_params}) do
    roster = Rosters.get_roster!(id)

    case Rosters.update_roster(roster, roster_params) do
      {:ok, roster} ->
        conn
        |> put_flash(:info, "Roster updated successfully.")
        |> redirect(to: Routes.roster_path(conn, :show, roster))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", roster: roster, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    roster = Rosters.get_roster!(id)
    {:ok, _roster} = Rosters.delete_roster(roster)

    conn
    |> put_flash(:info, "Roster deleted successfully.")
    |> redirect(to: Routes.roster_path(conn, :index))
  end
end
