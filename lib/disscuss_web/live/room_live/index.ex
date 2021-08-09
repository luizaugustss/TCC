defmodule DisscussWeb.RoomLive.Index do
  use DisscussWeb, :live_view

  alias Disscuss.Chat
  alias Disscuss.Chat.Room
  alias Disscuss.Accounts

  @impl true
  def mount(_params,  %{"user_token"=> user_token} = _session, socket) do
    {:ok, socket
    |> assign(:current_user, Accounts.get_user_by_session_token(user_token))
    |> assign(:rooms, list_rooms())}


  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "editar sala")
    |> assign(:room, Chat.get_room!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "nova sala")
    |> assign(:room, %Room{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "lista de salas")
    |> assign(:room, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    room = Chat.get_room!(id)
    {:ok, _} = Chat.delete_room(room)

    {:noreply, assign(socket, :rooms, list_rooms())}
  end

  defp list_rooms do
    Chat.list_rooms()
  end
end
