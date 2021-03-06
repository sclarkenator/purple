view: zip_codes_city {

  derived_table: {
    sql: -- selecting the lowest zip code per city
      SELECT city
        , state_name
        , min(zip_string) as city_zip
      FROM analytics.csv_uploads.zip_codes
      where city IS NOT NULL and in_dma = FALSE
      GROUP BY city, state_name
      ;;
  }

  dimension: city {
    label: "City Name"
    hidden:  yes
    type:  string
    sql:${TABLE}.city ;; }

  dimension: state_name {
    label: "State Name"
    hidden:  yes
    type:  string
    sql:${TABLE}.state_name ;; }

  dimension: city_zip {
    label: "City Zip"
    description: "The first zip code per city"
    hidden:  yes
    type:  string
    sql:${TABLE}.city_zip ;;
    primary_key: yes
    }

}
