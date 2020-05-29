view: target_dtc {
  sql_table_name: "CSV_UPLOADS"."TARGET_DTC"
    ;;

  measure: amount {
    type: sum
    #value_format: "$#,##0,\" K\""
    value_format: "$#,##0"
    sql: ${TABLE}."AMOUNT" ;;
  }

  dimension_group: date {
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
    sql: ${TABLE}."DATE" ;;
  }

}
