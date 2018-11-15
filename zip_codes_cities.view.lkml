view: zip_codes_city {

  derived_table: {
    sql: -- selecting the lowest zip code per city
      SELECT city
        , min(zip_string) as city_zip
      FROM analytics.csv_uploads.zip_codes
      where city IS NOT NULL
      GROUP BY city
      ;;
  }

  dimension: city {
    primary_key: yes
    label: "City Name"
    hidden:  yes
    type:  string
    sql:${TABLE}.city ;; }

  dimension: city_zip {
    label: "City Zip"
    description: "The first zip code per city"
    hidden:  yes
    type:  string
    sql:${TABLE}.city_zip ;; }

}
