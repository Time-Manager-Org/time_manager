defmodule BsAuthApiWeb.UserController do
  use BsAuthApiWeb, :controller

  alias BsAuthApi.Accounts

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
            email: user.email,
            first_name: user.first_name,
            last_name: user.last_name
          }
        })

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{errors: translate_errors(changeset)})
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
