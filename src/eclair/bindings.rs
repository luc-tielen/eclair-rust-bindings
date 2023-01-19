use ffi_opaque::opaque;
use libc::size_t;

opaque! {
    pub struct Program;
}

pub type Buffer = u32;
pub type EclairString = u8;

extern "C" {
    fn eclair_program_init() -> *mut Program;
    fn eclair_program_destroy(program: *mut Program);
    fn eclair_program_run(program: *mut Program);
    fn eclair_add_facts(
        program: *mut Program,
        fact_type: u32,
        fact_data: *const Buffer,
        fact_count: size_t,
    );
    fn eclair_add_fact(program: *mut Program, fact_type: u32, fact_data: *const Buffer);
    fn eclair_get_facts(program: *mut Program, fact_type: u32) -> *const Buffer;
    fn eclair_free_buffer(fact_data: *const Buffer);
    fn eclair_fact_count(program: *mut Program, fact_type: u32) -> size_t;
    fn eclair_encode_string(
        program: *mut Program,
        num_bytes: u32,
        bytes: *const EclairString,
    ) -> u32;
    fn eclair_decode_string(program: *mut Program, str_index: u32) -> *const EclairString;
}
