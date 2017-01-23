defmodule Quickbooks.Request do
  @moduledoc """
    Struct to deal with requests
  """
  defstruct [url: "", body: "", headers: [], verb: nil ]
end
