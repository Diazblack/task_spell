defmodule TaskSpell.Repo do
  use Ecto.Repo,
    otp_app: :task_spell,
    adapter: Ecto.Adapters.Postgres
end
