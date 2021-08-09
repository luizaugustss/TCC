defmodule Disscuss.Chat.ChatMsg do
  use Ecto.Schema
  import Ecto.Changeset

  schema "chat_msgs" do
    field :data, :map
    field :text, :string
    field :username, :string
    field :sender_id, :id
    field :recipient_id, :id
    field :room_id, :id

    timestamps()
  end

  @doc false
  def changeset(chat, attrs) do
    chat
    |> cast(attrs, [:text , :username])
    |> validate_required([:text, :username])
  end
end
