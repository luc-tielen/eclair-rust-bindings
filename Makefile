
build:
	cargo build

test:
	RUST_BACKTRACE=1 cargo test -p eclair_bindings_derive

clean:
	cargo clean

.PHONY: build test clean
