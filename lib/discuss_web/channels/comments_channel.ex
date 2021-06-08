defmodule DiscussWeb.CommentsChannel do
    use DiscussWeb, :channel
  
    alias Discuss.Blog

    def join("comments:" <> topic_id, _params, socket) do
        topic_id = String.to_integer(topic_id)
        topic = Blog.get_topic_and_comments(topic_id)

        {:ok, %{comments: topic.comments}, assign(socket, :topic, topic)}
    end

    def handle_in(_name, %{"content" => content}, socket) do
        topic = socket.assigns.topic
        user_id = socket.assigns.user_id

        case Blog.create_comment(topic, user_id, %{content: content}) do
            {:ok, comment} ->
                comment_with_user = Blog.get_comment(comment.id)
                broadcast!(socket, "comments:#{socket.assigns.topic.id}:new", %{comment: comment_with_user})
                {:reply, :ok, socket}
            {:error, changeset} ->
                {:reply, {:error, %{errors: changeset}}, socket}
        end
        
    end

  end