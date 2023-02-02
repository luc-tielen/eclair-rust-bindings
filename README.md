# eclair-rust-bindings

High level Rust bindings for interoperability with
[Eclair Datalog](https://github.com/luc-tielen/eclair-lang.git).

The code consists of two crates:

- `eclair_bindings`: wraps an idiomatic Rust interface around the low level
  Eclair API.
- `eclair_bindings_derive`: provides a proc macro that generates the bindings
  boilerplate for you (highly recommended).

## Example usage

```rust
extern crate eclair_bindings;
extern crate eclair_bindings_derive;

use eclair_bindings::*;
use eclair_bindings_derive::fact;

struct Path;

#[fact(program = Path, direction = input, name = "edge")]
struct Edge(u32, u32);

#[fact(program = Path, direction = output, name = "reachable")]
struct Reachable {
    start: u32,
    end: u32,
}

fn main() {
    let mut eclair = Program::new(Path);

    let edges = vec![Edge(1, 2), Edge(2, 3)];

    eclair.add_facts(edges.into_iter());
    eclair.add_fact(Edge(3, 4));
    eclair.run();

    let results: Vec<Reachable> = eclair.get_facts().collect();
    // process results ...
}
```
