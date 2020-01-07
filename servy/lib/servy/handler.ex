defmodule Servy.Handler do
  def handle(request) do
    # conv = parse(request)
    # conv = route(conv)
    # format_response(conv)

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

  # if argument coming in contains a status of 404
  # execute this function
  def track(%{status: 404, path: path } = conv) do
    IO.puts "WARNING: #{path} is on the loose!"
    conv
  end

  # singleline function to handle non 404 statuses
  def track(conv), do: conv

  # print and return given data structure (conv) unchanged
  # in single line function
  def log(conv), do: IO.inspect conv

  def parse(request) do

    # parse request str and create map

    # get first line of request
    # split first line into list of words and store each in variable
    [method, path, _] =
      request
      |> String.split("\n")
      |> List.first
      |> String.split(" ")

    # put variables into map
    # last expression so it gets returned
    %{ method: method,
       path: path,
       resp_body: "",
       status: nil
     }
  end

  # function that changes path wildlife to wildthings
  # only matches if conv.path is "/wildlife"
  def rewrite_path(%{ path: "/wildlife"} = conv) do
    %{ conv | path: "/wildthings" }
  end

  # one line function that handles all paths not /wildlife
  def rewrite_path(conv), do: conv


  # def route(conv) do
  #   # program will pattern match to get the
  #   # correct route function for path
  #   route(conv, conv.method, conv.path)
  #
  # end

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
