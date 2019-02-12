defmodule ExWorker.MessageServer do
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

  defp handle_message(_) do
    :timer.sleep(100)

    {:ok, "Message sent"}
  end
end
