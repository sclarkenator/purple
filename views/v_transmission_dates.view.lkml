view: v_transmission_dates {
  sql_table_name: SHIPPING.V_TRANSMISSION_DATES ;;

  dimension: item_id {
    hidden: yes
    label: "Transmission Dates Item ID"
    type: number
    sql: ${TABLE}."ITEM_ID" ;;
  }

  dimension: order_id {
    hidden: yes
    label: "Transmission Dates OrderID"
    type: number
    sql: ${TABLE}."ORDER_ID" ;;
  }

  dimension: system {
    hidden: yes
    label: "Transmission Dates System"
    type: string
    sql: ${TABLE}."SYSTEM" ;;
  }

  dimension: primary_key {
    hidden: yes
    primary_key: yes
    sql: ${item_id}||${order_id}||${system} ;;
  }

  dimension: hold_reason {
    hidden: yes
    label: "Hold Reason"
    sql: ${TABLE}.hold_reason ;;
  }

  dimension_group: download_to_warehouse_edge {
    hidden: yes
    label: "Download to Warehouse Edge"
    type: time
    timeframes: [raw,time,date,week,month,quarter,year]
    sql: ${TABLE}."DOWNLOAD_TO_WAREHOUSE_EDGE" ;;
  }

  dimension_group: SHIPPING_HOLD_START {
    hidden: yes
    type: time
    timeframes: [raw,time,date,week,month,quarter,year]
    sql: ${TABLE}."SHIPPING_HOLD_START" ;;
  }

  dimension_group: SHIPPING_HOLD_END {
    hidden: yes
    type: time
    timeframes: [raw,time,date,week,month,quarter,year]
    sql: ${TABLE}."SHIPPING_HOLD_END" ;;
  }

  dimension_group: PENDING_APPROVAL_START {
    hidden: yes
    type: time
    timeframes: [raw,time,date,week,month,quarter,year]
    sql: ${TABLE}."PENDING_APPROVAL_START" ;;
  }

  dimension_group: PENDING_APPROVAL_END {
    hidden: yes
    type: time
    timeframes: [raw,time,date,week,month,quarter,year]
    sql: ${TABLE}."PENDING_APPROVAL_END" ;;
  }

  dimension_group: ADDRESS_VALIDATION_START {
    hidden: yes
    type: time
    timeframes: [raw,time,date,week,month,quarter,year]
    sql: ${TABLE}."ADDRESS_VALIDATION_START" ;;
  }

  dimension_group: ADDRESS_VALIDATION_END {
    hidden: yes
    type: time
    timeframes: [raw,time,date,week,month,quarter,year]
    sql: ${TABLE}."ADDRESS_VALIDATION_END" ;;
  }

  dimension_group: TRANSMITTED_TO_MAINFREIGHT {
    hidden: yes
    type: time
    timeframes: [raw,time,date,week,month,quarter,year]
    sql: ${TABLE}."TRANSMITTED_TO_MAINFREIGHT" ;;
  }

  dimension_group: TRANSMITTED_TO_PILOT {
    hidden: yes
    type: time
    timeframes: [raw,time,date,week,month,quarter,year]
    sql: ${TABLE}."TRANSMITTED_TO_PILOT" ;;
  }

  dimension_group: transmitted {
    hidden: yes
    type:  time
    timeframes: [raw,time,date,week,month,quarter,year]
    sql: coalesce(${TRANSMITTED_TO_MAINFREIGHT_raw}, ${TRANSMITTED_TO_PILOT_raw}) ;;

  }


}
