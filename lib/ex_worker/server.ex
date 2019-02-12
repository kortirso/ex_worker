defmodule ExWorker.Server do
  use GenServer

  @message_server_pid ExWorker.MessageServer.start

  # GenServer API

  # init server
  def init(state) do
    schedule_work()

    {:ok, state}
  end

  # take first message from state
  def handle_call(:take_message, _, [value | state]), do: {:reply, value, state}
  def handle_call(:take_message, _, []), do: {:reply, nil, []}

  # return list of messages in the state
  def handle_call(:list_messages, _, state), do: {:reply, state, state}

  # add message to state
  def handle_cast({:add_message, value}, state), do: {:noreply, place_value_to_end(state, value)}

  defp place_value_to_end(state, value) do
    [value | Enum.reverse(state)] |> Enum.reverse()
  end

  # receive sending result with error
  def handle_info({:send_message_result, {:error, message}}, state) do
    IO.puts "#{message} did not send"
    {:noreply, place_value_to_end(state, message)}
  end

  # receive sending result with success
  def handle_info({:send_message_result, {:ok, message}}, state) do
    IO.puts "#{message} sent"
    {:noreply, state}
  end

  # scheduler work
  def handle_info(:work, state) do
    caller = self()
    send_message(self(), state)
    schedule_work()

    {:noreply, state}
  end

  defp send_message(caller, state) do
    {_, message, state} = handle_call(:take_message, nil, state)
    if not is_nil(message), do: send(@message_server_pid, {:send_message, caller, message})
    state
  end

  # Run schedule n 1 second
  defp schedule_work, do: Process.send_after(self(), :work, 1000)

  # Client API

  def start_link(state \\ []) do
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  # render list messages
  def list_messages, do: GenServer.call(__MODULE__, :list_messages)

  # add message to the state
  def add_message(value), do: GenServer.cast(__MODULE__, {:add_message, value})

  # take first message from the state
  def take_message, do: GenServer.call(__MODULE__, :take_message)
end
