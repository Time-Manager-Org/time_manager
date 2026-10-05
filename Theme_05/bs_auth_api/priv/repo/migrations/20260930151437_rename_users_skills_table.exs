defmodule BsAuthApi.Repo.Migrations.RenameUsersSkillsTable do
  use Ecto.Migration

  def change do
    rename table(:users_skills), to: table(:user_skills)

    alter table(:user_skills) do
      add :inserted_at, :naive_datetime
      add :updated_at, :naive_datetime
    end
  end
end
