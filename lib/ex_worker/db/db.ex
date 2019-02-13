defmodule ExWorker.DB do
  @moduledoc false

  # Memento table definition
  defmodule Message do
    use Memento.Table,
      attributes: [:id, :message, :status, :pid],
      index: [:status],
      type: :ordered_set,
      autoincrement: true
  end
end