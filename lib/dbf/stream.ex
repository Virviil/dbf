defmodule Dbf.Stream do
  @moduledoc """
  Presents a DBF data as a Enumerable structure
  """
  defstruct [
    header: nil,
    stream: nil
  ]
end
