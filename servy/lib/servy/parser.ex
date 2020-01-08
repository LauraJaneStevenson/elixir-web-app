defmodule Servy.Parser do
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
end
