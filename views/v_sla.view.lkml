view: v_sla {
  sql_table_name: "SHIPPING"."V_SLA"
    ;;

  measure: available {
    type: sum
    sql: ${TABLE}."AVAILABLE" ;;
  }

  dimension: category {
    type: string
    sql: ${TABLE}."CATEGORY" ;;
  }

  dimension: description {
    type: string
    sql: ${TABLE}."DESCRIPTION" ;;
  }

  measure: forecast_3_w {
    type: sum
    sql: ${TABLE}."FORECAST_3W" ;;
  }

  dimension: last_updated {
    type: string
    sql: ${TABLE}."LAST_UPDATED" ;;
  }

  dimension_group: last_update {
    type: time
    label: "SLA last changed"
    timeframes: [date]
    sql: ${TABLE}."LAST_UPDATE" ;;
  }

 dimension: sla_range {
   type: string
   sql:  ${TABLE}.sla_range ;;
 }

  dimension: wg_sla_range {
    type: string
    sql:  ${TABLE}.wg_sla_range ;;
  }

  dimension: line {
    type: string
    sql: ${TABLE}."LINE" ;;
  }

  dimension: model {
    type: string
    sql: ${TABLE}."MODEL" ;;
  }

  measure: on_hand {
    type: sum
    sql: ${TABLE}."ON_HAND" ;;
  }

  measure: open_orders {
    type: sum
    sql: ${TABLE}."OPEN_ORDERS" ;;
  }

  dimension: sku_id {
    type: string
    primary_key: yes
    sql: ${TABLE}."SKU_ID" ;;
  }

  measure: sla {
    type: sum
    sql: ${TABLE}."SLA" ;;
  }

  dimension: today {
    type: date
    sql:  ${TABLE}."TODAY" ;;
  }

  measure: white_glove_sla {
    type: sum
    sql: ${TABLE}."WHITE_GLOVE_SLA" ;;
  }

}
