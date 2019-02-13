defmodule ExWorker.DB do
  @moduledoc false

  # Memento Table Definition
  defmodule Message do
    use Memento.Table,
      attributes: [:id, :message, :status, :pid],
      index: [:status],
      type: :ordered_set,
      autoincrement: true
  end
end