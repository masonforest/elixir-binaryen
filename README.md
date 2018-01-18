# Elixir bindings for [Binaryen](https://github.com/WebAssembly/binaryen)

## Installation

1. Add binaryen to your list of dependencies in `mix.exs`:

  ```elixir
  def deps do
    [
      {:binaryen},
    ]
  end
  ```

## Usage

First you'll need to install binaryen


    brew install binaryen


Then compile some WebAssembly text format to bytecode:

    # 99.wast

    (module
    (func $main (result i32)
      (i32.const 99))
    (export "main" (func $main)))

-

    wasm-as 99.wat 99.wasm


Now you can run it in Elixir!

    {:ok, code} = File.read("99.wasm")
    Binaryen.interpret(code)

