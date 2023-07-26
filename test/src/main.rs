use std::error::Error;
use std::fs::File;
use std::io::BufReader;
use serde::Deserialize;
use std::{net::{IpAddr, Ipv4Addr, SocketAddr}, collections::HashMap};

use axum::{
    response::{AppendHeaders, IntoResponse},
    headers::HeaderMap,
    routing::{get, post},
    http::header::SET_COOKIE,
    Router, Server, Json};

use tower_http::services::ServeDir;
use tower_cookies::{CookieManagerLayer, Cookies};
use lazy_static::lazy_static;


#[derive(Deserialize)]
struct Language {
    lang: String,
}

#[derive(Debug, Deserialize)]
struct Translations {
    #[serde(flatten)]
    lang: HashMap<String, TranslatedContent>,
}

#[derive(Debug, Deserialize)]
struct TranslatedContent {
    #[serde(flatten)]
    translated_content: HashMap<String, String>,
}

fn read_translations_json(path: &str) -> Result<Translations, Box<dyn Error>> {
    let file = File::open(path)?;
    let reader = BufReader::new(file);
    let translations: Translations = serde_json::from_reader(reader)?;

    Ok(translations)
}

async fn trigger_lng_switch(Json(payload): Json<Language>) -> impl IntoResponse {
    let trigger = AppendHeaders([
        ("HX-Trigger", "changeLanguage")
    ]);
    let cookies = AppendHeaders([
        (SET_COOKIE, format!("LANG={}", payload.lang))
    ]);
    (trigger, cookies)
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
    let translation = TRANSLATIONS.lang[&active_language].translated_content[&translation_key].to_string();
    translation
}

lazy_static! {
    static ref TRANSLATIONS: Translations = read_translations_json("../../axum/src/lang/translations.json").unwrap();
}

#[tokio::main]
async fn main() {
    let app = Router::new()
        .nest_service("/", ServeDir::new("../../index.html"))
        .nest_service("/assets", ServeDir::new("../../assets/"))
        .route("/api/lang", post(trigger_lng_switch))
        .route("/api/lang/switch", get(translate))
        .layer(CookieManagerLayer::new());

    let address = SocketAddr::new(IpAddr::V4(Ipv4Addr::LOCALHOST), 3000);
    let server = Server::bind(&address);

    server.serve(app.into_make_service()).await.unwrap()}
