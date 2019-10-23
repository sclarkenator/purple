view: weekly_acquisition_report_snapchat {
  sql_table_name: MARKETING.WEEKLY_ACQUISITION_REPORT ;;

  dimension: cpm {
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

  dimension: revenue {
    type: number
    sql: ${TABLE}."REVENUE" ;;
  }

  dimension: roas {
    type: number
    sql: ${TABLE}."ROAS" ;;
  }

  dimension: spend {
    type: number
    sql: ${TABLE}."SPEND" ;;
  }



  measure: count {
    type: count
    drill_fields: []
  }
}
