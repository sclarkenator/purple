view: mattress_firm_store_details {
  sql_table_name: mattress_firm.store ;;

  dimension: store_id {
    hidden:  yes
    type:  string
    sql:  ${TABLE}.store_id ;;
  }

  dimension: district {
    hidden:  yes
    type:  string
    sql:  ${TABLE}.district ;;
  }

  dimension: market {
    hidden:  yes
    type:  string
    sql:  ${TABLE}.market ;;
  }

  dimension: market_state {
    hidden:  yes
    type:  string
    sql:  ${TABLE}.market_state ;;
  }

  dimension: state {
    hidden:  yes
    type:  string
    sql:  ${TABLE}.state ;;
  }

  dimension: coordinates {
    hidden:  yes
    type:  location
    sql_latitude: ${TABLE}.latitude ;;
    sql_longitude: ${TABLE}.longitude ;;
  }

  dimension: zipcode {
    hidden:  yes
    type:  zipcode
    sql:  ${TABLE}.zip ;;
  }

    dimension_group: start_date{
    hidden:  yes
    description: "Date Mattress Firm started selling Purple in this location"
    type:  time
    timeframes: [
      date,
      week,
      month,
      quarter,
      year
    ]
    datatype: date
    sql: ${TABLE}.start_date
  }

  measure: final_units {
    label: "Total units sold"
    description: "Total units finalized to customer"
    type:  sum
    sql:  ${TABLE}.mf_Sku ;;
  }


}
