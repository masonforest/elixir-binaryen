#include <binaryen-c.h>
#include <wasm-io.h>
#include <wasm-interpreter.h>
#include "wasm-binary.h"
#include "shell-interface.h"
#include "erl_nif.h"
#include <iostream>

using namespace wasm;

static ERL_NIF_TERM nacl_error_tuple(ErlNifEnv *env, char *error_atom) {
  return enif_make_tuple2(env, enif_make_atom(env, "error"), enif_make_atom(env, error_atom));
}


ERL_NIF_TERM interpret(ErlNifEnv* env, int argc, const ERL_NIF_TERM argv[])
{
  unsigned int requested_size;
  ErlNifBinary code;
  enif_inspect_binary(env, argv[0], &code);
  std::vector<char> data(code.data, code.data + code.size);
  Module module;
  WasmBinaryBuilder parser(module, data, false);
  parser.read();
  auto tempInterface = make_unique<ShellExternalInterface>();
  auto tempInstance = wasm::make_unique<ModuleInstance>(module, tempInterface.get());
  wasm::Literal a = tempInstance->callExport(Name("main"));
  return enif_make_int(env, a.getInteger());
}

static ErlNifFunc nif_funcs[] = {
  {"interpret", 1, interpret}
};

ERL_NIF_INIT(Elixir.Binaryen, nif_funcs, NULL, NULL, NULL, NULL);
