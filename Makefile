
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

test:
	crystal spec

lint: shard.lock
	./bin/ameba

.PHONY: build release fmt test lint
