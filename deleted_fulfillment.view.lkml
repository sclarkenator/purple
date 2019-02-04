#-------------------------------------------------------------------
# Owner - Hyrum Ward
# A view into deleted fulfillments for Derek (IT)
#-------------------------------------------------------------------

view: deleted_fulfillment {
  sql_table_name: analytics.sales.deleted_fulfillment ;;

  dimension: fulfillment_id {
    label: "FF ID"
    primary_key: yes
    type: string
    sql: ${TABLE}.fulfillment_id ;;
  }

  dimension: item_id {
    type: string
    hidden: yes
    sql: ${TABLE}.item_id ;;
  }

  dimension: carrier {
    label: "Carrier"
    type: string
    sql: ${TABLE}.carrier ;;
  }

  dimension: status {
    label: "Status"
    type: string
    sql: ${TABLE}.status ;;
  }

  dimension: item_name {
    label: "Item Name"
    type: string
    sql: ${TABLE}.item_name ;;
  }

  dimension_group: created {
    label: "Created"
    type: time
    timeframes: [raw, date, day_of_week, day_of_month, week, week_of_year, month, month_name, quarter, quarter_of_year, year]
    convert_tz: no
    datatype: timestamp
    sql: to_timestamp_ntz(${TABLE}.created) ;; }

  dimension_group: fulfilled {
    label: "Fulfilled"
    type: time
    timeframes: [raw, date, day_of_week, day_of_month, week, week_of_year, month, month_name, quarter, quarter_of_year, year]
    convert_tz: no
    datatype: timestamp
    sql: to_timestamp_ntz(${TABLE}.fulfilled) ;; }

  dimension_group: deleted {
    label: "Deleted"
    type: time
    timeframes: [raw, date, day_of_week, day_of_month, week, week_of_year, month, month_name, quarter, quarter_of_year, year]
    convert_tz: no
    datatype: timestamp
    sql: to_timestamp_ntz(${TABLE}.deleted) ;; }


  measure: quantity {
    type: sum
    sql:  ${TABLE}.quantity ;;
  }

}
