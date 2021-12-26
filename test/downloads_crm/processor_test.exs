defmodule DownloadsCrm.ProcessorTest do
  use DownloadsCrm.RepoCase, async: true

  alias DownloadsCrm.Processor
  alias DownloadsCrm.Storage.Pg.Schema.Task

  test ".process/1" do
  end

  test ".process_task/1" do
    urls = [
      "http://placekitten.com/g/160/120",
      "http://placekitten.com/g/120/135",
      "http://placekitten.com/g/180/100"
    ]

    task = insert(:task, status: "initialized", urls: urls)
    pid = self()

    Processor.process_task(pid, task)

    # assert {:ok, %Task{status: "processing", progress: 0}} = Processor.process_task(pid, task)
    assert_receive {:ok, %Task{status: "processing", progress: 0}}
  end

  test ".create_zip/1" do

  end
end
