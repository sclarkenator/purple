#-------------------------------------------------------------------
# Owner - Scott Clark
# Mattress firm master store list
#-------------------------------------------------------------------

view: mattress_firm_master_store_list {
  sql_table_name: mattress_firm.master_store_list ;;

  measure: count {
    label: "Count"
    type: count
    drill_fields: [detail*] }

  dimension: store_id {
    primary_key: yes
    hidden: yes
    type: number
    sql: ${TABLE}.store_id ;; }

  dimension: market {
    label: "Market"
    type: string
    sql: ${TABLE}.market ;; }

  dimension: store_name {
    label: "Store Name"
    type: string
    sql: ${TABLE}.store_name ;; }

  dimension: address {
    label: "Address"
    type: string
    sql: ${TABLE}.address ;; }

  dimension: city {
    label: "City"
    type: string
    sql: ${TABLE}.city ;; }

  dimension: state_name {
    label: "State Name"
    map_layer_name: us_states
    type: string
    sql: ${TABLE}.state_name ;; }

  dimension: city_state {
    label: "City, State"
    type: string
    sql: ${TABLE}.city ||', ' ||  ${TABLE}.state_name;; }

  dimension: zip {
    label: "Zip"
    map_layer_name: us_zipcode_tabulation_areas
    type: string
    sql: ${TABLE}.zip ;; }

  dimension: store_phone {
    label: "Store Phone Number"
    type: string
    sql: ${TABLE}.store_phone ;; }

  dimension: number_of_beds {
    label: "Number of Beds"
    type: string
    sql: ${TABLE}.number_of_beds ;; }

  dimension: bed_type {
    label: "Bed Type"
    type: string
    sql: ${TABLE}.bed_type ;; }

  dimension: store_notes {
    label: "Store Notes"
    type: string
    sql: ${TABLE}.store_notes ;; }

  dimension: store_dm {
    label: "Store DM"
    type: string
    sql: ${TABLE}.store_dm ;; }

  dimension: store_rvp {
    label: "Store RVP"
    type: string
    sql: ${TABLE}.store_rvp ;; }

  dimension: store_phase {
    label: "Store Phase"
    type: string
    sql: ${TABLE}.store_phase ;; }

  dimension: additional_items {
    label: "Additional Items"
    type: string
    sql: ${TABLE}.additional_items ;; }

  dimension: open_date {
    label: "Open"
    type: date
    sql: ${TABLE}.open_date ;; }

  dimension: end_date {
    label: "End"
    type: date
    sql: ${TABLE}.end_date ;; }

  dimension: open_weeks {
    label: "Open Weeks"
    description: "Number of complete weeks the store has been open"
    type: number
    sql: case when ${TABLE}.end_date is null then datediff('week' ,${TABLE}.open_date, current_date())
         else datediff('week' ,${TABLE}.open_date, ${TABLE}.end_date) end ;; }

  dimension: open_days {
    label: "Open Days"
    description: "Number of complete days the store has been open"
    type: number
    sql: case when ${TABLE}.end_date is null then datediff('day' ,${TABLE}.open_date, current_date())
         else datediff('day' ,${TABLE}.open_date, ${TABLE}.end_date) end  ;; }

  dimension: open_months {
    label: "Open Months"
    description: "Number of complete months the store has been open"
    type: number
    sql: case when ${TABLE}.end_date is null then datediff('month' ,${TABLE}.open_date, current_date())
         else datediff('month' ,${TABLE}.open_date, ${TABLE}.end_date) end ;; }

  dimension: models {
    label: "Models"
    type: number
    sql: ${TABLE}.models ;; }

  set: detail {
    fields: [
      store_id,
      market,
      store_name,
      address,
      city,
      state_name,
      zip,
      store_phone,
      number_of_beds,
      bed_type,
      store_notes,
      store_dm,
      store_rvp,
      store_phase,
      additional_items,
      open_date,
      end_date,
      models ] }

}
