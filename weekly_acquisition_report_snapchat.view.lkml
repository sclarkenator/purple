view: weekly_acquisition_report_snapchat {
  sql_table_name: MARKETING.WEEKLY_ACQUISITION_REPORT ;;

  measure: cpm {
    type: number
    sql: ${TABLE}."CPM" ;;
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



  dimension: platform {
    type: string
    sql: ${TABLE}."PLATFORM" ;;
  }

  measure: revenue {
    type: number
    sql: ${TABLE}."REVENUE" ;;
  }

  measure: roas {
    type: number
    sql: ${TABLE}."ROAS" ;;
  }

  measure: spend {
    type: number
    sql: ${TABLE}."SPEND" ;;
  }


}
