#-------------------------------------------------------------------
# Owner - Hyrum Ward
# A view into deleted fulfillments for Derek (IT)
#-------------------------------------------------------------------

view: deleted_fulfillment {
  sql_table_name: analytics.sales.deleted_fulfillment ;;

  dimension: fulfillment_id {
    hidden: yes
    primary_key: yes
    type: string
    sql: ${TABLE}.fulfillment_id ;;
  }

  dimension: item_id {
    type: string
    hidden: yes
    sql: ${TABLE}.item_id ;;
  }

  dimension: transaction_type {
    label: "Order Transaction Type"
    type: string
    sql: ${TABLE}.transaction_type ;;
  }

  dimension: order_transaction_number {
    label: "Order TranID"
    type: string
    sql: ${TABLE}.order_transaction_number ;;
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
    timeframes: [raw, date, month, month_name, year]
    convert_tz: no
    datatype: timestamp
    sql: to_timestamp_ntz(${TABLE}.created) ;; }

  dimension_group: fulfilled {
    label: "Fulfilled"
    type: time
    timeframes: [raw, date, month, month_name, year]
    convert_tz: no
    datatype: timestamp
    sql: to_timestamp_ntz(${TABLE}.fulfilled) ;; }

  dimension_group: deleted {
    label: "Deleted"
    type: time
    timeframes: [raw, date, month, month_name, year]
    convert_tz: no
    datatype: timestamp
    sql: to_timestamp_ntz(${TABLE}.deleted) ;; }


  measure: quantity {
    type: sum
    sql:  ${TABLE}.quantity ;;
  }

}
