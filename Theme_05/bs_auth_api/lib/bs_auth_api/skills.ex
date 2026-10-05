defmodule BsAuthApi.Skills do
  import Ecto.Query, warn: false
  alias BsAuthApi.Repo
  alias BsAuthApi.Skills.{Skill, UserSkill}

  def list_skills, do: Repo.all(Skill)

  def list_user_skills(user_id) do
    query =
      from skill in Skill,
        join: user_skill in UserSkill,
        on: user_skill.skill_id == skill.id,
        where: user_skill.user_id == ^user_id,
        select: skill

    Repo.all(query)
  end

  def get_skill(id), do: Repo.get(Skill, id)

  def create_skill(attrs) do
    %Skill{}
    |> Skill.changeset(attrs)
    |> Repo.insert()
  end

  def update_skill(%Skill{} = skill, attrs) do
    skill
    |> Skill.changeset(attrs)
    |> Repo.update()
  end

  def delete_skill(%Skill{} = skill) do
    Repo.delete(skill)
  end

  def add_skill_to_user(user_id, skill_id) do
    %UserSkill{}
    |> UserSkill.changeset(%{user_id: user_id, skill_id: skill_id})
    |> Repo.insert()
  end

  def add_skill_to_user_by_name(user_id, name) when is_binary(name) do
    name = String.trim(name)

    Repo.transaction(fn ->
      skill =
        case Repo.get_by(Skill, name: name) do
          nil ->
            case create_skill(%{name: name}) do
              {:ok, skill} -> skill
              {:error, changeset} -> Repo.rollback(changeset)
            end

          skill ->
            skill
        end

      user_skill =
        case Repo.get_by(UserSkill, user_id: user_id, skill_id: skill.id) do
          nil ->
            case add_skill_to_user(user_id, skill.id) do
              {:ok, user_skill} -> user_skill
              {:error, changeset} -> Repo.rollback(changeset)
            end

          user_skill ->
            user_skill
        end

      {skill, user_skill}
    end)
  end

  def remove_skill_from_user(user_id, skill_id) do
    query = from us in UserSkill, where: us.user_id == ^user_id and us.skill_id == ^skill_id

    case Repo.delete_all(query) do
      {count, _} when count > 0 -> {:ok, count}
      _ -> {:error, "Skill association not found"}
    end
  end
end
