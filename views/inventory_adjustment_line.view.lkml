view: inventory_adjustment_line {
  sql_table_name: "PRODUCTION"."INVENTORY_ADJUSTMENT_LINE"
    ;;

  dimension: account {
    type: string
    sql: ${TABLE}."ACCOUNT" ;;
  }

  measure: adjust_qty_by {
    type: sum
    sql: ${TABLE}."ADJUST_QTY_BY" ;;
  }

  dimension_group: created {
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
    sql: ${TABLE}."CREATED" ;;
  }

  dimension: department {
    type: string
    sql: ${TABLE}."DEPARTMENT" ;;
  }

  dimension: has_cost_line {
    type: yesno
    sql: ${TABLE}."HAS_COST_LINE" ;;
  }

  dimension: inventory_adjustment_id {
    type: number
    # hidden: yes
    sql: ${TABLE}."INVENTORY_ADJUSTMENT_ID" ;;
  }

  dimension: is_cost_line {
    type: yesno
    sql: ${TABLE}."IS_COST_LINE" ;;
  }

  dimension: item_id {
    hidden: yes
    type: number
    sql: ${TABLE}."ITEM_ID" ;;
  }

  dimension: location {
    type: string
    sql: ${TABLE}."LOCATION" ;;
  }

  dimension: memo {
    type: string
    sql: ${TABLE}."MEMO" ;;
  }

  dimension_group: modified {
    hidden: yes
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
    sql: ${TABLE}."MODIFIED" ;;
  }

  dimension: product_line {
    type: string
    sql: ${TABLE}."PRODUCT_LINE" ;;
  }

  dimension: transaction_line_id {
    type: number
    sql: ${TABLE}."TRANSACTION_LINE_ID" ;;
  }

  measure: unit_cost {
    type: sum
    sql: ${TABLE}."UNIT_COST" ;;
  }

  dimension: units {
    type: string
    sql: ${TABLE}."UNITS" ;;
  }

  dimension_group: insert_ts {
    hidden: yes
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
    sql: ${TABLE}."INSERT_TS" ;;
  }

  dimension_group: update_ts {
    hidden: yes
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
    sql: ${TABLE}."UPDATE_TS" ;;
  }

  measure: count {
    type: count
    drill_fields: [inventory_adjustment.inventory_adjustment_id]
  }
}
