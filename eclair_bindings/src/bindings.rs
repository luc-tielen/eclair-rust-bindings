use ffi_opaque::opaque;
use libc::size_t;

opaque! {
    pub struct Program;
}

#[repr(C, packed)]
pub struct EclairString {
    pub length: u32,
    pub data: *const u8,
}

// NOTE: all the returned pointers are managed by the Eclair runtime!
// Rust only needs to make sure it calls eclair_program_destroy / eclair_free_buffer
// (using the Drop trait).
extern "C" {
    pub fn eclair_program_init() -> *mut Program;
    pub fn eclair_program_destroy(program: *mut Program);
    pub fn eclair_program_run(program: *mut Program);
    pub fn eclair_add_facts(
        program: *mut Program,
        fact_type: u32,
        fact_data: *mut u32,
        fact_count: size_t,
    );
    pub fn eclair_add_fact(program: *mut Program, fact_type: u32, fact_data: *mut u32);
    pub fn eclair_get_facts(program: *mut Program, fact_type: u32) -> *mut u32;
    pub fn eclair_free_buffer(fact_data: *mut u32);
    pub fn eclair_fact_count(program: *mut Program, fact_type: u32) -> size_t;
    pub fn eclair_encode_string(program: *mut Program, num_bytes: u32, bytes: *const u8) -> u32;
    pub fn eclair_decode_string(program: *mut Program, str_index: u32) -> *const EclairString;
}
