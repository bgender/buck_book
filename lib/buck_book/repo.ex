defmodule BuckBook.Repo do
  use Ecto.Repo,
    otp_app: :buck_book,
    adapter: Ecto.Adapters.Postgres
end
