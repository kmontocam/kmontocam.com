mod postgres;
use crate::postgres::models::home::LanguageSwitch;
use axum::body::Body;
use axum::extract::State;
use axum::http::HeaderValue;
use http::{Request, Response};
use postgres::models::home::LanguageCode;
use sqlx::postgres::PgPoolOptions;
use sqlx::{Pool, Postgres};
use std::env;
use std::error::Error;
use std::str::FromStr;
use std::time::Duration;
use tower::ServiceBuilder;
use tower_http::trace::TraceLayer;
use tracing::{info, Span};

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
    let trigger = AppendHeaders([("HX-Trigger", "switch-language")]);
    let cookies = AppendHeaders([(SET_COOKIE, format!("LANG={}", code))]);
    return (trigger, cookies);
}

/// Event to translate the content of the document, triggered by `HX-Trigger: switch-language`
/// TODO: create span for the translation in order to include method and path in the response log
async fn language_switch(
    State(state): State<AppState>,
    jar: CookieJar,
    headers: HeaderMap,
) -> String {
    let desired_language: String = jar
        .get("LANG")
        .unwrap_or(&Cookie::new("LANG", "en"))
        .value()
        .to_string();

    let html_id: String = headers
        .get("HX-Trigger")
        .unwrap_or(&HeaderValue::from_str("").unwrap())
        .to_str()
        .unwrap()
        .to_string();

    let switch = sqlx::query_file_as!(
        LanguageSwitch,
        "src/postgres/queries/language_switch.sql",
        LanguageCode::from_str(&desired_language).unwrap_or_default() as LanguageCode,
        html_id
    )
    .fetch_one(&state.pool)
    .await
    .unwrap_or_default();

    return switch.content;
}

#[derive(Clone)]
struct AppState {
    pool: Pool<Postgres>,
}

#[tokio::main]
async fn main() -> Result<(), Box<dyn Error>> {
    let subscriber = tracing_logfmt::builder()
        .subscriber_builder()
        .with_max_level(tracing::Level::INFO)
        .finish();

    let _ = tracing::subscriber::set_global_default(subscriber);

    let pool = PgPoolOptions::new()
        .max_connections(4)
        .connect(&env::var("DATABASE_URL").expect("expected DATABASE_URL environment variable"))
        .await?;

    sqlx::migrate!("./migrations").run(&pool).await?;

    let state = AppState { pool };

    let app = Router::new()
        .route("/language/:code", post(trigger_language_switch))
        .route("/language", get(language_switch))
        .layer(
            ServiceBuilder::new().layer(
                TraceLayer::new_for_http()
                    .on_request(|request: &Request<Body>, _span: &Span| {
                        info!(
                            rest = true,
                            method = %request.method(),
                            path = %request.uri().path(),
                        )
                    })
                    .on_response(
                        |response: &Response<Body>, latency: Duration, _span: &Span| {
                            info!(
                                rest = true,
                                status = response.status().as_u16(),
                                latency = latency.as_secs_f64(),
                                unit = "s"
                            )
                        },
                    ),
            ),
        )
        .with_state(state);

    let listener = tokio::net::TcpListener::bind("0.0.0.0:3000").await?;
    axum::serve(listener, app).await?;

    Ok(())
}
