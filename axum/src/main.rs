use serde::Deserialize;
use std::error::Error;
use std::fs::File;
use std::io::BufReader;
use std::{
    collections::HashMap,
    net::{IpAddr, Ipv4Addr, SocketAddr},
};

use axum::{
    headers::HeaderMap,
    http::header::SET_COOKIE,
    response::{AppendHeaders, IntoResponse},
    routing::{get, post},
    Json, Router, Server,
};

use lazy_static::lazy_static;
use tower_cookies::{CookieManagerLayer, Cookies};

#[derive(Deserialize)]
struct Language {
    lang: String,
}

#[derive(Debug, Deserialize)]
struct TranslatedContent {
    #[serde(flatten)]
    translated_content: HashMap<String, String>,
}

#[derive(Debug, Deserialize)]
struct Translations {
    #[serde(flatten)]
    lang: HashMap<String, TranslatedContent>,
}

fn read_translations_json(path: &str) -> Result<Translations, Box<dyn Error>> {
    let file = File::open(path)?;
    let reader = BufReader::new(file);
    let translations: Translations = serde_json::from_reader(reader)?;

    return Ok(translations);
}

async fn trigger_lang_switch(Json(payload): Json<Language>) -> impl IntoResponse {
    let trigger = AppendHeaders([("HX-Trigger", "changeLanguage")]);
    let cookies = AppendHeaders([(SET_COOKIE, format!("LANG={}", payload.lang))]);
    return (trigger, cookies);
}

async fn translate(cookies: Cookies, headers: HeaderMap) -> String {
    let active_language: String = match cookies.get("LANG") {
        Some(cookie) => cookie.value().to_string(),
        None => "en".to_string(),
    };

    let html_id = match headers.get("HX-Trigger") {
        Some(header) => header.to_str().unwrap(),
        None => {
            return "".to_string();
        }
    };
    let translation_key: String = html_id.to_string().replace("-", "_");
    let translation =
        TRANSLATIONS.lang[&active_language].translated_content[&translation_key].to_string();

    return translation;
}

lazy_static! {
    static ref TRANSLATIONS: Translations =
        read_translations_json("./lang/translations.json").unwrap();
}

#[tokio::main]
async fn main() {
    let app = Router::new()
        .route("/lang", post(trigger_lang_switch))
        .route("/lang/switch", get(translate))
        .layer(CookieManagerLayer::new());

    let address = SocketAddr::new(IpAddr::V4(Ipv4Addr::LOCALHOST), 3000);
    let server = Server::bind(&address);

    server.serve(app.into_make_service()).await.unwrap()
}
