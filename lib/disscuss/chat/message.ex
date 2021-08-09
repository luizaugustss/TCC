defmodule Disscuss.Chat.Message do
  use Ecto.Schema
  import Ecto.Changeset

  schema "messages" do
    field :data, :map
    field :text, :string
    field :username, :string
    field :sender_id, :id
    field :recipient_id, :id
    field :room_id, :id

    timestamps()
  end

  @doc false
  def changeset(message, attrs) do
    message
    |> cast(attrs,[:text , :username])
    |> validate_required([:text, :username])

  end
end
