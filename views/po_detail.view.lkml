view: mattress_firm_po_detail {
  sql_table_name: "MATTRESS_FIRM"."PO_DETAIL"
    ;;

  dimension_group: created {
    type: time
    timeframes: [raw, hour_of_day, date, day_of_week, day_of_week_index, day_of_month, day_of_year, week, week_of_year, month, month_name, quarter, quarter_of_year, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}."CREATED" ;;
  }

  dimension_group: in_hand {
    type: time
    timeframes: [raw, hour_of_day, date, day_of_week, day_of_week_index, day_of_month, day_of_year, week, week_of_year, month, month_name, quarter, quarter_of_year, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}."IN_HAND" ;;
  }

  dimension_group: arrival {
    type: time
    timeframes: [raw, hour_of_day, date, day_of_week, day_of_week_index, day_of_month, day_of_year, week, week_of_year, month, month_name, quarter, quarter_of_year, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}."ARRIVAL" ;;
  }

  dimension: line_id {
    type: number
    sql: ${TABLE}."LINE_ID" ;;
  }

  dimension: mf_sku {
    type: string
    sql: ${TABLE}."MF_SKU" ;;
  }

  dimension: related_tranid {
    type: string
    sql: ${TABLE}."RELATED_TRANID" ;;
  }

  dimension_group: update_ts {
    hidden: yes
    type: time
    timeframes: [raw, hour_of_day, date, day_of_week, day_of_week_index, day_of_month, day_of_year, week, week_of_year, month, month_name, quarter, quarter_of_year, year]
    sql: ${TABLE}."UPDATE_TS" ;;
  }

  dimension_group: insert_ts {
    hidden: yes
    type: time
    timeframes: [raw, hour_of_day, date, day_of_week, day_of_week_index, day_of_month, day_of_year, week, week_of_year, month, month_name, quarter, quarter_of_year, year]
    sql: ${TABLE}."INSERT_TS" ;;
  }

  measure: ordered_qty {
    type: sum
    sql: ${TABLE}."ORDERED_QTY" ;;
  }

  measure: received_qty {
    type: sum
    sql: ${TABLE}."RECEIVED_QTY" ;;
  }

  measure: remaining_qty {
    type: sum
    sql: ${TABLE}."REMAINING_QTY" ;;
  }

  measure: attempted_delivery {
    type: sum
    sql: ${TABLE}."ATTEMPTED_DELIVERY" ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
