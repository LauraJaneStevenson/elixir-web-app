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

  # print and return given data structure(conv) unchanged
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
    %{ method: method, path: path, resp_body: ""}
  end

  def route(conv) do

    # add value to resp_body key by creating a new map
    %{ conv | resp_body: "Bears, Lions, Tigers"}
  end

  def format_response(conv) do
    # use values on the map to create an HTTP reponse
    """
    HTTP/1.1 200 OK
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
