pub mod bindings;
pub mod internal;
pub mod marshal;

use std::marker::PhantomData;

pub struct Program<T> {
    prog: internal::Program,
    _marker: PhantomData<T>,
}

// Structs used to indicate fact direction at the type level
pub struct Input;
pub struct Output;
pub struct InputOutput;

pub trait Fact<Prog> {
    type DIRECTION: Direction;
    const COLUMN_COUNT: u32;
    const FACT_NAME: &'static str;
}

impl<P> Program<P> {
    pub fn new(_handle: P) -> Self {
        Self {
            prog: internal::Program::new(),
            _marker: PhantomData,
        }
    }

    pub fn run(&mut self) {
        self.prog.run()
    }

    // NOTE: for now mut is needed since we need to potentially
    // mutate the runtime (by encoding a Eclair string)
    // TODO: create a "try_lookup_string" in Eclair that does no mutation
    pub fn get_facts<FactType>(&mut self) -> ReadBufferIterator<FactType>
    where
        PhantomData<FactType>: Fact<P>,
        <PhantomData<FactType> as Fact<P>>::DIRECTION: IsOutput,
    {
        let name = <PhantomData<FactType> as Fact<P>>::FACT_NAME;
        let fact_type_idx = self.prog.encode_string(name).0;
        ReadBufferIterator::new(&self.prog, fact_type_idx)
    }

    pub fn add_fact<FactType>(&mut self, fact: FactType)
    where
        PhantomData<FactType>: Fact<P>,
        <PhantomData<FactType> as Fact<P>>::DIRECTION: IsInput,
        FactType: marshal::Marshal,
    {
        let name = <PhantomData<FactType> as Fact<P>>::FACT_NAME;
        let column_count = <PhantomData<FactType> as Fact<P>>::COLUMN_COUNT;
        let fact_type_idx = self.prog.encode_string(name).0;

        // TODO can we avoid a heap allocation here?
        let mut vec: Vec<u32> = Vec::with_capacity(column_count as usize);
        let buf_ptr = vec.as_mut_ptr();
        let mut cursor = marshal::WriteCursor::new(&mut self.prog, buf_ptr);
        fact.serialize(&mut cursor);
        self.prog.add_fact(fact_type_idx, buf_ptr);
    }

    pub fn add_facts<FactType, Iter>(&mut self, facts: Iter)
    where
        Iter: ExactSizeIterator<Item = FactType>,
        FactType: marshal::Marshal,
        PhantomData<FactType>: Fact<P>,
        <PhantomData<FactType> as Fact<P>>::DIRECTION: IsInput,
    {
        let name = <PhantomData<FactType> as Fact<P>>::FACT_NAME;
        let fact_type_idx = self.prog.encode_string(name).0;
        let fact_count = facts.len();
        let column_count = <PhantomData<FactType> as Fact<P>>::COLUMN_COUNT as usize;
        let vec_size = fact_count * column_count;

        let mut vec: Vec<u32> = Vec::with_capacity(vec_size);
        let buf_ptr = vec.as_mut_ptr();
        let mut cursor = marshal::WriteCursor::new(&mut self.prog, buf_ptr);
        for fact in facts {
            fact.serialize(&mut cursor);
        }

        self.prog.add_facts(fact_type_idx, buf_ptr, fact_count);
    }
}

pub struct ReadBufferIterator<'a, T> {
    cursor: marshal::ReadCursor<'a>,
    count: usize,
    current: usize,
    _buf: internal::Buffer, // used for automatic cleanup
    _marker: PhantomData<T>,
}

impl<'a, T> ReadBufferIterator<'a, T> {
    fn new(prog: &'a internal::Program, fact_type_idx: u32) -> Self {
        let count = prog.fact_count(fact_type_idx);
        let buf = prog.get_facts(fact_type_idx);
        let buf_ptr = buf.ptr;
        Self {
            cursor: marshal::ReadCursor::new(prog, buf_ptr),
            count,
            current: 0,
            _buf: buf,
            _marker: PhantomData,
        }
    }
}

impl<'a, T: marshal::Marshal> Iterator for ReadBufferIterator<'a, T> {
    type Item = T;

    fn next(&mut self) -> Option<T> {
        if self.count == self.current {
            None
        } else {
            let unmarshalled = marshal::Marshal::deserialize(&mut self.cursor);
            self.current += 1;
            Some(unmarshalled)
        }
    }

    fn size_hint(&self) -> (usize, Option<usize>) {
        let count = self.len();
        (count, Some(count))
    }
}

impl<'a, T: marshal::Marshal> ExactSizeIterator for ReadBufferIterator<'a, T> {
    fn len(&self) -> usize {
        self.count
    }
}

// Some type level programming to avoid misuse of facts
pub trait Direction: sealed::Direction {}
impl Direction for Input {}
impl Direction for Output {}
impl Direction for InputOutput {}

pub trait IsInput: sealed::IsInput {}
impl IsInput for Input {}
impl IsInput for InputOutput {}

pub trait IsOutput: sealed::IsOutput {}
impl IsOutput for Output {}
impl IsOutput for InputOutput {}

mod sealed {
    // Sealed traits so no external code can derive extra implementations
    pub trait Direction {}
    impl Direction for super::Input {}
    impl Direction for super::Output {}
    impl Direction for super::InputOutput {}

    pub trait IsInput {}
    impl IsInput for super::Input {}
    impl IsInput for super::InputOutput {}

    pub trait IsOutput {}
    impl IsOutput for super::Output {}
    impl IsOutput for super::InputOutput {}
}
