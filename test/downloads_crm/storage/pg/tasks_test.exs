defmodule DownloadsCrm.Storage.Pg.TasksTest do
  use DownloadsCrm.RepoCase, async: true

  alias DownloadsCrm.Repo
  alias DownloadsCrm.Storage.Pg.Schema.Task
  alias DownloadsCrm.Storage.Pg.Tasks

  describe ".batch_create_tasks/1" do
    test "create tasks" do
      tasks = [
        %{
          name: "task one",
          urls: ["url one", "urls two"]
        },
        %{
          name: "task two",
          urls: ["url one", "urls two", "urls three"]
        }
      ]

      assert {:ok, :ok} = Tasks.batch_create_tasks(tasks)

      assert [
               %Task{
                 name: "task one",
                 urls: ["url one", "urls two"]
               },
               %DownloadsCrm.Storage.Pg.Schema.Task{
                 name: "task two",
                 urls: ["url one", "urls two", "urls three"]
               }
             ] = Repo.all(Task)
    end

    test "returns error if any of tasks is invalid" do
      tasks = [
        %{
          name: "task one",
          urls: "url"
        },
        %{
          name: "task two",
          urls: ["url one", "urls two", "urls three"]
        }
      ]

      assert {:error, %Ecto.InvalidChangesetError{changeset: %{errors: errors}}} = Tasks.batch_create_tasks(tasks)
      assert [urls: {"is invalid", [type: {:array, :string}, validation: :cast]}] = errors
      assert [] = Repo.all(Task)
    end
  end
end
