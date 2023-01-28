use quote::quote;

pub enum Direction {
    Input,
    Output,
    InputOutput,
}

pub struct FactInfo {
    pub program_type: syn::Type,
    pub fact_direction: Direction,
    fact_name: Option<syn::LitStr>,
}

impl FactInfo {
    pub fn new(
        program_type: syn::Type,
        fact_direction: Direction,
        fact_name: Option<syn::LitStr>,
    ) -> Self {
        Self {
            program_type,
            fact_direction,
            fact_name,
        }
    }

    pub fn fact_name(&self, default_name: String) -> String {
        self.fact_name
            .as_ref()
            .map(|s| s.value())
            .unwrap_or(default_name)
    }
}

impl quote::ToTokens for Direction {
    fn to_tokens(&self, tokens: &mut proc_macro2::TokenStream) {
        tokens.extend(match self {
            Direction::Input => quote!(crate::eclair_bindings::Input),
            Direction::Output => quote!(crate::eclair_bindings::Output),
            Direction::InputOutput => quote!(crate::eclair_bindings::InputOutput),
        })
    }
}
