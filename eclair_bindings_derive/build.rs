extern crate eclair_builder;

use std::env;

fn main() {
    // TODO remove once Eclair is self-hosted!
    let datalog_dir = env::var("DATALOG_DIR").expect("'DATALOG_DIR' env var needs to be set!");

    eclair_builder::Build::new()
        .eclair("eclair")
        .clang("clang-14") // Important: eclair uses LLVM14 under the hood!
        .datalog_dir(&datalog_dir)
        .file("tests/fixtures/test.eclair")
        .compile();
}
