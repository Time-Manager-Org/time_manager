defmodule BsAuthApi.Repo.Migrations.CreateJoinTables do
  use Ecto.Migration

  def change do
    create table(:users_skills, primary_key: false) do
      add :user_id, references(:users, on_delete: :delete_all)
      add :skill_id, references(:skills, on_delete: :delete_all)
    end

    create table(:tasks_users, primary_key: false) do
      add :task_id, references(:tasks, on_delete: :delete_all)
      add :user_id, references(:users, on_delete: :delete_all)
    end
  end
end
