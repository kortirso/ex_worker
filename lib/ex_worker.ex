defmodule ExWorker do
  import Supervisor.Spec

  # Starts the Supervision Tree
  def start(params \\ []) do
    children = [
      worker(ExWorker.Server, params, name: ExWorker.Server)
    ]

    Supervisor.start_link(children, strategy: :one_for_one)
  end
end
