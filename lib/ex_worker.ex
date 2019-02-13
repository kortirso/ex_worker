defmodule ExWorker do
  use Application

  @doc """
  Starts the ExWorker Application (and its Supervision Tree)
  """
  def start(_, _) do
    ExWorker.Supervisor.start
  end
end
