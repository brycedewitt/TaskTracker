defmodule Tasktracker.Tasks.Task do
  use Ecto.Schema
  import Ecto.Changeset


  schema "tasks" do
    field :assignee, :string
    field :completed, :boolean, default: false
    field :desc, :string
    field :timeblock_id, :integer
    field :title, :string

    timestamps()
  end

  @doc false
  def changeset(task, attrs) do
    task
    |> cast(attrs, [:title, :desc, :assignee, :timeblock_id, :completed])
    |> validate_required([:title, :desc, :completed])

  end


end
