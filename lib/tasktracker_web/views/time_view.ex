defmodule TasktrackerWeb.TimeView do
  use TasktrackerWeb, :view
  alias TasktrackerWeb.TimeView

  def render("index.json", %{times: times}) do
    %{data: render_many(times, TimeView, "time.json")}
  end

  def render("show.json", %{time: time}) do
    %{data: render_one(time, TimeView, "time.json")}
  end

  def render("time.json", %{time: time}) do
    %{id: time.id,
      from: time.from,
      to: time.to}
  end
end
