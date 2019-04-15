defmodule TasktrackerWeb.TaskController do
  use TasktrackerWeb, :controller
  import Ecto.Query


  alias Tasktracker.Tasks
  alias Tasktracker.Tasks.Task
  alias Tasktracker.Users
  alias Tasktracker.Rosters
  alias Tasktracker.TimeBlocks
  alias Tasktracker.Time


  def index(conn, _params) do
    tasks = Tasks.list_tasks()
    timeblock = "placeholder"
    render(conn, "index.html", tasks: tasks, timeblock: timeblock)
  end

  def new(conn, _params) do
    changeset = Tasks.change_task(%Task{})
    users = Enum.map(Rosters.get_underlings(conn.assigns.current_user.id), fn x -> Users.get_user!(x).name end)
    render(conn, "new.html", changeset: changeset, users: users)
  end

  def create(conn, %{"task" => task_params}) do
    starttime = Map.get(task_params, "starttime")
    endtime = Map.get(task_params, "endtime")

    case Tasks.create_task(task_params) do
      {:ok, task} ->
        taskid = task.id
        IO.inspect("TaskID")
        IO.inspect(taskid)
        IO.inspect(TimeBlocks.create_time(starttime, endtime, taskid))
        conn
        |> put_flash(:info, "Task created successfully.")
        |> redirect(to: Routes.task_path(conn, :show, task))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    task = Tasks.get_task!(id)
    timeblock = TimeBlocks.get_by_task(id)
    IO.inspect(timeblock)
    assignee = Users.list_user_name(id)
    render(conn, "show.html", task: task, assignee: assignee, timeblock: timeblock)
  end

  def edit(conn, %{"id" => id}) do
    task = Tasks.get_task!(id)
    users = Users.list_users_names
    changeset = Tasks.change_task(task)
    render(conn, "edit.html", task: task, changeset: changeset, users: users)
  end

  def update(conn, %{"id" => id, "task" => task_params}) do
    task = Tasks.get_task!(id)
    users = Users.list_users_names

    case Tasks.update_task(task, task_params) do
      {:ok, task} ->
        conn
        |> put_flash(:info, "Task updated successfully.")
        |> redirect(to: Routes.task_path(conn, :show, task))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", task: task, changeset: changeset, users: users)
    end
  end

  def update_status(conn, %{"id" => id}, :complete) do
    task = Tasks.get_task!(id)
    users = Users.list_users_names
    case Tasks.update_task(task, :complete) do
      {:ok, task} ->
        conn
        |> put_flash(:info, "Task updated successfully.")
        |> redirect(to: Routes.task_path(conn, :show, task))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", task: task, changeset: changeset, users: users)
    end
  end

  def delete(conn, %{"id" => id}) do
    task = Tasks.get_task!(id)
    {:ok, _task} = Tasks.delete_task(task)

    conn
    |> put_flash(:info, "Task deleted successfully.")
    |> redirect(to: Routes.task_path(conn, :index))
  end
end
