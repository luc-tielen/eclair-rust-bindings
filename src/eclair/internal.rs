use super::bindings;
use std::str;

pub struct Program {
    handle: *mut bindings::Program,
}

impl Drop for Program {
    fn drop(&mut self) {
        // SAFETY: We rely on Eclair always being able to safely cleanup a program instance.
        // Besides that, in the new function we assert the pointer is not null.
        unsafe { bindings::eclair_program_destroy(self.handle) }
    }
}

impl Program {
    pub fn new() -> Self {
        // SAFETY: We rely on Eclair always being able to allocate memory and return a valid
        // initialized program instance. We perform an assert on the pointer just to be sure
        // the pointer is not null.
        let prog = unsafe { bindings::eclair_program_init() };
        assert!(!prog.is_null());
        Self { handle: prog }
    }

    // NOTE: Mutable borrow to avoid running same Eclair program twice concurrently!
    pub fn run(&mut self) {
        // SAFETY: We rely on Eclair generating a valid run function.
        // Besides that, in the new function we assert the pointer is not null.
        unsafe { bindings::eclair_program_run(self.handle) };
    }

    pub fn get_facts(&self, fact_type: u32) -> Buffer {
        // SAFETY: We rely on Eclair returning a valid pointer to a buffer.
        // We also rely on the calling code to correctly pass in a valid fact
        // type for this Eclair program.
        let ptr = unsafe { bindings::eclair_get_facts(self.handle, fact_type) };
        assert!(!ptr.is_null());
        Buffer { ptr }
    }

    pub fn fact_count(&self, fact_type: u32) -> usize {
        // SAFETY: We rely on Eclair for safety of calling this function.
        // We also rely on the calling code to correctly pass in a valid fact
        // type for this Eclair program.
        unsafe { bindings::eclair_fact_count(self.handle, fact_type) }
    }

    pub fn add_facts(&mut self, fact_type: u32, buf: Buffer, count: usize) {
        // SAFETY: We rely on Eclair for safety of calling this function.
        // We also rely on the calling code to correctly pass in a valid fact
        // type for this Eclair program.
        unsafe { bindings::eclair_add_facts(self.handle, fact_type, buf.ptr, count) }
    }

    pub fn add_fact(&mut self, fact_type: u32, buf: Buffer) {
        // SAFETY: We rely on Eclair for safety of calling this function.
        // We also rely on the calling code to correctly pass in a valid fact
        // type for this Eclair program.
        unsafe { bindings::eclair_add_fact(self.handle, fact_type, buf.ptr) }
    }

    pub fn encode_string(&mut self, s: &str) -> StringIndex {
        let bytes = s.as_ptr();
        let len = s
            .len()
            .try_into()
            .expect("Eclair only supports strings up to 4GB!");
        // SAFETY: We rely on Eclair for safety of calling this function.
        let raw_idx = unsafe { bindings::eclair_encode_string(self.handle, len, bytes) };
        StringIndex(raw_idx)
    }

    pub fn decode_string<'a, 'b>(&'a self, idx: &'b StringIndex) -> Option<&'a str> {
        let ptr = unsafe { bindings::eclair_decode_string(self.handle, idx.0) };
        if ptr.is_null() {
            None
        } else {
            // SAFETY: We rely on Eclair for safety of calling this function.
            // The returned str is managed by Eclair and lives as long as the
            // program stays alive.
            let slice = unsafe {
                let estr = std::ptr::read(ptr);
                std::slice::from_raw_parts(estr.data, estr.length as usize)
            };
            str::from_utf8(slice).ok()
        }
    }
}

pub struct StringIndex(u32);

pub struct Buffer {
    ptr: *const bindings::Buffer,
}

impl Drop for Buffer {
    fn drop(&mut self) {
        // SAFETY: We rely on Eclair returning a valid pointer to a buffer.
        // Also, we assert that the pointer is valid in the get_facts function
        unsafe { bindings::eclair_free_buffer(self.ptr) }
    }
}
