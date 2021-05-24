defmodule Disscuss.Repo.Migrations.CreateMessages do
  use Ecto.Migration

  def change do
    create table(:messages) do
      add :text, :string
      add :data, :map
      add :sender_id, references(:users, on_delete: :nothing)
      add :recipient_id, references(:users, on_delete: :nothing)
      add :room_id, references(:rooms, on_delete: :nothing)

      timestamps()
    end

    create index(:messages, [:sender_id])
    create index(:messages, [:recipient_id])
    create index(:messages, [:room_id])
  end
end
