use color_eyre::Report;
use std::fs::File;
use tracing_subscriber::EnvFilter;

use rimage::{
    config::{Codec, EncoderConfig},
    image::DynamicImage,
    Decoder, Encoder,
};

#[tokio::main]
pub async fn main() -> Result<(), Report> {
    setup()?;

    let decoder = Decoder::from_path("test-input.jpg")?;

    let image = decoder.decode()?;

    let config = EncoderConfig::new(Codec::MozJpeg).with_quality(80.0)?;
    let file = File::create("output.jpg")?;

    let encoder = Encoder::new(file, DynamicImage::ImageRgba8(image.into())).with_config(config);

    encoder.encode()?;

    Ok(())
}

fn setup() -> Result<(), Report> {
    if std::env::var("RUST_LIB_BACKTRACE").is_err() {
        std::env::set_var("RUST_LIB_BACKTRACE", "full");
    }
    color_eyre::install()?;

    if std::env::var("RUST_LOG").is_err() {
        std::env::set_var("RUST_LOG", "info")
    }
    tracing_subscriber::fmt::fmt()
        .with_env_filter(EnvFilter::from_default_env())
        .init();

    Ok(())
}

#[flutter_rust_bridge::frb(sync)] // Synchronous mode for simplicity of the demo
pub fn greet(name: String) -> String {
    format!("Hello, {name}!")
}

#[flutter_rust_bridge::frb(init)]
pub fn init_app() {
    // Default utilities - feel free to customize
    flutter_rust_bridge::setup_default_user_utils();
}
