view: v_demand_planning {
  sql_table_name: "PRODUCTION"."V_DEMAND_PLANNING"
    ;;

  dimension: item_id {
    type: number
    sql: ${TABLE}."ITEM_ID" ;;
  }

  dimension: year {
    hidden: no
    type: number
    sql: ${TABLE}."YEAR" ;;
  }

  dimension: week_of_year {
    hidden: no
    type: number
    sql: ${TABLE}."WEEK_OF_YEAR" ;;
  }

  dimension: demand_planning_week {
    type: date
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
