defmodule TasktrackerWeb.TimeController do
  use TasktrackerWeb, :controller

  alias Tasktracker.TimeBlocks
  alias Tasktracker.TimeBlocks.Time

  action_fallback TasktrackerWeb.FallbackController

  def index(conn, _params) do
    times = TimeBlocks.list_times()
    render(conn, "index.json", times: times)
  end

  def create(conn, %{"time" => time_params}) do
    with {:ok, %Time{} = time} <- TimeBlocks.create_time(time_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.time_path(conn, :show, time))
      |> render("show.json", time: time)
    end
  end

  def show(conn, %{"id" => id}) do
    time = TimeBlocks.get_time!(id)
    render(conn, "show.json", time: time)
  end

  def update(conn, %{"start" => _start, "id" => id, "time" => time_params}) do
    time = TimeBlocks.get_time!(id)
    with {:ok, %Time{} = time} <- TimeBlocks.update_start_time(time, time_params) do
      render(conn, "show.json", time: time)
    end

  end

  def update(conn, %{"stop" => _stop, "id" => id, "time" => time_params}) do
    time = TimeBlocks.get_time!(id)
    with {:ok, %Time{} = time} <- TimeBlocks.update_stop_time(time, time_params) do
      render(conn, "show.json", time: time)
    end
  end

  def delete(conn, %{"id" => id}) do
    time = TimeBlocks.get_time!(id)

    with {:ok, %Time{}} <- TimeBlocks.delete_time(time) do
      send_resp(conn, :no_content, "")
    end
  end
end
