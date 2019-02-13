defmodule ExWorker.DB.Queries do
  @moduledoc false

  alias ExWorker.DB.Message
  alias Memento.Query

  @doc """
  Read all messages
  """
  def read_all do
    Memento.transaction! fn ->
      Query.all(Message)
    end
  end

  @doc """
  Create new message
  """
  def message_create(message_value) when is_binary(message_value) do
    Memento.transaction! fn ->
      Query.write(%Message{message: message_value, status: :created})
    end
  end

  @doc """
  Update message
  """
  def message_update(message) when is_map(message) do
    Memento.transaction! fn ->
      Query.write(message)
    end
  end

  @doc """
  Get list of incompleted messages
  """
  def incompleted_messages do
    run_select_query(
      {:or,
        {:==, :status, :created},
        {:==, :status, :active},
        {:==, :status, :failed}
      }
    )
  end

  defp run_select_query(pattern) do
    Memento.transaction! fn ->
      Query.select(Message, pattern)
    end
  end
end
