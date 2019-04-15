defmodule Tasktracker.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :name, :string, null: false
      add :email, :string, unique: true, null: false
      add :manager, :boolean, null: true


      timestamps()
    end

    create unique_index(:users, [:email])

  end
end
