SELECT
  content
FROM
  "home"."translations"
WHERE
  language_code = $1
  AND section = $2;
