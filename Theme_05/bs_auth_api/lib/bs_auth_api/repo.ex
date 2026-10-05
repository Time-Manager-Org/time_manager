defmodule BsAuthApi.Repo do
  use Ecto.Repo,
    otp_app: :bs_auth_api,
    adapter: Ecto.Adapters.Postgres
end
