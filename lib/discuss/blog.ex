defmodule Discuss.Blog do
  @moduledoc """
  The Blog context.
  """

  import Ecto.Query, warn: false
  alias Discuss.Repo

  alias Discuss.Blog.Topic
  alias Discuss.Blog.Comment

  @doc """
  Returns the list of topics.

  ## Examples

      iex> list_topics()
      [%Topic{}, ...]

  """
  def list_topics do
    Repo.all(Topic)
  end

  @doc """
  Gets a single topic.

  Raises `Ecto.NoResultsError` if the Topic does not exist.

  ## Examples

      iex> get_topic!(123)
      %Topic{}

      iex> get_topic!(456)
      ** (Ecto.NoResultsError)

  """
  def get_topic!(id), do: Repo.get!(Topic, id)

  @doc """
  Gets a single topic.

  ## Examples

      iex> get_topic(123)
      %Topic{}

  """
  def get_topic(id), do: Repo.get(Topic, id)

  @doc """
  Creates a topic.

  ## Examples

      iex> create_topic(user, %{field: value})
      {:ok, %Topic{}}

      iex> create_topic(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_topic(user, attrs \\ %{}) do
    user
    |> Ecto.build_assoc(:topics)
    |> Topic.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a topic.

  ## Examples

      iex> update_topic(topic, %{field: new_value})
      {:ok, %Topic{}}

      iex> update_topic(topic, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_topic(%Topic{} = topic, attrs) do
    topic
    |> Topic.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a topic.

  ## Examples

      iex> delete_topic(topic)
      {:ok, %Topic{}}

      iex> delete_topic(topic)
      {:error, %Ecto.Changeset{}}

  """
  def delete_topic(%Topic{} = topic) do
    Repo.delete(topic)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking topic changes.

  ## Examples

      iex> change_topic(topic)
      %Ecto.Changeset{data: %Topic{}}

  """
  def change_topic(%Topic{} = topic, attrs \\ %{}) do
    Topic.changeset(topic, attrs)
  end

  @doc """
  Gets a single topic with comments.

  ## Examples

      iex> get_topic_and_comments(123)
      %Topic{}

  """
  def get_topic_and_comments(id) do
    Topic
    |> Repo.get(id)
    |> Repo.preload(comments: [:user])
  end

  @doc """
  Creates a comment.

  ## Examples

      iex> create_comment(topic, user_id, %{field: value})
      {:ok, %Comment{}}

      iex> create_comment(topic, user_id, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_comment(topic, user_id, attrs \\ %{}) do
    topic
    |> Ecto.build_assoc(:comments, user_id: user_id)
    |> Comment.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Gets a single comment.

  ## Examples

      iex> get_comment(123)
      %Comment{}

  """
  def get_comment(comment_id) do
    Comment
    |>Repo.get(comment_id)
    |>Repo.preload(:user)
  end
end
