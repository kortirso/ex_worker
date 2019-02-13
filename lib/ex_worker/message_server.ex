defmodule ExWorker.MessageServer do
  @moduledoc false

  @doc """
  Start Message server
  """
  def start do
    spawn(&loop/0)
  end

  defp loop do
    receive do
      {:send_message, caller, message} ->
        send(caller, {:send_message_result, handle_message(message)})
    end
    loop()
  end

  # make virtual message sending
  defp handle_message(message), do: 5 |> :rand.uniform() |> do_handle_message(message)

  defp do_handle_message(1, message), do: {:error, message}
  defp do_handle_message(_, message), do: {:ok, message}
end
