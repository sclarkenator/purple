view: wholesale_stores {
  sql_table_name: datagrid.prod.retail_location_geo ;;

  dimension: Customer {
    label: "Parent Account"
    type: string
    sql: ${TABLE}.parent_account ;;
  }

  dimension: Store_name {
    label: "Store Name"
    type: string
    sql: ${TABLE}.location_name ;;
  }

  dimension: salesforce_store_id {
    label: "Store ID"
    type: string
    sql: ${TABLE}.LOCATION_ID;;
  }

  dimension: Address {
    label: "Street Address"
    group_label: "Location"
    type: string
    sql: ${TABLE}.street_address ;;
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
    sql: ${TABLE}.state_short_name ;;
  }

  dimension: zip {
    label: "Zip Code"
    group_label: "Location"
    type: zipcode
    map_layer_name: us_zipcode_tabulation_areas
    sql: ${TABLE}.zip_code ;;
  }

  dimension: coordinates{
    type: location
    sql_latitude: ${TABLE}.latitude;;
    sql_longitude:${TABLE}.longitude ;;
  }

  dimension: latitude {
    type: string
    hidden: yes
    sql: ${TABLE}.latitude ;;
  }

  dimension: longitude {
    type: string
    hidden: yes
    sql: ${TABLE}.longitude ;;
  }

  dimension_group: open_date {
  label: "Open"
  type: time
  timeframes: [date, day_of_week, day_of_month, week, week_of_year, month, month_name, quarter, quarter_of_year, year]
  sql: ${TABLE}.add_purple_dt ;;
  }

  #Danielle- Removed this dimension bc Hyrum dropped the column in snowflake
  #dimension: is_inactive {
    #type: yesno
    #hidden: no
    #sql: ${TABLE}.is_inactive = 'T' ;;
  #}

  dimension: primary_key {
    primary_key: yes
    sql: ${TABLE}.pk;;
    hidden: yes
  }

  dimension:  location_type{
    type: string
    sql:  ${TABLE}.location_type ;;
  }

  measure: count {
    type: count
  }
}
