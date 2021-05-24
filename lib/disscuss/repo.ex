defmodule Disscuss.Repo do
  use Ecto.Repo,
    otp_app: :disscuss,
    adapter: Ecto.Adapters.Postgres
end
