defmodule Servy.Conv do
  defstruct method: "", path: "", resp_body: "", status: nil

  # function that retunrs
  def full_status(conv) do
    "{conv.status} #{status_reason(conv.status)}"
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
