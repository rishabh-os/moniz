pub mod api;
use color_eyre::Report;
fn main() -> Result<(), Report> {
    api::simple::main()
}
