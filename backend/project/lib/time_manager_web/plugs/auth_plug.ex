defmodule TimeManagerWeb.Plugs.AuthPlug do
  import Plug.Conn

  def init(opts), do: opts

  # Pass CORS preflight checks through directly
  def call(%Plug.Conn{method: "OPTIONS"} = conn, _opts), do: conn

  def call(conn, _opts) do
    case get_req_header(conn, "x-xsrf-token") do
      [token] ->
        case TimeManager.Accounts.verify_token(token) do
          {:ok, user} ->
            assign(conn, :current_user, user)

          {:error, _reason} ->
            unauthorized(conn)
        end

      _ ->
        unauthorized(conn)
    end
  end

  defp unauthorized(conn) do
    conn
    |> put_status(:unauthorized)
    |> Phoenix.Controller.json(%{error: "Unauthorized"})
    |> halt()
  end
end
