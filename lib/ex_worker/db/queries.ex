defmodule ExWorker.DB.Queries do
  @moduledoc false

  alias ExWorker.DB.Message
  alias Memento.Query

  # read all messages
  def read_all do
    Memento.transaction! fn ->
      Query.all(Message)
    end
  end

  # create new message
  def message_create(message_value) when is_binary(message_value) do
    Memento.transaction! fn ->
      Query.write(%Message{message: message_value, status: :created})
    end
  end

  # update message
  def message_update(message) when is_map(message) do
    Memento.transaction! fn ->
      Query.write(message)
    end
  end

  # get list of incompleted messages
  def incompleted_messages do
    run_select_query(
      {:or,
        {:==, :status, :created},
        {:==, :status, :active},
        {:==, :status, :failed}
      }
    )
  end

  # get list of completed messages
  def completed_messages do
    run_select_query(
      {:==, :status, :completed}
    )
  end

  # get list of active messages
  def active_messages do
    run_select_query(
      {:==, :status, :active}
    )
  end

  defp run_select_query(pattern) do
    Memento.transaction! fn ->
      Query.select(Message, pattern)
    end
  end
end
