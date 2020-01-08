defmodule Servy.Handler do
  @moduledoc "Handles HTTP requests."
  # module attributes
  @pages_path Path.expand("../pages", __DIR__)

  # import needed functions from other module
  # Syntax:
  # import Mod_Name only: [func_name: num_args, func_name: num_args, ..]
  import Servy.Plugins, only: [rewrite_path: 1, log: 1, track: 1]
  import Servy.Parser, only: [parse: 1]

  def handle(request) do
    # create pipeline to call each function
    # return value of previous function is
    # passed in as first argument to following function
    request
    |> parse
    |> rewrite_path
    |> log
    |> route
    |> track
    |> format_response
  end

  def route(%{ method: "GET", path: "/wildthings" } = conv) do
    # add value to resp_body key by creating a new map
    %{ conv | status: 200, resp_body: "Bears, Lions, Tigers"}
  end

  def route(%{ method: "GET", path: "/bears" } = conv) do
    # add value to resp_body key by creating a new map
    %{ conv | status: 200, resp_body: "Grizzly,Teddy"}
  end

  # route for individual bears with ids
  def route(%{ method: "GET", path: "/bears/" <> id } = conv) do
    # add value to resp_body key by creating a new map
    %{ conv | status: 200, resp_body: "Bear #{id}"}
  end
  def route(%{method: "GET", path: "/about"} = conv) do
    # get absolute path of file and bing to file variable
    file =
      @pages_path
      |> Path.join("about.html")
      |>File.read  # this will retunr a tuple {:OK, content} {:error,reason}
      |> handle_file(conv)
  end
  # pattern match to call correct function
  def handle_file({:ok, content}, conv) do
    %{ conv | status: 200, resp_body: content}
  end

  def handle_file({:error, enoent}, conv) do
    %{ conv | status: 404, resp_body: "File not found!"}
  end

  def handle_file({:error, reason}, conv) do
    %{ conv | status: 500, resp_body: "File error: #{reason}"}
  end

  # def route(%{method: "GET", path: "/about"} = conv) do
  #   # get absolute path of file and bing to file variable
  #   file =
  #     Path.expand("../pages", __DIR__)
  #     |> Path.join("about.html")
  #
  #   # pass file into case expresson
  #   case File.read(file) do
  #     {:ok, content} ->
  #       %{ conv | status: 200, resp_body: content}
  #     {:error, enoent} ->
  #       %{ conv | status: 404, resp_body: "File not found!"}
  #     # most general case on bottom
  #     {:error, reason} ->
  #       %{ conv | status: 500, resp_body: "File error: #{reason}"}
  #   end
  #
  # end

  # route to handle paths that don't exist
  def route(%{ path: path} = conv) do
    %{ conv | status: 404, resp_body: "No #{path} here!"}
  end

  def format_response(conv) do
    # use values on the map to create an HTTP reponse
    """
    HTTP/1.1 #{conv.status} #{status_reason(conv.status)}
    Content-Type: text/html
    Content-Length: #{String.length(conv.resp_body)}

    #{conv.resp_body}
    """
  end

  # defp for private function can't call outside module
  defp status_reason(code) do
    # map of status messages
    # use arrow syntax to bind key to value
    # keys here numbers not atoms
    %{
      200 => "OK",
      201 => "Created",
      401 => "Unauthorized",
      403 => "Forbidden",
      404 => "Not Found",
      500 => "internal Server Error"
    }[code]
  end

end

request = """
GET /wildthings HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Servy.Handler.handle(request)

IO.puts response

request = """
GET /bears HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Servy.Handler.handle(request)

IO.puts response

request = """
GET /bigfoot HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Servy.Handler.handle(request)

IO.puts response

request = """
GET /wildlife HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Servy.Handler.handle(request)

IO.puts response


request = """
GET /about HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Servy.Handler.handle(request)

IO.puts response
