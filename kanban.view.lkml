view: kanban {
  sql_table_name: production.kanban;;


  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: item_id {
    type: number
    primary_key: yes
    hidden: yes
    sql: ${TABLE}."ITEM_ID" ;;
  }

  dimension: purple_target {
    type: number
    hidden: yes
    sql: ${TABLE}."PURPLE_TARGET" ;;
  }

  dimension: purple_temp {
    type: number
    hidden: yes
    sql: ${TABLE}."PURPLE_TEMP" ;;
  }

  dimension: purple_peak {
    type: number
    hidden: yes
    sql: ${TABLE}."PURPLE_PEAK" ;;
  }

  dimension: manna {
    type: number
    hidden: yes
    sql: ${TABLE}."MANNA" ;;
  }

  dimension: mattress_firm {
    type: number
    hidden: yes
    sql: ${TABLE}."MATTRESS_FIRM" ;;
  }

  dimension: amazon {
    type: number
    hidden: yes
    sql: ${TABLE}."AMAZON" ;;
  }

  measure: purple_target_kanban {
    type: sum
    sql: ${TABLE}."PURPLE_TARGET" ;;
  }

  measure: purple_temp_kanban {
    type: sum
    sql: ${TABLE}."PURPLE_TEMP" ;;
  }

  measure: purple_peak_kanban {
    type: sum
    sql: ${TABLE}."PURPLE_PEAK" ;;
  }

  measure: manna_kanban {
    type: sum
    sql: ${TABLE}."MANNA" ;;
  }

  measure: mattress_firm_kanban {
    type: sum
    sql: ${TABLE}."MATTRESS_FIRM" ;;
  }

  measure: amazon_kanban {
    type: sum
    sql: ${TABLE}."AMAZON" ;;
  }

  set: detail {
    fields: [
      item_id,
      purple_target,
      purple_temp,
      purple_peak,
      manna,
      mattress_firm,
      amazon
    ]
  }
}
