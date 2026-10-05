defmodule BsAuthApiWeb.SkillController do
  use BsAuthApiWeb, :controller

  alias BsAuthApi.Skills

  def index(conn, _params) do
    skills = Skills.list_skills()
    json(conn, %{data: skills})
  end

  # GET /api/users/:id/skills
  def user_skills(conn, %{"id" => user_id}) do
    skills = Skills.list_user_skills(user_id)
    json(conn, %{data: skills})
  end

  def show(conn, %{"id" => id}) do
    case Skills.get_skill(id) do
      nil ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "Skill not found"})

      skill ->
        json(conn, %{data: skill})
    end
  end

  def create(conn, params) do
    skill_params = Map.get(params, "skill", params)

    case Skills.create_skill(skill_params) do
      {:ok, skill} ->
        conn
        |> put_status(:created)
        |> json(%{data: skill})

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{errors: translate_errors(changeset)})
    end
  end

  def update(conn, %{"id" => id} = params) do
    skill_params = Map.get(params, "skill", params)

    with skill when not is_nil(skill) <- Skills.get_skill(id),
         {:ok, updated_skill} <- Skills.update_skill(skill, skill_params) do
      json(conn, %{data: updated_skill})
    else
      nil ->
        conn |> put_status(:not_found) |> json(%{error: "Skill not found"})

      {:error, %Ecto.Changeset{} = changeset} ->
        conn |> put_status(:unprocessable_entity) |> json(%{errors: translate_errors(changeset)})
    end
  end

  def delete(conn, %{"id" => id}) do
    case Skills.get_skill(id) do
      nil ->
        conn |> put_status(:not_found) |> json(%{error: "Skill not found"})

      skill ->
        {:ok, _} = Skills.delete_skill(skill)
        send_resp(conn, :no_content, "")
    end
  end

  def add_user_skill(conn, %{"userid" => user_id, "skillid" => skill_id}) do
    case Skills.add_skill_to_user(user_id, skill_id) do
      {:ok, _user_skill} ->
        conn
        |> put_status(:created)
        |> json(%{message: "Skill assigned to user successfully"})

      {:error, reason} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{error: reason})
    end
  end

  def add_user_skill_by_name(conn, %{"userid" => user_id, "name" => name}) do
    case Skills.add_skill_to_user_by_name(user_id, name) do
      {:ok, {skill, _user_skill}} ->
        conn
        |> put_status(:created)
        |> json(%{data: skill})

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{errors: translate_errors(changeset)})
    end
  end

  def remove_user_skill(conn, %{"userid" => user_id, "skillid" => skill_id}) do
    case Skills.remove_skill_from_user(user_id, skill_id) do
      {:ok, _} ->
        send_resp(conn, :no_content, "")

      {:error, reason} ->
        conn
        |> put_status(:not_found)
        |> json(%{error: reason})
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
