defmodule Tasktracker.Tasks.Task do
  use Ecto.Schema
  import Ecto.Changeset


  schema "tasks" do
    field :assignee, :string
    field :completed, :boolean, default: false
    field :desc, :string
    field :time, :integer
    field :title, :string

    timestamps()
  end

  @doc false
  def changeset(task, attrs) do
    task
    |> cast(attrs, [:title, :desc, :assignee, :time, :completed])
    |> validate_required([:title, :desc, :completed])
    |> validate_time_interval(:time)

  end

  def validate_time_interval(changeset, field, options \\ []) do
    validate_change(changeset, field, fn _, time ->
      case rem(time, 15) == 0 do
        true -> []
        false -> [{field, options[:message] || "Please enter time in 15min increment"}]
      end
    end)
  end

end
