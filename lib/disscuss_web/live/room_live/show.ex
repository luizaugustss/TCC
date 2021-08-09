defmodule DisscussWeb.RoomLive.Show do
  @moduledoc false

  use DisscussWeb, :live_view
  alias Disscuss.Accounts
  alias Disscuss.Chat
  alias Disscuss.Chat.Message
  alias Disscuss.Chat.ChatMsg

  @impl true
  def mount(%{"id" => id}, %{"user_token"=> user_token} = _session, socket) do
      {:ok, socket
      |> allow_upload(:photo, accept: ~w(.png .jpg .jpeg))
      |> assign(:current_user, Accounts.get_user_by_session_token(user_token))
      |> assign(:messages, list_messages(id))
      |> assign(:chats, list_chat(id))
      |> assign(:time, list_datas(id))
    }
  end

   @impl true
  def handle_info({:message_sent, message}, %{assigns: %{messages: messages}} = socket)do

   {:ok,time_br} = DateTime.shift_zone(message.inserted_at,"America/Sao_Paulo")

    ano = to_string(time_br.year)
    mes=to_string(time_br.month)
    dia=to_string(time_br.day)
    hora=to_string(time_br.hour)
    minuto=to_string(time_br.minute)
    mes = change_zero(mes)
    dia = change_zero(dia)
    hora= change_zero(hora)
    minuto= change_zero(minuto)
    data= dia <>"/"<> mes <>"/"<> ano
    tempo = hora<> ":" <> minuto
    valor=Map.put(message, :data , data)
    valor=Map.put(valor, :tempo , tempo)
    messages = (messages ++ [valor])


 {:noreply, socket

 |> assign(:messages, valor)}
  end
  @impl true
  def handle_info({:message_chat, msg}, %{assigns: %{chats: chat}} = socket)do
   chat = (chat ++ [msg])
  {:noreply, socket
  |> assign(:chats, chat)}
  end

  @impl true
  def handle_event("send_message", %{"message" =>attrs}, %{assigns: %{message: message}} = socket)do

    Chat.create_message(message, attrs)
    {:noreply, socket}
  end
  @impl true
  def handle_event("send_chat", %{"message" =>attrs}, %{assigns: %{chat: chat}} = socket)do

    Chat.create_chat_msg(chat, attrs)
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
    |> assign_chatmsg()
    |> assign_changeset_message()
    # |> assign_data()
    |> assign(:page_title, room.name)

     }
  end

  defp assign_changeset_message(%{assigns: %{message: message}} = socket) do
    assign(socket, :changeset , Message.changeset(message, %{}))
  end
  defp assign_changeset_message(%{assigns: %{chat: msg}} = socket) do
    assign(socket, :changeset , ChatMsg.changeset(msg, %{}))
  end

  defp assign_chatmsg(%{assigns: %{ current_user: current_user,room: room} } = socket ) do
    assign(socket,:chat, %ChatMsg{room_id: room.id, sender_id: current_user.id, username: current_user.username})
  end
  # defp assign_data(socket ) do
  #  data =socket
  #   assign(socket,:data, })
  # end
  defp assign_message(%{assigns: %{ current_user: current_user,room: room} } = socket ) do
    assign(socket,:message, %Message{room_id: room.id, sender_id: current_user.id, username: current_user.username})
  end
  defp list_messages(id) do
    messages = Chat.list_messages(id)
    nova_lista = change_timezones([],messages ,Enum.count(messages))
    nova_lista

  end
  defp list_datas(id) do
   Chat.list_messages(id)

  end

  defp change_timezones(nova_lista,msg, n) when n > 0 do
    x =Enum.at(msg, n-1)
    {:ok,time_br}=DateTime.shift_zone(x.inserted_at,"America/Sao_Paulo")

    ano = to_string(time_br.year)
    mes=to_string(time_br.month)
    dia=to_string(time_br.day)
    hora=to_string(time_br.hour)
    minuto=to_string(time_br.minute)
    mes = change_zero(mes)
    dia = change_zero(dia)
    hora= change_zero(hora)
    minuto= change_zero(minuto)

    data= dia <>"/"<> mes <>"/"<> ano
    tempo = hora<> ":" <> minuto

    valor=Map.put(x, :data , data)
    valor=Map.put(valor, :tempo , tempo)
    nova_lista = nova_lista++[valor]
    change_timezones(nova_lista,msg, n - 1)

  end
  defp change_timezones(nova_lista,_msg, 0)do
    nova_lista
  end
  defp change_zero(valor)do
    if String.to_integer(valor) < 10 do
      valor="0"<>valor
    else
      valor

  end
  end

  defp list_chat(id) do
    Chat.list_chat_msg(id)
  end
  # defp assign_changeset(%{assigns: %{message: message}} = socket) do
  #   assign(socket, :changeset , Message.changeset(message,%{}))
  # end
end
