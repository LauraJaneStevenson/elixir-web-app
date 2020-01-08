defmodule Servy.Parser do

  # alias so we can refer to Servy.Conv as Conv
  alias Servy.Conv, as: Conv
  # shortcut
  # alias Servy.Conv

  def parse(request) do
    # parse request str and add vals to struct
    # get first line of request
    # split first line into list of words and store each in variable
    [method, path, _] =
      request
      |> String.split("\n")
      |> List.first
      |> String.split(" ")

    # put variables into struct
    # last expression so it gets returned
    %Conv{
      method: method,
      path: path,
     }
  end
end
