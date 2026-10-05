defmodule BsAuthApi.Tasks.Task do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, only: [:id, :title, :description, :status, :skill_id, :user_id, :inserted_at, :updated_at]}
  schema "tasks" do
    field :title, :string
    field :description, :string
    field :status, :boolean, default: false
    field :skill_id, :integer
    field :user_id, :integer

    timestamps(type: :utc_datetime)
  end

  def changeset(task, attrs) do
    task
    |> cast(attrs, [:title, :description, :status, :skill_id, :user_id])
    |> validate_required([:title])
  end
end
