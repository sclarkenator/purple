view: v_transmission_dates {
  sql_table_name: SHIPPING.V_TRANSMISSION_DATES ;;

  dimension_group: download_to_warehouse_edge {
    hidden: yes
    label: "Download to Warehouse Edge"
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}."DOWNLOAD_TO_WAREHOUSE_EDGE" ;;
  }

  dimension: v_transmission_dates_primary {
    hidden: yes
    primary_key: yes
    sql: ${v_transmission_dates_item_id}||${v_transmission_dates_order_id}||${v_transmission_dates_system} ;;
  }

  dimension: v_transmission_dates_item_id {
    hidden: yes
    label: "Transmission Dates Item ID"
    type: number
    sql: ${TABLE}."ITEM_ID" ;;
  }

  dimension: v_transmission_dates_order_id {
    hidden: yes
    label: "Transmission Dates OrderID"
    type: number
    sql: ${TABLE}."ORDER_ID" ;;
  }

  dimension: v_transmission_dates_system {
    hidden: yes
    label: "Transmission Dates System"
    type: string
    sql: ${TABLE}."SYSTEM" ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
