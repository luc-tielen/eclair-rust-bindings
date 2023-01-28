use crate::syn::Data::Struct;

pub fn analyze(ast: &syn::DeriveInput) -> Result<(&syn::Ident, &syn::DataStruct), &'static str> {
    if let Struct(struct_data) = &ast.data {
        if struct_data.fields.is_empty() {
            return Err("You can only create facts with one or more fields.");
        }

        // TODO: can we find a reliable way to check type information at this point?
        Ok((&ast.ident, struct_data))
    } else {
        return Err("fact macro is only allowed on structs.");
    }
}
