defmodule Binaryen do
  @on_load :init

  def init do
    :ok = :erlang.load_nif('../elixir-binaryen/priv/binaryen', 0)
  end

  def interpret(_) do
    exit(:nif_library_not_loaded)
  end
end
