view: zip_codes_city {

  sql_table_name: analytics.heap.v_ecommerce_zip_codes_city ;;

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
