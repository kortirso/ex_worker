defmodule ExWorker.Server do
  use GenServer

  # GenServer API

  # init server
  def init(state), do: {:ok, state}

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