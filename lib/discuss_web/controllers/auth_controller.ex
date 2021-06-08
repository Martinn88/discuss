defmodule DiscussWeb.AuthController do
    use DiscussWeb, :controller
    plug Ueberauth

    alias Discuss.Auth

    action_fallback DiscussWeb.FallbackController

    def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
        user_params = %{token: auth.credentials.token, email: auth.info.email, provider: "github"}

        signin(conn, user_params)
    end

    defp signin(conn, user_params) do 
        case insert_or_update_user(user_params) do
            {:ok, user} ->
                conn
                |> put_flash(:info, "Welcom back!")
                |> put_session(:user_id, user.id)
                |> redirect(to: Routes.topic_path(conn, :index))
            {:error, _reason} -> 
                conn
                |> put_flash(:error, "Error signing in")
                |> redirect(to: Routes.topic_path(conn, :index))
        end
    end

    def signout(conn, _params) do
        conn
        |> configure_session(drop: true)
        |> redirect(to: Routes.topic_path(conn, :index))
    end
    
    defp insert_or_update_user(user_params) do
        case Auth.get_user_by_email(email: user_params.email) do
            nil -> Auth.create_user(user_params)
            user -> {:ok, user}
        end
    end
end