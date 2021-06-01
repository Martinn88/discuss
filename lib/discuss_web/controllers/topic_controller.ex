defmodule DiscussWeb.TopicController do
  use DiscussWeb, :controller

  alias Discuss.Blog
  alias Discuss.Blog.Topic

  action_fallback DiscussWeb.FallbackController

  def index(conn, _params) do
    topics = Blog.list_topics()
    render(conn, "index.html", topics: topics)
  end

  def new(conn, _params) do
    changeset = Topic.changeset(%Topic{}, %{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"topic" => topic_params}) do
    case Blog.create_topic(topic_params) do
      {:ok, _topic} ->
        conn
        |> put_flash(:info, "Topic Created")
        |> redirect(to: Routes.topic_path(conn, :index))
      {:error, changeset} -> render(conn, "new.html", changeset: changeset)
    end
  end
 
  def edit(conn, %{"id" => id}) do
    topic = Blog.get_topic!(id)
    changeset = Topic.changeset(topic)
    
    render(conn, "edit.html", changeset: changeset, topic: topic)
  end

  def update(conn, %{"id" => id, "topic" => topic_params}) do
    topic = Blog.get_topic!(id)

    case Blog.update_topic(topic, topic_params) do
      {:ok, _topic} ->
        conn
        |> put_flash(:info, "Topic Updated")
        |> redirect(to: Routes.topic_path(conn, :index))
      {:error, changeset} -> render(conn, "edit.html", changeset: changeset, topic: topic)
    end
  end

  def delete(conn, %{"id" => id}) do
    topic = Blog.get_topic!(id)

    case Blog.delete_topic(topic) do
      {:ok, _topic} ->
        conn
        |> put_flash(:info, "Topic Deleted")
        |> redirect(to: Routes.topic_path(conn, :index))
      {:error, _changeset} ->
        conn
        |> put_flash(:error, "Topic Not Deleted")
        |> redirect(to: Routes.topic_path(conn, :index))
    end
  end
end
