defmodule Quickbooks.OAuthQBO do
  @moduledoc """
    OAuth wrapper for Quickbooks
  """
  import Quickbooks.Request.Base

  @request_token_url "https://oauth.intuit.com/oauth/v1/get_request_token"
  @access_token_path "https://oauth.intuit.com/oauth/v1/get_access_token"
  @user_authorization_url	"https://appcenter.intuit.com/Connect/Begin"

  @doc """
    Returns {:status, :response, :redirect_url}

    status = :ok / :error
    response = %{"oauth_callback_confirmed" => ..., "oauth_token" => ..., "oauth_token_secret" => ...}
    rediret_url = url for user authorization screen.
  }
  """
  def get_request_token() do
    %Quickbooks.Request{}
    |> add_url("url", @request_token_url)
    |> add_verb("post")
    |> oauth_sign_request(nil,nil,{"oauth_callback", Quickbooks.oauth_callback_url})
    |> execute
    |> case do
      {:ok, body} ->
        %{"oauth_token" => token, "oauth_token_secret" => secret} = URI.decode_query(body)
        {:ok, URI.decode_query(body), user_authorization_url(token)}
      {:error, error} ->
        {:error, error}
    end
  end

  @doc """
    Adds authorization on headers of each request
    returns `Quickbooks.Request` struct
  """
  def oauth_sign_request(request, token \\ nil, token_secret \\ nil, additional_headers \\ nil) do
    %Quickbooks.Request{ headers: headers, url: url, verb: verb} = request

    credentials =
      OAuther.credentials(
      consumer_key: Quickbooks.oauth_consumer_key , #"qyprdzfo4URox8GsQiOi0CfTLZaibs",
      consumer_secret: Quickbooks.oauth_consumer_secret, #{}"5ayBG2IVwozKVdzwW4dDLRFAu8cUoOQqQRjM2fAX",
      token: token,
      token_secret: token_secret)

      if additional_headers do
        params = OAuther.sign(verb, url, [{"oauth_callback", Quickbooks.oauth_callback_url}], credentials)
      else
        params = OAuther.sign(verb, url, [], credentials)
      end
      {authorize_headers, _} = OAuther.header(params)
      %Quickbooks.Request{ request | headers: [authorize_headers] ++ headers }
    end

  @doc """
    Build authorization url based on Quickbooks url and user token
  """
  defp user_authorization_url(token) do
    @user_authorization_url <> "?oauth_token=" <> token
  end
end
