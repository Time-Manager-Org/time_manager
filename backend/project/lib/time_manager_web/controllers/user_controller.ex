defmodule TimeManagerWeb.UserController do
  use TimeManagerWeb, :controller

  alias TimeManager.Accounts
  alias TimeManager.Accounts.User

  action_fallback TimeManagerWeb.FallbackController

  # include params in the index function to allow for filtering and pagination
  def index(conn, params) do
    current_user = conn.assigns.current_user

    users =
      case current_user.role do
        :admin -> Accounts.list_users(params)
        :manager -> Accounts.list_team_users(current_user.id)
        _ -> nil
      end

    if users do
      render(conn, :index, users: users)
    else
      conn
      |> put_status(:forbidden)
      |> json(%{error: "Manager or admin access required"})
    end
  end

  def sign_up(conn, params) do
    user_params = Map.get(params, "user", params)

    case Accounts.create_user(user_params) do
      {:ok, user} ->
        conn
        |> put_status(:created)
        |> json(%{
          message: "User registered successfully",
          data: %{
            id: user.id,
            username: user.username,
            email: user.email
          }
        })

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{errors: translate_errors(changeset)})
    end
  end

  # helper function to translate changeset errors into a more readable format
  defp translate_errors(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {msg, opts} ->
      Regex.replace(~r"%{(\w+)}", msg, fn _, key ->
        opts |> Keyword.get(String.to_existing_atom(key), key) |> to_string()
      end)
    end)
  end

  # def create(conn, %{"user" => user_params}) do
  #   with {:ok, %User{} = user} <- Accounts.create_user(user_params) do
  #     conn
  #     |> put_status(:created)
  #     |> put_resp_header("location", ~p"/api/users/#{user}")
  #     |> render(:show, user: user)
  #   end
  # end

  def show(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    render(conn, :show, user: user)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    if conn.assigns.current_user.role == :admin do
      user = Accounts.get_user!(id)

      if to_string(user.id) == to_string(conn.assigns.current_user.id) and user_params["status"] == "inactive" do
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{error: "You cannot suspend your own administrator account"})
      else
        with {:ok, %User{} = user} <- Accounts.update_user_role(user, user_params) do
          render(conn, :show, user: user)
        end
      end
    else
      conn
      |> put_status(:forbidden)
      |> json(%{error: "Admin access required"})
    end
  end

  def delete(conn, %{"id" => id}) do
    if conn.assigns.current_user.role == :admin do
      user = Accounts.get_user!(id)

      if user.id == conn.assigns.current_user.id do
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{error: "You cannot delete your own administrator account"})
      else
        with {:ok, %User{}} <- Accounts.delete_user(user) do
          send_resp(conn, :no_content, "")
        end
      end
    else
      conn
      |> put_status(:forbidden)
      |> json(%{error: "Admin access required"})
    end
  end
end
