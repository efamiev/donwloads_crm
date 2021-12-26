defmodule DownloadsCrm.Processor do
  alias DownloadsCrm.Storage.Pg.Schema.Task, as: ProjectTask
  alias DownloadsCrm.Storage.Pg.Tasks

  def process(tasks) do
    pid = self()

    Enum.each(tasks, fn task -> Task.start(fn -> process_task(pid, task) end) end)
  end

  def process_task(pid, %ProjectTask{urls: [url | _]} = task) do
    # скачиваем файлы задачи
    :inets.start()
    download_file(task.id, url)
    {:ok, {{'HTTP/1.1', 200, 'OK'}, _headers, body}} = :httpc.request(:get, {url, []}, [], [])
    IO.inspect body
    # меняем статус задачи на processing
    res = Tasks.update_task(task.id, %{status: "processing", progress: 0})
    send(pid, res)
    # Repo.get!(ProjectTask, task.id)
    # |> ProjectTask.changeset(%{status: "processing", progress: 0})
    # |> Repo.update()
    # начинаем формирование архива
    # как-то отслеживаем и меняем текущий прогресс формирования в процентах (поле progress)

    # !!! все изменения задачи как-то отправляем по вебсокет
  end

  def download_file(task_id, url) do
    {:ok, {{'HTTP/1.1', 200, 'OK'}, _headers, body}} = :httpc.request(:get, {url, []}, [], [])

    path = File.cwd!() <> "/tmp" <> "/task_#{task_id}"
    :ok = File.mkdir_p!(path)
  end

  def create_zip(path) do

  end
end
