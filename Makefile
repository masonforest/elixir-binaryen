.DEFAULT_GOAL := all

NO_WARNING_FLAGS = -Wno-deprecated -Wno-reserved-id-macro -Wno-unused-variable -Wno-missing-prototypes -Wno-missing-field-initializers -Wno-unused-function -Wno-format-nonliteral -Wno-float-equal -Wno-sign-compare -Wno-weak-vtables -Wno-exit-time-destructors -Wno-extra-semi -Wno-c++98-compat-pedantic -Wno-unused-parameter -Wno-shadow -Wno-old-style-cast -Wno-zero-length-array -Wno-vexing-parse -Wno-padded -Wno-non-virtual-dtor -Wno-c++98-compat -Wno-double-promotion -Wno-switch-enum -Wno-conversion -Wno-sign-conversion -Wno-covered-switch-default

ERLANG_PATH = $(shell erl -eval 'io:format("~s", [lists:concat([code:root_dir(), "/erts-", erlang:system_info(version), "/include"])])' -s init stop -noshell)

vendor/binaryen/lib/libbinaryen.dylib:
	mkdir -p vendor/binaryen
	# git clone git@github.com:WebAssembly/binaryen.git vendor/binaryen
	# cd vendor/binaryen; cmake . && make


all: vendor/binaryen/lib/libbinaryen.dylib
	clang++ -std=c++11 -stdlib=libc++ -Weverything  $(NO_WARNING_FLAGS) -lbinaryen -lwasm -lsupport -lir -L"../elixir-binaryen/vendor/binaryen/lib" -undefined dynamic_lookup -dynamiclib -o priv/binaryen.so c_src/binaryen.c -I"$(ERLANG_PATH)" -I"../elixir-binaryen/vendor/binaryen/src"

clean:
	rm  -r "priv/binaryen.so"
