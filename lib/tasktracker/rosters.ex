defmodule Tasktracker.Rosters do
  @moduledoc """
  The Tasktracker context.
  """

  import Ecto.Query, warn: false
  alias Tasktracker.Repo
  alias Tasktracker.Users

  alias Tasktracker.Roster

  @doc """
  Returns the list of rosters.

  ## Examples

      iex> list_rosters()
      [%Roster{}, ...]

  """
  def list_rosters do
    Repo.all(Roster)
  end

  def list_rosters_by_name do
    Repo.all(Roster)
  end

  def get_underlings(id) do
    Repo.all(from u in Roster,
               where: u.supervisor == ^id,
               select: u.user)
  end

  def get_supervisors(id) do
    Repo.all(from u in Roster,
             where: u.user == ^id,
             select: u.supervisor)
  end

  @doc """
  Gets a single roster.

  Raises `Ecto.NoResultsError` if the Roster does not exist.

  ## Examples

      iex> get_roster!(123)
      %Roster{}

      iex> get_roster!(456)
      ** (Ecto.NoResultsError)

  """
  def get_roster!(id), do: Repo.get!(Roster, id)

  @doc """
  Creates a roster.

  ## Examples

      iex> create_roster(%{field: value})
      {:ok, %Roster{}}

      iex> create_roster(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_roster(attrs \\ %{}) do
    %Roster{}
    |> Roster.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a roster.

  ## Examples

      iex> update_roster(roster, %{field: new_value})
      {:ok, %Roster{}}

      iex> update_roster(roster, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_roster(%Roster{} = roster, attrs) do
    roster
    |> Roster.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Roster.

  ## Examples

      iex> delete_roster(roster)
      {:ok, %Roster{}}

      iex> delete_roster(roster)
      {:error, %Ecto.Changeset{}}

  """
  def delete_roster(%Roster{} = roster) do
    Repo.delete(roster)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking roster changes.

  ## Examples

      iex> change_roster(roster)
      %Ecto.Changeset{source: %Roster{}}

  """
  def change_roster(%Roster{} = roster) do
    Roster.changeset(roster, %{})
  end
end
