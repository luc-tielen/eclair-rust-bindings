extern crate eclair_bindings;
extern crate eclair_bindings_derive;

use eclair_bindings::*;
use eclair_bindings_derive::fact;

#[test]
fn test_fact_with_named_fields() {
    struct P;

    #[derive(Debug, PartialEq, Eq)]
    #[fact(program = P, direction = input_output, name = "x1")]
    struct X {
        field1: u32,
        field2: String,
    }

    let mut eclair = Program::new(P);
    let input_facts = vec![
        X {
            field1: 1,
            field2: "abc".to_string(),
        },
        X {
            field1: 2,
            field2: "def".to_string(),
        },
    ];

    eclair.add_facts(input_facts.into_iter());
    eclair.add_fact(X {
        field1: 3,
        field2: "ghi".to_string(),
    });
    eclair.run();

    let results: Vec<X> = eclair.get_facts().collect();
    assert_eq!(
        results,
        vec![
            X {
                field1: 1,
                field2: "abc".to_string(),
            },
            X {
                field1: 2,
                field2: "def".to_string(),
            },
            X {
                field1: 3,
                field2: "ghi".to_string(),
            },
        ]
    )
}

#[test]
fn test_fact_with_unnamed_fields() {
    struct P;

    #[derive(Debug, PartialEq, Eq)]
    #[fact(program = P, direction = input_output, name = "x2")]
    struct X(u32, String);
    let mut eclair = Program::new(P);
    let input_facts = vec![X(1, "abc".to_string()), X(2, "def".to_string())];

    eclair.add_facts(input_facts.into_iter());
    eclair.add_fact(X(3, "ghi".to_string()));
    eclair.run();

    let results: Vec<X> = eclair.get_facts().collect();
    assert_eq!(
        results,
        vec![
            X(1, "abc".to_string()),
            X(2, "def".to_string()),
            X(3, "ghi".to_string())
        ]
    )
}

#[test]
fn test_end_to_end() {
    struct Path;
    #[fact(program = Path, direction = input, name = "edge")]
    struct Edge(u32, u32);
    #[derive(Debug, PartialEq, Eq)]
    #[fact(program = Path, direction = output, name = "reachable")]
    struct Reachable(u32, u32);

    let mut eclair = Program::new(Path);
    let input_facts = vec![Edge(1, 2), Edge(2, 3)];

    eclair.add_facts(input_facts.into_iter());
    eclair.run();

    let results: Vec<Reachable> = eclair.get_facts().collect();
    assert_eq!(
        results,
        vec![Reachable(1, 2), Reachable(1, 3), Reachable(2, 3)]
    )
}
