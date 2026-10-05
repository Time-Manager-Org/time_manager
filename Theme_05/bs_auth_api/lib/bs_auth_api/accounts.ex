defmodule BsAuthApi.Accounts do
  import Ecto.Query, warn: false
  alias BsAuthApi.Repo
  alias BsAuthApi.Accounts.User

  @token_max_age_seconds 60 * 60 # 1 hour

  def create_user(attrs) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  def get_user(id), do: Repo.get(User, id)

  def authenticate_user(email, password) do
    user = Repo.get_by(User, email: email)

    cond do
      user && Bcrypt.verify_pass(password, user.password_hash) ->
        # Salt used here: "user_auth"
        token = Phoenix.Token.sign(BsAuthApiWeb.Endpoint, "user_auth", user.id)
        {:ok, user, token}

      user ->
        {:error, :unauthorized}

      true ->
        Bcrypt.no_user_verify()
        {:error, :unauthorized}
    end
  end

  def verify_token(token) do
    case Phoenix.Token.verify(BsAuthApiWeb.Endpoint, "user_auth", token,
           max_age: @token_max_age_seconds
         ) do
      {:ok, user_id} ->
        case get_user(user_id) do
          nil -> {:error, :user_not_found}
          user -> {:ok, user}
        end

      {:error, reason} ->
        {:error, reason}
    end
  end
end
