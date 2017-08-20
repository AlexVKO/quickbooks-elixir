defmodule Quickbooks.OAuth2 do
  use OAuth2.Strategy

  # Public API

  @defaults [
    strategy: __MODULE__,
    client_id: Quickbooks.client_id,
    client_secret: Quickbooks.client_secret,
    redirect_uri: Quickbooks.oauth_callback_url,
    site: "https://api.github.com",
    authorize_url: "https://appcenter.intuit.com/connect/oauth2",
    token_url: "https://oauth.platform.intuit.com/oauth2/v1/tokens/bearer"
  ]

  def client(opts \\ []) do
    opts =
      @defaults
      |> Keyword.merge(opts)

    OAuth2.Client.new(opts)
  end

  def authorize_url! do
    OAuth2.Client.authorize_url!(client(), state: "Application", scope: "com.intuit.quickbooks.accounting openid profile email phone address")
  end

  # you can pass options to the underlying http library via `opts` parameter
  def get_token!(code) do
    OAuth2.Client.get_token!(client(), [code: code]).token
  end

  # Strategy Callbacks

  def authorize_url(client, params) do
    OAuth2.Strategy.AuthCode.authorize_url(client, params)
  end

  def get_token(client, params, headers) do
    client
    |> put_param(:client_secret, client.client_secret)
    |> put_header("accept", "application/json")
    |> OAuth2.Strategy.AuthCode.get_token(params, headers)
  end
end
