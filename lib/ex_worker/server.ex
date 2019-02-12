defmodule ExWorker.Server do
  use GenServer
  alias ExWorker.MessageServer

  # GenServer API

  # init server
  def init(messages) do
    schedule_work()
    pool = 1..100 |> Enum.map(fn(_) -> MessageServer.start end)

    {:ok, %{messages: messages, pool: pool}}
  end

  # take first message from state
  def handle_call(:take_message, _, state) do
    {message, messages} = do_take_message(state.messages)

    {:reply, message, %{messages: messages, pool: state.pool}}
  end

  # return list of messages in the state
  def handle_call(:list_messages, _, state), do: {:reply, state.messages, state}

  defp do_take_message([message | messages]), do: {message, messages}
  defp do_take_message([]), do: {nil, []}

  # add message to state
  def handle_cast({:add_message, message}, state) do
    messages = place_value_to_end(state.messages, message)

    {:noreply, %{messages: messages, pool: state.pool}}
  end

  defp place_value_to_end(messages, message) do
    [message | Enum.reverse(messages)] |> Enum.reverse()
  end

  # receive sending result with error
  def handle_info({:send_message_result, {:error, message}}, state) do
    IO.puts "#{message} did not send"

    {:noreply, %{messages: place_value_to_end(state.messages, message), pool: state.pool}}
  end

  # receive sending result with success
  def handle_info({:send_message_result, {:ok, message}}, state) do
    IO.puts "#{message} sent"
    {:noreply, state}
  end

  # scheduler work
  def handle_info(:work, state) do
    schedule_work()
    state = send_message(state)

    {:noreply, state}
  end

  defp send_message(state) do
    caller = self()
    {_, message, state} = handle_call(:take_message, nil, state)
    if not is_nil(message), do: send(Enum.at(state.pool, :rand.uniform(100)), {:send_message, caller, message})
    state
  end

  # Run schedule n 1 second
  defp schedule_work, do: Process.send_after(self(), :work, 100)

  # Client API

  def start_link(state \\ []) do
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  # render list messages
  def list_messages, do: GenServer.call(__MODULE__, :list_messages)

  # add message to the state
  def add_message(value), do: GenServer.cast(__MODULE__, {:add_message, value})

  # add array of messages to the state
  def add_messages(list) when is_list(list), do: Enum.each(list, fn value -> add_message(value) end)

  # take first message from the state
  def take_message, do: GenServer.call(__MODULE__, :take_message)
end
