defmodule Servy.Parser do

  # alias so we can refer to Servy.Conv as Conv
  alias Servy.Conv, as: Conv
  # shortcut
  # alias Servy.Conv

  def parse(request) do
    # parse request str and add vals to struct
    # get first line of request
    [top, params_string] = String.split(request,"\n\n")
    [request_line | header_lines] = String.split(top,"\n")
    # split first line into list of words and store each in variable
    [method, path, _] = String.split(request_line, " ")

    # put variables into struct
    # last expression so it gets returned
    %Conv{
      method: method,
      path: path,
     }
  end
end
