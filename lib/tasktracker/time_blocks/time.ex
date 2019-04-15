defmodule Tasktracker.TimeBlocks.Time do
  use Ecto.Schema
  import Ecto.Changeset


  schema "times" do
    field :from, :utc_datetime
    field :to, :utc_datetime
    field :task, :integer

    timestamps()
  end

  @doc false
  def changeset(time, attrs) do
    time
    |> cast(attrs, [:from, :to, :task])
    |> validate_required([:from, :to])
  end
end
