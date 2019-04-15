defmodule Tasktracker.Roster do
  use Ecto.Schema
  import Ecto.Changeset


  schema "rosters" do
    field :supervisor, :integer
    field :user, :integer

    timestamps()
  end

  @doc false
  def changeset(roster, attrs) do
    roster
    |> cast(attrs, [:user, :supervisor])
    |> validate_required([:user, :supervisor])
    |> no_circular_assignments()
    |> unique_constraint(:rosters_user_supervisor_index, name: :rosters_user_supervisor_index)

  end

  defp no_circular_assignments(changeset) do
    user = get_field(changeset, :user)
    supervisor = get_field(changeset, :supervisor)
    no_circular_assignments(changeset, user, supervisor)
  end

  defp no_circular_assignments(changeset, user, supervisor) do
    if user == supervisor do
      add_error(changeset, :user, "Please do not create circular arguments")
    else
      changeset
    end
    end
end
