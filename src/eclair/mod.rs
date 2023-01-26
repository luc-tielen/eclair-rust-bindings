pub mod bindings;
pub mod internal;
pub mod marshal;

use std::marker::PhantomData;

pub struct Program<T> {
    prog: internal::Program,
    _marker: PhantomData<T>,
}

pub trait Fact {
    // TODO can this be cleaned up? or hide via proc macro?
    fn fact_name(_marker: PhantomData<Self>) -> &'static str;
    fn column_count(_marker: PhantomData<Self>) -> u32;
}

pub trait InputFact<Prog> {}
pub trait OutputFact<Prog> {}

impl<T> Program<T> {
    pub fn new(_handle: T) -> Self {
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
    pub fn get_facts<FactType: Fact>(&mut self) -> ReadBufferIterator<FactType>
    where
        FactType: OutputFact<T>,
    {
        let name = Fact::fact_name(PhantomData::<FactType>);
        let fact_type_idx = self.prog.encode_string(name).0;
        ReadBufferIterator::new(&self.prog, fact_type_idx)
    }

    pub fn add_fact<FactType: Fact + InputFact<T> + marshal::Marshal>(&mut self, fact: FactType) {
        let name = Fact::fact_name(PhantomData::<FactType>);
        let fact_type_idx = self.prog.encode_string(name).0;

        // TODO can we avoid a heap allocation here?
        let mut vec: Vec<u32> =
            Vec::with_capacity(Fact::column_count(PhantomData::<FactType>) as usize);
        let buf_ptr = vec.as_mut_ptr();
        let mut cursor = marshal::WriteCursor::new(&mut self.prog, buf_ptr);
        fact.serialize(&mut cursor);
        self.prog.add_fact(fact_type_idx, buf_ptr);
    }

    pub fn add_facts<
        FactType: Fact + InputFact<T> + marshal::Marshal,
        Iter: ExactSizeIterator<Item = FactType>,
    >(
        &mut self,
        facts: Iter,
    ) {
        let name = Fact::fact_name(PhantomData::<FactType>);
        let fact_type_idx = self.prog.encode_string(name).0;
        let fact_count = facts.len();
        let column_count = Fact::column_count(PhantomData::<FactType>) as usize;
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
