view: inventory {
  sql_table_name: PRODUCTION.INVENTORY ;;

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

  measure: in_transit {
    type: sum
    sql: ${TABLE}."IN_TRANSIT" ;;
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

  measure: on_hand {
    type: sum
    sql: ${TABLE}."ON_HAND" ;;
  }

  measure: on_order {
    type: sum
    sql: ${TABLE}."ON_ORDER" ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
