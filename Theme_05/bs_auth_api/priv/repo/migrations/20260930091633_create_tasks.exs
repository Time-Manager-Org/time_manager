defmodule BsAuthApi.Repo.Migrations.CreateTasks do
  use Ecto.Migration

  def change do
    create table(:tasks) do
      add :title, :string
      add :description, :string
      add :status, :boolean, default: false, null: false
      add :skill_id, references(:skills, on_delete: :nothing)
      add :user_id, :integer

      timestamps(type: :utc_datetime)
    end

    create index(:tasks, [:skill_id])
  end
end
