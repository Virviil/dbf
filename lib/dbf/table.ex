defmodule Dbf.Table do
  @moduledoc """
  Represents DBF file as table structure. IT's slower then streamed version, but keeps everything in memory,
  so can be used multiple times.
  """

  defstruct [
    header: nil,
    data: nil
  ]
end
