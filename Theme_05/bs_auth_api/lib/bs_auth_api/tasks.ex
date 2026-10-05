defmodule BsAuthApi.Tasks do
  import Ecto.Query, warn: false
  alias BsAuthApi.Repo
  alias BsAuthApi.Tasks.Task

  def list_tasks, do: Repo.all(Task)

  def get_task(id), do: Repo.get(Task, id)

  def create_task(attrs) do
    %Task{}
    |> Task.changeset(attrs)
    |> Repo.insert()
  end

  def update_task(%Task{} = task, attrs) do
    task
    |> Task.changeset(attrs)
    |> Repo.update()
  end

  def delete_task(%Task{} = task) do
    Repo.delete(task)
  end

  def assign_skill_to_task(task_id, skill_id) do
    case get_task(task_id) do
      nil -> {:error, "Task not found"}
      task -> update_task(task, %{skill_id: skill_id})
    end
  end

  def assign_user_to_task(task_id, user_id) do
    case get_task(task_id) do
      nil -> {:error, "Task not found"}
      task -> update_task(task, %{user_id: user_id})
    end
  end

  def remove_user_from_task(task_id, _user_id) do
    case get_task(task_id) do
      nil -> {:error, "Task not found"}
      task -> update_task(task, %{user_id: nil})
    end
  end

  def toggle_task_status(task_id) do
    case get_task(task_id) do
      nil ->
        {:error, "Task not found"}

      task ->
        update_task(task, %{status: !task.status})
    end
  end
end
