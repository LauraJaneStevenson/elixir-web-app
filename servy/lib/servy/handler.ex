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
    |> log
    |> route
    |> format_response
  end

  # print and return given data structure (conv) unchanged
  # in singleline function
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
       status: nil,
       sm: ""
     }
  end

  def route(conv) do
    # program will pattern match to get the
    # correct route function for path
    route(conv, conv.method, conv.path)

  end

  def route(conv, "GET", "/wildthings") do
    # add value to resp_body key by creating a new map
    %{ conv | status: 200, sm: "OK", resp_body: "Bears, Lions, Tigers"}
  end

  def route(conv, "GET", "/bears") do
    # add value to resp_body key by creating a new map
    %{ conv | status: 200, sm: "OK", resp_body: "Grizzly,Teddy"}
  end

  # route to handle paths that don't exist
  def route(conv, _method, path) do
    %{ conv | status: 404, sm: "NOT FOUND",resp_body: "No #{path} here!"}
  end


  def format_response(conv) do
    # use values on the map to create an HTTP reponse
    """
    HTTP/1.1 #{conv.status} #{conv.sm}
    Content-Type: text/html
    Content-Length: #{String.length(conv.resp_body)}

    #{conv.resp_body}
    """
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
