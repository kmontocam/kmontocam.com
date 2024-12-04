mod postgres;
use crate::postgres::models::home::Translations;
use axum::extract::State;
use axum::http::HeaderValue;
use postgres::models::home::LanguageCode;
use sqlx::postgres::PgPoolOptions;
use sqlx::{Pool, Postgres};
use std::env;
use std::error::Error;
use std::str::FromStr;

use axum::{
    extract::Path,
    http::header::{HeaderMap, SET_COOKIE},
    response::{AppendHeaders, IntoResponse},
    routing::{get, post},
    Router,
};

use axum_extra::extract::cookie::{Cookie, CookieJar};

/// Hook to trigger a language switch in the document
async fn trigger_language_switch(Path(code): Path<String>) -> impl IntoResponse {
    let trigger = AppendHeaders([("HX-Trigger", "changeLanguage")]);
    let cookies = AppendHeaders([(SET_COOKIE, format!("LANG={}", code))]);
    return (trigger, cookies);
}

/// Event to translate the content of the document, triggered by `HTMX-Trigger: changeLanguage`
async fn language_switch(
    State(state): State<AppState>,
    jar: CookieJar,
    headers: HeaderMap,
) -> String {
    let active_language: String = jar
        .get("LANG")
        .unwrap_or(&Cookie::new("LANG", "en"))
        .value()
        .to_string();

    let translation_key: String = headers
        .get("HX-Trigger")
        .unwrap_or(&HeaderValue::from_str("").unwrap())
        .to_str()
        .unwrap()
        .to_string()
        .replace("-", "_");

    let translation = sqlx::query_file_as!(
        Translations,
        "src/postgres/queries/language_switch.sql",
        LanguageCode::from_str(&active_language).unwrap_or_default() as LanguageCode,
        translation_key
    )
    .fetch_one(&state.pool)
    .await
    .unwrap_or_default();

    return translation.content;
}

#[derive(Clone)]
struct AppState {
    pool: Pool<Postgres>,
}

#[tokio::main]
async fn main() -> Result<(), Box<dyn Error>> {
    let pool = PgPoolOptions::new()
        .max_connections(4)
        .connect(&env::var("DATABASE_URL").expect("expected DATABASE_URL environment variable"))
        .await?;

    sqlx::migrate!("./migrations").run(&pool).await?;

    let state = AppState { pool };

    let app = Router::new()
        .route("/language/:code", post(trigger_language_switch))
        .route("/language", get(language_switch))
        .with_state(state);

    let listener = tokio::net::TcpListener::bind("0.0.0.0:3000").await?;
    axum::serve(listener, app).await?;

    Ok(())
}
