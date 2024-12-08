SELECT
  content
FROM
  "home"."translations"
WHERE
  language_code = $1
  AND html_id = $2;
