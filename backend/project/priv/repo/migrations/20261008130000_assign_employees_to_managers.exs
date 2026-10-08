defmodule TimeManager.Repo.Migrations.AssignEmployeesToManagers do
  use Ecto.Migration

  def up do
    alter table(:users) do
      add :manager_id, references(:users, on_delete: :nilify_all)
    end

    create index(:users, [:manager_id])

    execute """
    UPDATE users AS employee
    SET manager_id = assignments.manager_id
    FROM (
      SELECT employees.id AS employee_id, managers.id AS manager_id
      FROM (
        SELECT id, ROW_NUMBER() OVER (ORDER BY id) - 1 AS row_number
        FROM users
        WHERE role = 'employee'
      ) AS employees
      JOIN (
        SELECT id,
               ROW_NUMBER() OVER (ORDER BY id) - 1 AS row_number,
               COUNT(*) OVER () AS manager_count
        FROM users
        WHERE role = 'manager'
      ) AS managers
        ON MOD(employees.row_number, managers.manager_count) = managers.row_number
    ) AS assignments
    WHERE employee.id = assignments.employee_id
    """
  end

  def down do
    drop index(:users, [:manager_id])

    alter table(:users) do
      remove :manager_id
    end
  end
end
