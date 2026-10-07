defmodule TimeManager.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias TimeManager.Repo

  alias TimeManager.Accounts.User

  @token_max_age_seconds 60 * 60 # 1 hour

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users(params) do
    query =
      case params["email"] do
        nil -> User
        email -> where(User, [u], u.email == ^email)
      end

    query =
      case params["username"] do
        nil -> query
        username -> where(query, [u], u.username == ^username)
      end

    Repo.all(query)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)

  # This function is used to get a user by ID without raising an error if the user does not exist.

  def get_user(id), do: Repo.get(User, id)

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a user.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{data: %User{}}

  """
  def change_user(%User{} = user, attrs \\ %{}) do
    User.changeset(user, attrs)
  end


  ## Authentication functions

  def authenticate_user(username, password) do
    user = Repo.get_by(User, username: username)

    cond do
      user && Bcrypt.verify_pass(password, user.password_hash) ->
        # Salt used here: "user_auth"
        token = Phoenix.Token.sign(TimeManagerWeb.Endpoint, "user_auth", user.id)
        {:ok, user, token}

      user ->
        {:error, :unauthorized}

      true ->
        Bcrypt.no_user_verify()
        {:error, :unauthorized}
    end
  end

  def verify_token(token) do
    IO.inspect(token, label: "INCOMING TOKEN")

    case Phoenix.Token.verify(TimeManagerWeb.Endpoint, "user_auth", token,
           max_age: @token_max_age_seconds
         ) do
      {:ok, user_id} ->
        case get_user(user_id) do
          nil -> {:error, :user_not_found}
          user -> {:ok, user}
        end

      {:error, reason} ->
        IO.inspect(reason, label: "PHOENIX TOKEN VERIFY ERROR")
        {:error, reason}
    end
  end
end
