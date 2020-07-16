
default: build

bin:
	mkdir bin

build: bin shard.lock
	crystal build src/compile.cr -o bin/snykctl

release:
	crystal build --release src/compile.cr -o bin/snykctl

shard.lock: shard.yml
	shards update

fmt:
	crystal tool format

spec: test
test:
	crystal spec

lint: shard.lock
	./bin/ameba

lib/icr/bin/icr: shard.lock
	make -C lib/icr install

repl: lib/icr/bin/icr
	./lib/icr/bin/icr


.PHONY: build release fmt test lint repl
