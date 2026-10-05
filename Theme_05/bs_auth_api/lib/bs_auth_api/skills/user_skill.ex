defmodule BsAuthApi.Skills.UserSkill do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  schema "user_skills" do
    field :user_id, :integer
    field :skill_id, :integer

    timestamps()
  end

  def changeset(user_skill, attrs) do
    user_skill
    |> cast(attrs, [:user_id, :skill_id])
    |> validate_required([:user_id, :skill_id])
  end
end
