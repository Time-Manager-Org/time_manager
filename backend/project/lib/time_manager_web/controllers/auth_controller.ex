defmodule TimeManagerWeb.AuthController do
  use TimeManagerWeb, :controller

  alias TimeManager.Accounts

  def sign_in(conn, %{"username" => username, "password" => password}) do
    case Accounts.authenticate_user(username, password) do
      {:ok, user, token} ->
        conn
        |> put_status(:ok)
        |> json(%{
          message: "Signed in successfully",
          token: token,
          user: %{
            id: user.id,
            username: user.username,
            full_name: user.full_name,
            role: user.role

            # email: user.email,
            # first_name: user.first_name,
            # last_name: user.last_name
          }
        })

      {:error, :unauthorized} ->
        conn
        |> put_status(:unauthorized)
        |> json(%{error: "Invalid username or password"})
    end
  end

  def sign_in(conn, _params) do
    conn
    |> put_status(:bad_request)
    |> json(%{error: "Missing required fields: username, password"})
  end

  def sign_out(conn, _params) do
    # Perform token revoking / session cleanup if needed
    conn
    |> put_status(:ok)
    |> json(%{message: "Signed out successfully"})
  end

  # def profile(conn, _params) do
  #   user = conn.assigns.current_user
  #   json(conn, %{
  #     data: %{
  #       id: user.id,
  #       email: user.email,
  #       firstName: user.first_name,
  #       lastName: user.last_name
  #     }
  #   })
  # end
end
