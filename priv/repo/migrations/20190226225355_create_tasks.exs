defmodule Tasktracker.Repo.Migrations.CreateTasks do
  use Ecto.Migration

  def change do
    create table(:tasks) do
      add :title, :string
      add :desc, :string
      add :assignee, :string
      add :timeblock_id, :integer
      add :completed, :boolean, default: false, null: false

      timestamps()
    end

  end
end
