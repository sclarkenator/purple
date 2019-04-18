view: wholesale_stores {
  sql_table_name: analytics.csv_uploads.retail_store_date ;;

  dimension: Customer {
    label: "Customer"
    type: string
    sql: ${TABLE}.customer ;;
  }

  dimension: Store_name {
    label: "Store Name"
    type: string
    sql: ${TABLE}.store_name ;;
  }

  dimension: Address {
    label: "Address"
    group_label: "Location"
    type: string
    sql: ${TABLE}.address ;;
  }

  dimension: City {
    label: "City"
    group_label: "Location"
    type: string
    sql: ${TABLE}.city ;;
  }

  dimension: State {
    label: "State"
    group_label: "Location"
    type: string
    map_layer_name: us_states
    sql: ${TABLE}.State ;;
  }

  dimension: zip {
    label: "Zip Code"
    group_label: "Location"
    type: string
    map_layer_name: us_zipcode_tabulation_areas
    sql: ${TABLE}.zip ;;
  }

  dimension: country {
    label: "Country"
    group_label: "Location"
    type: string
    map_layer_name: countries
    sql: ${TABLE}.country ;;
  }

  dimension_group: open_date {
  type: time
  timeframes: [date, day_of_week, day_of_month, week, week_of_year, month, month_name, quarter, quarter_of_year, year]
  sql: ${TABLE}.open_date ;;
  }

  measure: count {
    type: count
  }
}
