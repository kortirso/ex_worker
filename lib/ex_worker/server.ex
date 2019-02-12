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

  # receive handle message result from message server
  def handle_info({:send_message_result, _}, state) do
    {:noreply, state}
  end

  # scheduler work
  def handle_info(:work, state) do
    IO.puts "Execute scheduler"

    caller = self()
    send(@message_server_pid, {:send_message, caller, "SOMETHING"})

    schedule_work()

    {:noreply, state}
  end

  # Run schedule n 5 seconds
  defp schedule_work, do: Process.send_after(self(), :work, 5 * 1000)

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
