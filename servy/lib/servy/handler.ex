defmodule Servey.Handler do
  def handle(request) do
    # create pipeline to call each function
    # return value of previous function is
    # passed in as first argument to following function
    request |> parse |> route |> format_response
  end

  def parse(request) do

    # parse request str and create map
    conv = %{ method: "GET", path: "/wildthings", resp_body: ""}
  end

  def route(conv) do

    # add value to resp_body key by creating a new map
    conv = %{ method: "GET", path "/wildthings", resp_body: "Bears, Lions, Tigers"}
  end

  def format_response(conv) do

    # use values on the map to create an HTTP reponse
    """
    HTTP/1.1 200 OK
    Content-Type: text/html
    Content-Length: 20

    Bears, Lions, Tigers
    """
  end

end
request = """
GET /wildthings HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""
expected-response = """
HTTP/1.1 200 OK
Content-Type: text/html
Content-Length: 20

Bears, Lions, Tigers
"""
response = Servy.Handler.handle(request)

IO.puts response
