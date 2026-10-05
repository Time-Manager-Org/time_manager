defmodule BsAuthApiWeb.TaskController do
  use BsAuthApiWeb, :controller

  alias BsAuthApi.Tasks

  def index(conn, _params) do
    tasks = Tasks.list_tasks()
    json(conn, %{data: tasks})
  end

  def show(conn, %{"id" => id}) do
    case Tasks.get_task(id) do
      nil ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "Task not found"})

      task ->
        json(conn, %{data: task})
    end
  end

  def create(conn, params) do
    task_params =
      params
      |> Map.get("task", params)
      |> Map.put("user_id", conn.assigns.current_user.id)

    case Tasks.create_task(task_params) do
      {:ok, task} ->
        conn
        |> put_status(:created)
        |> json(%{data: task})

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{errors: translate_errors(changeset)})
    end
  end

  def update(conn, %{"id" => id} = params) do
    task_params = Map.get(params, "task", params)

    with task when not is_nil(task) <- Tasks.get_task(id),
         {:ok, updated_task} <- Tasks.update_task(task, task_params) do
      json(conn, %{data: updated_task})
    else
      nil ->
        conn |> put_status(:not_found) |> json(%{error: "Task not found"})

      {:error, %Ecto.Changeset{} = changeset} ->
        conn |> put_status(:unprocessable_entity) |> json(%{errors: translate_errors(changeset)})
    end
  end

  def delete(conn, %{"id" => id}) do
    case Tasks.get_task(id) do
      nil ->
        conn |> put_status(:not_found) |> json(%{error: "Task not found"})

      task ->
        {:ok, _} = Tasks.delete_task(task)
        send_resp(conn, :no_content, "")
    end
  end

  def assign_skill(conn, %{"taskid" => task_id, "skillid" => skill_id}) do
    case Tasks.assign_skill_to_task(task_id, skill_id) do
      {:ok, task} ->
        json(conn, %{message: "Skill assigned to task", data: task})

      {:error, reason} ->
        conn |> put_status(:unprocessable_entity) |> json(%{error: reason})
    end
  end

  def assign_user(conn, %{"taskid" => task_id, "userid" => user_id}) do
    case Tasks.assign_user_to_task(task_id, user_id) do
      {:ok, task} ->
        json(conn, %{message: "User assigned to task", data: task})

      {:error, reason} ->
        conn |> put_status(:unprocessable_entity) |> json(%{error: reason})
    end
  end

  def remove_user(conn, %{"taskid" => task_id, "userid" => user_id}) do
    case Tasks.remove_user_from_task(task_id, user_id) do
      {:ok, _} ->
        send_resp(conn, :no_content, "")

      {:error, reason} ->
        conn |> put_status(:not_found) |> json(%{error: reason})
    end
  end

  def toggle_status(conn, %{"taskid" => task_id}) do
    case Tasks.toggle_task_status(task_id) do
      {:ok, updated_task} ->
        json(conn, %{message: "Task status updated", data: updated_task})

      {:error, reason} ->
        conn |> put_status(:unprocessable_entity) |> json(%{error: reason})
    end
  end

  defp translate_errors(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {msg, opts} ->
      Regex.replace(~r"%{(\w+)}", msg, fn _, key ->
        opts |> Keyword.get(String.to_existing_atom(key), key) |> to_string()
      end)
    end)
  end
end
