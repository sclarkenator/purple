view: production_goal_by_item {
  sql_table_name: "PRODUCTION"."PRODUCTION_GOAL_BY_ITEM"
    ;;

  dimension: pk {
    label: "Primary key for Production Goal"
    primary_key: yes
    hidden: yes
    type: string
    sql: concat(${TABLE}."FORECAST", ${TABLE}."ITEM_ID");;
  }

  dimension_group: forecast {
    hidden: yes
    view_label: "Production Goals"
    type: time
    timeframes: [date, day_of_week, day_of_month, week, week_of_year, month, month_name, quarter, quarter_of_year, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}."FORECAST" ;;
  }

  dimension: item_id {
    hidden: yes
    label: "Item ID"
    view_label: "Production Goals"
    type: number
    sql: ${TABLE}."ITEM_ID" ;;
  }

  dimension: percent_units {
    hidden: yes
    label: "Percent of Forecasted Units"
    view_label: "Production Goals"
    type: number
    sql: ${TABLE}."PERCENT_UNITS" ;;
  }

  dimension: sku_id {
    hidden: yes
    label: "SKU ID"
    view_label: "Production Goals"
    type: string
    sql: ${TABLE}."SKU_ID" ;;
  }

  measure: total_units{
    label: "Forecasted Units"
    view_label: "Production Goals"
    description: "Number of Forecasted Units by SKU"
    type: sum
    sql: ${TABLE}."TOTAL_UNITS" ;;
  }

  measure: units_fg_produced {
    label: "Finished Goods Produced (units)"
    view_label: "Production Goals"
    hidden: yes
    description: "Number of Finished Goods Produced (units) by SKU"
    type: sum
    value_format: "#,##0"
    sql: ${TABLE}."UNITS_FG_PRODUCED" ;;
  }

  measure: units_peak_produced {
    label: "Peak Produced (units)"
    view_label: "Production Goals"
    hidden: yes
    description: "Number of Peaks Produced (units) by SKU"
    type: sum
    sql: ${TABLE}."UNITS_PEAK_PRODUCED" ;;
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
    view_label: "Production Goals"
    type: count
    drill_fields: []
  }
}
