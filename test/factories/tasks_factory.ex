defmodule DownloadsCrm.TasksFactory do
  defmacro __using__(_opts) do
    quote do
      alias DownloadsCrm.Storage.Pg.Schema.Task

      def task_factory(attrs) do
        task = %Task{
          name: sequence("taskname"),
          status: Enum.random(Task.valid_statuses()),
          price: 1000,
          urls: [],
          estimate_date: DateTime.utc_now(),
          project: build(:project)
        }

        merge_attributes(task, attrs)
      end
    end
  end
end
