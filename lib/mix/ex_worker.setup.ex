defmodule Mix.Tasks.ExWorker.Setup do
  use Mix.Task

  @shortdoc "Creates an Mnesia DB on disk for ExWorker"

  @moduledoc """
  Creates an Mnesia DB on disk for ExWorker

    ###

    config :mnesia, dir: 'mnesia/\#{Mix.env}/\#{node()}'
    # Notice the single quotes

    ###
  """

  @doc false
  def run(_) do
    ExWorker.DB.Mnesia.setup!
  end
end
