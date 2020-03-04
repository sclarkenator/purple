view: production_goal_by_item {
  sql_table_name: "PRODUCTION"."PRODUCTION_GOAL_BY_ITEM"
    ;;

  dimension_group: forecast {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}."FORECAST" ;;
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

  dimension: item_id {
    type: number
    sql: ${TABLE}."ITEM_ID" ;;
  }

  dimension: percent_units {
    type: number
    sql: ${TABLE}."PERCENT_UNITS" ;;
  }

  dimension: sku_id {
    type: string
    sql: ${TABLE}."SKU_ID" ;;
  }

  dimension: total_units {
    type: number
    sql: ${TABLE}."TOTAL_UNITS" ;;
  }

  dimension: units_fg_produced {
    type: number
    sql: ${TABLE}."UNITS_FG_PRODUCED" ;;
  }

  dimension: units_peak_produced {
    type: number
    sql: ${TABLE}."UNITS_PEAK_PRODUCED" ;;
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
    drill_fields: []
  }
}
