mod eclair;

use crate::syn::Data::Struct;
use proc_macro::TokenStream;
use quote::quote;
use syn;

#[proc_macro_derive(Marshal)]
pub fn derive_marshal(tokens: TokenStream) -> TokenStream {
    let ast = syn::parse(tokens).unwrap();
    generate_derived_marshal_impl(&ast)
}

fn generate_derived_marshal_impl(ast: &syn::DeriveInput) -> TokenStream {
    if let Struct(structData) = &ast.data {
        let name = &ast.ident;
        let quoted = quote! {
            impl Marshal for #name {
                fn serialize(&self, buf: &mut ByteBuf) {
                    todo!()
                }

                fn deserialize(buf: &mut ByteBuf) -> Self {
                    todo!()
                }
            }
        };

        quoted.into()
    } else {
        panic!("Only structs can derive Marshal!")
    }
}
