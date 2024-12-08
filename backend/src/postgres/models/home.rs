use sqlx::FromRow;
use std::str::FromStr;

#[derive(Debug, Default, sqlx::Type)]
#[sqlx(type_name = "translations_language_code", rename_all = "lowercase")]
pub enum LanguageCode {
    #[default]
    EN,
    ES,
}

#[derive(FromRow, Default)]
pub struct LanguageSwitch {
    pub content: String,
}

impl FromStr for LanguageCode {
    type Err = ();
    fn from_str(s: &str) -> Result<Self, Self::Err> {
        match s {
            "en" => Ok(LanguageCode::EN),
            "es" => Ok(LanguageCode::ES),
            _ => Err(()),
        }
    }
}
