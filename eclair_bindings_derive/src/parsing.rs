use super::types::*;

const USAGE: &'static str = "Usage: #[fact(program = PROGRAM_TYPE, direction = input|output|input_output (, name = \"...\")?]";

impl syn::parse::Parse for Direction {
    fn parse(buf: &syn::parse::ParseBuffer) -> Result<Self, syn::Error> {
        let dir: syn::Ident = buf.parse()?;
        match dir.to_string().as_str() {
            "input" => Ok(Direction::Input),
            "output" => Ok(Direction::Output),
            "input_output" => Ok(Direction::InputOutput),
            _ => Err(syn::Error::new(
                dir.span(),
                "Invalid direction, only 'input', 'output' and 'input_output' are supported.",
            )),
        }
    }
}

impl syn::parse::Parse for FactInfo {
    fn parse(buf: &syn::parse::ParseBuffer) -> Result<Self, syn::Error> {
        let program: syn::Ident = buf.parse()?;
        if program.to_string() != "program" {
            return Err(syn::Error::new(program.span(), USAGE));
        }
        let _: syn::Token![=] = buf.parse()?;
        let program_type = buf.parse()?;

        let _: syn::Token![,] = buf.parse()?;

        let dir: syn::Ident = buf.parse()?;
        if dir.to_string() != "direction" {
            return Err(syn::Error::new(dir.span(), USAGE));
        }
        let _: syn::Token![=] = buf.parse()?;
        let fact_direction = buf.parse()?;

        let fact_name = if buf.is_empty() {
            None
        } else {
            let _: syn::Token![,] = buf.parse()?;
            let name: syn::Ident = buf.parse()?;
            if name.to_string() != "name" {
                return Err(syn::Error::new(name.span(), USAGE));
            }
            let _: syn::Token![=] = buf.parse()?;
            Some(buf.parse()?)
        };

        Ok(FactInfo::new(program_type, fact_direction, fact_name))
    }
}
