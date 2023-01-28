extern crate eclair_bindings;
extern crate eclair_bindings_derive;

use eclair_bindings_derive::fact;

#[test]
fn test1() {
    struct P;

    #[fact(program = P, direction = output, name = "x")]
    struct X {
        field1: u32,
        field2: String,
    }
    // TODO test serialization properly, with a lot of variations
    assert!(1 == 1);
}
