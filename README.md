# Quickbooks
[![Hex.pm](http://img.shields.io/hexpm/v/quickbooks.svg)](https://hex.pm/packages/quickbooks)
IN PROGRESS(Not for production yet)

Integration with Quickbooks Online via the Intuit Data Services v3 REST API

This library communicates with the Quickbooks Data Services `v3` API, documented at:

[Data Services v3](https://developer.intuit.com/docs/api/accounting)

## Installation
  1. Add `quickbooks` to your list of dependencies in `mix.exs`:

    ```elixir
    def deps do
      [{:quickbooks, "~> 0.1.0"}]
    end
    ```

  2. Ensure `quickbooks` is started before your application:

    ```elixir
    def application do
      [applications: [:quickbooks]]
    end
    ```

## Getting Started & Initiating Authentication Flow with Intuit

What follows is an example using Phoenix but the principles can be adapted to any other framework / pure Elixir.

Adds in your env.esx

```elixir
# Configure quickbooks
config :quickbooks,
  oauth_consumer_key: "qyprdzfo4URox8GsQiOi0CfTLZaibs",
  oauth_consumer_secret: "5ayBG2IVwozKVdzwW4dDLRFAu8cUoOQqQRjM2fAX",
  oauth_callback_url: "http://localhost:4000/oauth/quickbooks/callback",
  sandbox_mode: true,
  log: true
```

To start the authentication flow with Intuit you include the Intuit Javascript and on a page of your choosing you present the "Connect to Quickbooks" button by including this XHTML:

```HTML
<!-- somewhere in your document include the Javascript -->
<script type="text/javascript" src="https://appcenter.intuit.com/Content/IA/intuit.ipp.anywhere.js"></script>

<!-- configure the Intuit object: 'grantUrl' is a URL in your application which kicks off the flow, see below -->
<script>
intuit.ipp.anywhere.setup({menuProxy: '/path/to/blue-dot', grantUrl: '/path/to/your-flow-start'});
</script>

<!-- this will display a button that the user clicks to start the flow -->
<ipp:connectToIntuit></ipp:connectToIntuit>
```

Your Controller action (the `grantUrl` above) should look like this:

```elixir
  def authenticate(conn, _params) do
    {:ok, response, redirect_url} = Quickbooks.OAuthQBO.get_request_token

    conn
      |> put_session(:token, response["oauth_token"])
      |> put_session(:secret, response["oauth_token_secret"])
      |> redirect external: redirect_url
  end
```

The `callback_url` is set on config section, is the absolute URL of your application that Intuit should send the user when authentication succeeds. That action should look like:

```elixir
def oauth_callback(conn, params) do  
  # Persist token, token_secret and realm_id
end
```

Example to retrieve Customers:
```elixir
alias Quickbooks.AccountingAPI.{CustomerQBO}   


def index(conn, _params) do
  # This credentials we can store in a JSONB column on companies column
  credentials = %{token: user_info.token, token_secret: user_info.secret, realm_id: user_info.realm_id}
  case CustomerQBO.query(credentials) do
    {:ok, response} ->
      {startPosition: start_position, maxResults: max_results, Customer: customers} = response

      ...
    {:error, error} ->
      IO.inspect error
  end
end
```

README based from: [quickbooks-ruby](https://github.com/ruckus/quickbooks-ruby) (Thanks!)
