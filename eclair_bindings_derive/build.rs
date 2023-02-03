extern crate cc;

fn main() {
    // TODO: Also invoke Eclair compiler to generate the test.ll
    cc::Build::new()
        .compiler("clang")
        .file("tests/fixtures/test.ll")
        .compile("eclair");
}
