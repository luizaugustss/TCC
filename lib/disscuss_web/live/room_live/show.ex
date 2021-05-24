defmodule DisscussWeb.RoomLive.Show do
  @moduledoc false
  use DisscussWeb, :live_view
  alias Disscuss.Accounts
  alias Disscuss.Chat
  alias Disscuss.Chat.Message

  @impl true
  def mount(_params, %{"user_token"=> user_token}=_session, socket) do


      {:ok, socket
      |> assign(:current_user,Accounts.get_user_by_session_token(user_token))}

  end
  @impl true
  def handle_params(:send_message,params,socket)do
    IO.inspect(params)
    {:noreply, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    room = Chat.get_room!(id)
    {:noreply,
     socket
    |> assign(:room, room)
    |> assign_message()
     |> assign_changeset()
     |> assign(:messages, [])
     |> assign(:page_title, room.name)

     }
  end


  defp assign_changeset(%{assigns: %{message: message}} = socket) do
    assign(socket, :changeset , Message.changeset(message, %{}))
  end
  defp assign_message(%{assigns: %{ current_user: current_user,room: room} } = socket ) do
    assign(socket,:message, %Message{room_id: room.id,sender_id: current_user.id})
  end

  # defp assign_changeset(%{assigns: %{message: message}} = socket) do
  #   assign(socket, :changeset , Message.changeset(message,%{}))
  # end
end
