defmodule Tasktracker.TimeBlocks do
  @moduledoc """
  The TimeBlocks context.
  """

  import Ecto.Query, warn: false
  alias Tasktracker.Repo

  alias Tasktracker.TimeBlocks.Time

  @doc """
  Returns the list of times.

  ## Examples

      iex> list_times()
      [%Time{}, ...]

  """
  def list_times do
    Repo.all(Time)
  end

  @doc """
  Gets a single time.

  Raises `Ecto.NoResultsError` if the Time does not exist.

  ## Examples

      iex> get_time!(123)
      %Time{}

      iex> get_time!(456)
      ** (Ecto.NoResultsError)

  """
  def get_time!(id), do: Repo.get!(Time, id)

  @doc """
  Creates a time.

  ## Examples

      iex> create_time(%{field: value})
      {:ok, %Time{}}

      iex> create_time(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_time(attrs \\ %{}) do
    %Time{}
    |> Time.changeset(attrs)
    |> Repo.insert()
  end

  def create_time(start, stop, taskid) do
    {:ok, datetime_start, 0} = DateTime.from_iso8601("#{start}#{":07Z"}")
    {:ok, datetime_stop, 0} = DateTime.from_iso8601("#{stop}#{":07Z"}")
    %Time{}
    |> Time.changeset(%{from: datetime_start, to: datetime_stop, task: taskid})
    |> Repo.insert()
  end


  @doc """
  Updates a time.

  ## Examples

      iex> update_time(time, %{field: new_value})
      {:ok, %Time{}}

      iex> update_time(time, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_time(%Time{} = time, attrs) do
    time
    |> Time.changeset(attrs)
    |> Repo.update()
  end

  def update_start_time(%Time{} = time, attrs) do
    time
    |> Time.changeset(attrs)
    |> Repo.update()
  end

  def update_stop_time(time, attrs) do
    IO.inspect(Map.get(attrs, "to"))
    {:ok, datetime_start, 0} = DateTime.from_iso8601(Map.get(attrs, "to"))
    newStop = %{from: time.from, to: datetime_start, task: time.task}
    IO.inspect(attrs)
    IO.inspect(newStop)
    time
    |> Time.changeset(newStop)
    |> Repo.update()
  end

  def get_by_task(id) do
    a = Repo.all(from t in Time,
                      where: t.task == ^id,
                      select: t.from)
    b = Repo.all(from t in Time,
                 where: t.task == ^id,
                 select: t.to)


    %{start: a, stop: b}
  end

  @doc """
  Deletes a Time.

  ## Examples

      iex> delete_time(time)
      {:ok, %Time{}}

      iex> delete_time(time)
      {:error, %Ecto.Changeset{}}

  """
  def delete_time(%Time{} = time) do
    Repo.delete(time)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking time changes.

  ## Examples

      iex> change_time(time)
      %Ecto.Changeset{source: %Time{}}

  """
  def change_time(%Time{} = time) do
    Time.changeset(time, %{})
  end
end
