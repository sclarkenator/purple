view: inventory_snap {
  sql_table_name: PRODUCTION.INVENTORY_SNAP ;;

  dimension: item_location_date {
    hidden:  yes
    primary_key: yes
    sql:  ${item_id}||'-'||${location_id}||'-'||${TABLE}.created ;;
  }

  measure: available {
    type: sum
    sql: ${TABLE}."AVAILABLE" ;;
  }

  measure: backordered {
    type: sum
    sql: ${TABLE}."BACKORDERED" ;;
  }

  dimension_group: created {
    type: time
    timeframes: [
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}."CREATED" ;;
  }

  measure: inbound {
    type: sum
    sql: ${TABLE}."INBOUND" ;;
  }

  dimension: item_id {
    hidden: yes
    type: number
    sql: ${TABLE}."ITEM_ID" ;;
  }

  dimension: location_id {
    type: number
    sql: ${TABLE}."LOCATION_ID" ;;
  }

  dimension: OUTBOUND {
    type: number
    sql: ${TABLE}."OUTBOUND" ;;
  }

  dimension: ON_ORDER {
    type: number
    sql: ${TABLE}."ON_ORDER" ;;
  }

  measure: on_hand {
    type: sum
    sql: ${TABLE}."ON_HAND" ;;
  }

  measure: Total_on_order {
    type: sum
    sql: ${TABLE}."ON_ORDER" ;;
  }

  measure: Total_INBOUND {
    type: sum
    sql: ${TABLE}."INBOUND" ;;
  }

  measure: TOTAL_OUTBOUND {
    type: sum
    sql: ${TABLE}."OUTBOUND" ;;
  }
  measure: count {
    type: count
    drill_fields: []
  }
}
