defmodule Disscuss.Repo.Migrations.AddChatMsg do
  use Ecto.Migration

  def change do
    create table(:chat_msgs) do
      add :text, :string
      add :data, :map
      add :username, :string
      add :sender_id, references(:users, on_delete: :nothing)
      add :recipient_id, references(:users, on_delete: :nothing)
      add :room_id, references(:rooms, on_delete: :nothing)

      timestamps()
    end

    create index(:chat_msgs, [:sender_id])
    create index(:chat_msgs, [:recipient_id])
    create index(:chat_msgs, [:room_id])
  end
end
