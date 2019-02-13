defmodule ExWorker do
  @moduledoc false

  use Application

  @doc """
  Starts the ExWorker Application (and its Supervision Tree)
  """
  def start(_type, _args) do
    ExWorker.Supervisor.start
  end
end
