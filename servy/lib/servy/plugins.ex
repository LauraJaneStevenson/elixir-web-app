defmodule Servy.Plugins do

  alias Servy.Conv

  # if argument coming in contains a status of 404
  # execute this function
  @doc "Logs 404 request"
  def track(%Conv{status: 404, path: path } = conv) do
    IO.puts "WARNING: #{path} is on the loose!"
    conv
  end

  # singleline function to handle non 404 statuses
  def track(%Conv{} = conv), do: conv

  # function that changes path wildlife to wildthings
  # only matches if conv.path is "/wildlife"
  def rewrite_path(%Conv{ path: "/wildlife"} = conv) do
    %{ conv | path: "/wildthings" }
  end

  # one line function that handles all paths not /wildlife
  def rewrite_path(%Conv{} = conv), do: conv

  # print and return given data structure (conv) unchanged
  # in single line function
  def log(%Conv{} = conv), do: IO.inspect conv

end
