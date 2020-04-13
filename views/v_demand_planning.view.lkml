view: v_demand_planning {
  sql_table_name: "PRODUCTION"."V_DEMAND_PLANNING"
    ;;

  dimension: item_id {
    type: number
    sql: ${TABLE}."ITEM_ID" ;;
  }

  dimension: year {
    hidden: yes
    type: number
    sql: ${TABLE}."YEAR" ;;
  }

  dimension: week_of_year {
    hidden: yes
    type: number
    sql: ${TABLE}."WEEK_OF_YEAR" ;;
  }

  dimension_group: demand_planning {
    type: time
    timeframes: [raw, date, week_of_year, month, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}."FIRST_DAY_OF_WEEK" ;;
  }

  measure: forecast_units {
    type: sum
    sql: ${TABLE}."FORECAST_UNITS" ;;
  }

  measure: po_units {
    type: sum
    sql: ${TABLE}."PO_UNITS" ;;
  }

  measure: demand_inventory {
    type: sum
    sql: ${TABLE}."DEMAND_INVENTORY" ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
