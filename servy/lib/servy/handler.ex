defmodule Servey.Handler do

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
