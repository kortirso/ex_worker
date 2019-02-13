defmodule ExWorker.Server do
  @moduledoc false

  use GenServer
  alias ExWorker.{MessageServer, DB.Queries}

  @default_message_servers 100

  # GenServer API

  @doc """
  Init server
  """
  def init(_) do
    IO.puts "ExWorker server is running"
    schedule_work()
    pool = 1..message_servers_count() |> Enum.map(fn(_) -> MessageServer.start end)
    messages = Queries.incompleted_messages

    {:ok, %{messages: messages, pool: pool}}
  end

  @doc """
  Take first message from state
  """
  def handle_call(:take_message, _, state) do
    {message, messages} = do_take_message(state.messages)

    {:reply, message, %{messages: messages, pool: state.pool}}
  end

  @doc """
  Return list of messages in the state
  """
  def handle_call(:list_messages, _, state), do: {:reply, state.messages, state}

  defp do_take_message([message | messages]), do: {message, messages}
  defp do_take_message([]), do: {nil, []}

  @doc """
  Add message to state
  """
  def handle_cast({:add_message, value}, state) do
    message = Queries.message_create(value)
    messages = place_value_to_end(state.messages, message)

    {:noreply, %{messages: messages, pool: state.pool}}
  end

  defp place_value_to_end(messages, message) do
    [message | Enum.reverse(messages)] |> Enum.reverse()
  end

  @doc """
  Receive sending result with error
  """
  def handle_info({:send_message_result, {:error, message}}, state) do
    IO.puts "#{message.id} did not send"
    updated_message = update_message(message, nil, :failed)

    {:noreply, %{messages: place_value_to_end(state.messages, updated_message), pool: state.pool}}
  end

  @doc """
  Receive sending result with success
  """
  def handle_info({:send_message_result, {:ok, message}}, state) do
    IO.puts "#{message.id} sent"
    update_message(message, nil, :completed)

    {:noreply, state}
  end

  @doc """
  Scheduler work
  """
  def handle_info(:work, state) do
    schedule_work()
    state = send_messages(state)

    {:noreply, state}
  end

  # define caller pid
  defp send_messages(state) do
    caller = self()

    send_message(caller, state, 0)
  end

  # take message from state
  defp send_message(caller, state, index) do
    {_, message, state} = handle_call(:take_message, nil, state)

    send_message(caller, message, state, index)
  end

  # if message is nil then stop process
  defp send_message(_, nil, state, _), do: state

  # if message is exist then check server_pid for alive
  defp send_message(caller, message, state, index) do
    server_pid = Enum.at(state.pool, index)

    if Process.alive?(server_pid) do
      # send message to alive server
      send_message_to_server(caller, message, state, index, server_pid)
    else
      # check next server for alive
      send_message(caller, message, state, index + 1)
    end
  end

  defp send_message_to_server(caller, message, state, index, server_pid) do
    updated_message = update_message(message, server_pid, :active)
    send(server_pid, {:send_message, caller, updated_message})

    # if server is not last then try to send next message
    if index + 1 == message_servers_count(), do: state, else: send_message(caller, state, index + 1)
  end

  defp update_message(message, server_pid, status) do
    %{message | status: status, pid: server_pid}
    |> Queries.message_update()
  end

  # Run schedule in 1 second
  defp schedule_work, do: Process.send_after(self(), :work, 500)

  # number of message server
  defp message_servers_count, do: Application.get_env(:ex_worker, :message_servers_amount) || @default_message_servers

  # Client API

  @doc """
  Starts the Supervision Tree
  """
  def start_link(state \\ []), do: GenServer.start_link(__MODULE__, state, name: __MODULE__)

  @doc """
  Render list messages
  """
  def list_messages, do: GenServer.call(__MODULE__, :list_messages)

  @doc """
  Add message to the state
  """
  def add_message(value), do: GenServer.cast(__MODULE__, {:add_message, value})

  @doc """
  Add array of messages to the state
  """
  def add_messages(list) when is_list(list), do: Enum.each(list, fn value -> add_message(value) end)

  @doc """
  Take first message from the state
  """
  def take_message, do: GenServer.call(__MODULE__, :take_message)
end
