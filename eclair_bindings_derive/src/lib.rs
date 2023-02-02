extern crate proc_macro;
extern crate proc_macro2;
extern crate quote;
extern crate syn;

mod parsing;
mod struct_analysis;
mod types;

use proc_macro::TokenStream;
use quote::quote;
use struct_analysis::*;
use types::*;

// TODO use doctest to test unknown program, invalid direction, enums, parse failures, struct with 0 fields?
// TODO use doctest to try adding/getting facts that are not part of program,
// TODO use doctest and try using inputs as outputs and vice versa

#[proc_macro_attribute]
pub fn fact(attrs: TokenStream, input: TokenStream) -> TokenStream {
    let attrs = syn::parse(attrs).unwrap();
    let struct_info = syn::parse(input).unwrap();
    let generated = generate_impls(&struct_info, &attrs);

    let quoted = quote! {
        #struct_info
        #generated
    };
    quoted.into()
}

fn generate_impls(ast: &syn::DeriveInput, fact_info: &FactInfo) -> proc_macro2::TokenStream {
    match analyze(ast) {
        Ok((fact_name, struct_data)) => {
            let marshal_impl = generate_marshal_impl(&fact_name, struct_data);
            let fact_impl = generate_fact_impl(&fact_name, struct_data, fact_info);

            quote! {
                #marshal_impl
                #fact_impl
            }
        }
        Err(err) => panic!("{}", err),
    }
}

fn generate_marshal_impl(
    fact_name: &syn::Ident,
    struct_data: &syn::DataStruct,
) -> proc_macro2::TokenStream {
    match struct_data.fields {
        syn::Fields::Named(_) => generate_named_struct_marshal_impl(fact_name, struct_data),
        syn::Fields::Unnamed(_) => generate_unnamed_struct_marshal_impl(fact_name, struct_data),
        _ => unreachable!(),
    }
}

fn generate_named_struct_marshal_impl(
    fact_name: &syn::Ident,
    struct_data: &syn::DataStruct,
) -> proc_macro2::TokenStream {
    let serialize_stmts = struct_data.fields.iter().map(|f| {
        let ident = f.ident.as_ref().unwrap();
        quote! {
            self.#ident.serialize(buf);
        }
    });

    let deserialize_stmts = struct_data.fields.iter().map(|f| {
        let ident = f.ident.as_ref().unwrap();
        quote! {
            #ident: crate::eclair_bindings::marshal::Marshal::deserialize(buf)
        }
    });

    quote! {
        impl crate::eclair_bindings::marshal::Marshal for #fact_name {
            fn serialize(&self, buf: &mut crate::eclair_bindings::marshal::WriteCursor) {
                #(#serialize_stmts)*;
            }

            fn deserialize(buf: &mut crate::eclair_bindings::marshal::ReadCursor) -> Self {
                Self {
                    #(#deserialize_stmts),*
                }
            }
        }
    }
}

fn generate_unnamed_struct_marshal_impl(
    fact_name: &syn::Ident,
    struct_data: &syn::DataStruct,
) -> proc_macro2::TokenStream {
    let serialize_stmts = struct_data.fields.iter().enumerate().map(|(idx, _)| {
        let field = syn::Index::from(idx);
        quote! {
            self.#field.serialize(buf);
        }
    });

    let deserialize_stmts = struct_data.fields.iter().enumerate().map(|(idx, _)| {
        let field = syn::Index::from(idx);
        quote! {
            #field: crate::eclair_bindings::marshal::Marshal::deserialize(buf)
        }
    });

    quote! {
        impl crate::eclair_bindings::marshal::Marshal for #fact_name {
            fn serialize(&self, buf: &mut crate::eclair_bindings::marshal::WriteCursor) {
                #(#serialize_stmts)*;
            }

            fn deserialize(buf: &mut crate::eclair_bindings::marshal::ReadCursor) -> Self {
                Self {
                    #(#deserialize_stmts),*
                }
            }
        }
    }
}

fn generate_fact_impl(
    fact_name: &syn::Ident,
    struct_data: &syn::DataStruct,
    fact_info: &FactInfo,
) -> proc_macro2::TokenStream {
    let program_type = &fact_info.program_type;
    let direction = &fact_info.fact_direction;
    // TODO handle nested structs by adding column counts together?
    let column_count = struct_data.fields.len() as u32;
    let eclair_fact_name = fact_info.fact_name(fact_name.to_string());

    quote! {
        impl crate::eclair_bindings::Fact<#program_type> for ::std::marker::PhantomData<#fact_name> {
            type DIRECTION = #direction;
            const COLUMN_COUNT: u32 = #column_count;
            const FACT_NAME: &'static str = #eclair_fact_name;
        }
    }
}
