defmodule TimeManager.Repo.Migrations.AddBreakTracking do
  use Ecto.Migration

  def change do
    alter table(:clocks) do
      add_if_not_exists :state, :string
    end

    alter table(:workingtime) do
      add_if_not_exists :kind, :string, null: false, default: "work"
    end
  end
end
