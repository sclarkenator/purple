#-------------------------------------------------------------------
# Owner - Scott Clark
# Mattress firm store details
#
#-------------------------------------------------------------------

view: mattress_firm_store_details {
  sql_table_name: mattress_firm.store ;;

  dimension: store_id {
    primary_key: yes
    hidden: no
    type:  string
    sql:  ${TABLE}.store ;; }

  dimension: district {
    label: "District"
    description: "Mattress Firm district designation"
    type:  string
    sql:  ${TABLE}.district ;; }

  dimension: market {
    label: "Market"
    description: "Mattress Firm market designation"
    type:  string
    sql:  ${TABLE}.market ;; }

  dimension: market_state {
    label: "Market State"
    description: "State of the Mattress Firm Store"
    hidden: yes #duplicate of state
    map_layer_name: us_states
    type:  string
    sql:  ${TABLE}.market_state ;; }

  dimension: coordinates {
    label: "Coordinates"
    description: "Latitude and Longitude of Location"
    type:  location
    sql_latitude: ${TABLE}.latitude ;;
    sql_longitude: ${TABLE}.longitude ;; }

  dimension: address {
    label: "Street Address"
    type:  string
    sql:  ${TABLE}.address ;; }

  dimension: city {
    label: "City"
    type:  string
    sql:  ${TABLE}.city ;; }

  dimension: state {
    label: "State"
    map_layer_name: us_states
    type:  string
    sql:  ${TABLE}.state ;; }

  dimension: zipcode {
    label: "Zip (5)"
    map_layer_name: us_zipcode_tabulation_areas
    type:  zipcode
    sql:  ${TABLE}.zip ;; }

  dimension_group: start_date{
    hidden:  yes
    label: "Start"
    description: "Date Mattress Firm started selling Purple in this location"
    type:  time
    timeframes:  [date, day_of_week, day_of_month, week, week_of_year, month, month_name, quarter, quarter_of_year, year]
    datatype: date
    sql: ${TABLE}.start_date ;; }

  measure: store_count {
    label: "Total stores"
    type:  count}

}
