defmodule Quickbooks.Request.Base do
  @moduledoc """
    A set of methods to deal with `Quickbooks.Request` and do http request on #execute/1
  """

  use HTTPoison.Base

  @doc """
    Do a GET request and
    returns status and decoded body
  """
  def execute(%Quickbooks.Request{ headers: headers, url: url, verb: verb } = request) when verb == "get" do
    case get(url, headers) do
      {:ok, %HTTPoison.Response{body: body, status_code: 200}} ->
        {:ok, Poison.decode!(body) }
      {_, error} ->
        {:error, error}
    end
  end

  @doc """
    Do a POST request and
    returns status and decoded body
  """
  def execute(%Quickbooks.Request{ headers: headers, url: url, body: body, verb: verb } = request) when verb == "post" do
    case HTTPoison.post(url, body , headers) do
      {:ok, %{status_code: 200} = response} ->
        {:ok, response.body}
      {_, response} ->
        {:error, URI.decode_query(response.body)}
    end
  end

  @doc """
    Adds body params to `Quickbooks.Request` struct
    returns struct
  """
  def add_body_params(request, body) do
    %Quickbooks.Request{ request | body: body } #Poison.encode!(body) }
  end

  @doc """
    Adds verb params to `Quickbooks.Request` struct

    Quickbooks only works with "POST" and "GET"
    https://developer.intuit.com/docs/0100_quickbooks_online/0300_references/rest_essentials_for_the_quickbooks_api#/URI_format

    returns struct
  """
  def add_verb(request, verb) do
    if verb == "delete" do
      %Quickbooks.Request{ add_query_params(request, "operation=delete") | verb: "post" }
    else
      %Quickbooks.Request{ request | verb: verb }
    end
  end

  @doc """
    Adds headers params to `Quickbooks.Request` struct
    returns struct
  """
  def add_headers(%Quickbooks.Request{ headers: headers } = request, additional_headers) do
    %Quickbooks.Request{ request | headers: headers ++ [additional_headers] }
  end

  @doc """
    Adds query params to url of `Quickbooks.Request` struct
    returns struct
  """
  def add_query_params(%Quickbooks.Request{ url: url } = request, params) do
    if Regex.match?(~r/\?/, url) do
      stringfied_params = url <> "&#{params}"
    else
      stringfied_params = url <> "?#{params}"
    end
    %Quickbooks.Request{ request | url: stringfied_params }
  end

  @doc """
    Build the URL following Quickbooks pattern

    https://developer.intuit.com/docs/0100_quickbooks_online/0300_references/rest_essentials_for_the_quickbooks_api#/Base_URLs

    returns struct
  """
  def build_qbo_url(request, base_url, realm_id, resource_name, entity_id \\ nil)  do
    url =
      [base_url, realm_id, resource_name, entity_id]
      |> List.delete(nil)
      |> Enum.join("/")

    %Quickbooks.Request{ request | url: url }
  end

  @doc """
    Build initial headers for request:
     - Request JSON
     - Set user Agent
    returns struct
  """
  def build_headers(request) do
    headers = [
      {"Accept", "application/json; Charset=utf-8"},
      {"User-Agent",	"Quickbooks Elixir"}
    ]

    %Quickbooks.Request{ request | headers: headers }
  end

  @doc """
    Adds given url to 'Quickbooks.Request' struct
    returns struct
  """
  def add_url(request, "url", url)  do
    %Quickbooks.Request{ request | url: url }
  end
end
