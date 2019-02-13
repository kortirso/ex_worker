defmodule ExWorkerTest do
  use ExUnit.Case
  alias ExWorker.{Server, DB.Message}

  test "add/read/get messages" do
    assert :ok == Server.add_message("foo")
    assert :ok == Server.add_messages(["1", "2"])

    # and read them
    result = Server.list_messages

    assert [%Message{message: "foo"}, %Message{message: "1"}, %Message{message: "2"}] = result

    # and get first message
    result = Server.take_message
    messages = Server.list_messages

    assert %Message{message: "foo"} = result
    assert length(messages) == 2
  end
end
