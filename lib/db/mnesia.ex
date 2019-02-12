defmodule ExWorker.DB.Mnesia do
  alias ExWorker.DB.Message

  def setup!(nodes \\ [node()]) do
    # Create the DB directory (if custom path given)
    if path = Application.get_env(:mnesia, :dir) do
      :ok = File.mkdir_p!(path)
    end

    # Create the Schema
    Memento.stop
    Memento.Schema.create(nodes)
    Memento.start

    # Create the DB with Disk Copies
    # TODO:
    # Use Memento.Table.wait when it gets implemented
    # @db.create!(disk: nodes)
    # @db.wait(15000)
    Memento.Table.create!(Message, disc_copies: nodes)
  end  
end
