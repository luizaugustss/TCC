defmodule DisscussWeb.RoomLive.Show do

  use DisscussWeb, :live_view
  alias Disscuss.Accounts
  alias Disscuss.Chat
  alias Disscuss.Chat.Message

  @impl true
  def mount( %{"id" => id}, %{"user_token"=> user_token} = _session, socket) do
      {:ok, socket
      |> assign(:current_user, Accounts.get_user_by_session_token(user_token))
      |> assign(:messages, list_messages(id))
    }
  end

   @impl true
  def handle_info({:message_sent, message}, %{assigns: %{messages: messages}} =socket)do

  messages = (messages ++ [message])
  {:noreply,assign(socket, :messages, messages)}
  end

  @impl true
  def handle_event("send_message", %{"message" =>attrs}, %{assigns: %{message: message}} = socket)do
    Chat.create_message(message, attrs)
    {:noreply, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    room = Chat.get_room!(id)
    Chat.subscribe_message(room.id)

    {:noreply,
     socket
    |> assign(:room, room)
    |> assign_message()
    |> assign_changeset()
    |> assign(:page_title, room.name)

     }
  end

  defp assign_changeset(%{assigns: %{message: message}} = socket) do
    assign(socket, :changeset , Message.changeset(message, %{}))
  end

  defp assign_message(%{assigns: %{ current_user: current_user,room: room} } = socket ) do
    assign(socket,:message, %Message{room_id: room.id, sender_id: current_user.id, username: current_user.username})
  end
  defp list_messages(id) do
    Chat.list_messages(id)
  end
  # defp assign_changeset(%{assigns: %{message: message}} = socket) do
  #   assign(socket, :changeset , Message.changeset(message,%{}))
  # end
end
