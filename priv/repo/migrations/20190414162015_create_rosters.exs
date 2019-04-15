defmodule Tasktracker.Repo.Migrations.CreateRosters do
  use Ecto.Migration

  def change do
    create table(:rosters) do
      add :user, :integer
      add :supervisor, :integer

      timestamps()
    end



  end
end
