defmodule Tasktracker.Repo.Migrations.CreateTimes do
  use Ecto.Migration

  def change do
    create table(:times) do
      add :from, :utc_datetime
      add :to, :utc_datetime
      add :task, :integer

      timestamps()
    end

  end
end
