view: adspend_yesterday {
  sql_table_name: MARKETING.ADSPEND_YESTERDAY ;;

  dimension_group: ad {
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
    sql: ${TABLE}."AD" ;;
  }

  dimension: average {
    type: number
    sql: ${TABLE}."AVERAGE" ;;
  }

  dimension: maximum {
    type: number
    sql: ${TABLE}."MAXIMUM" ;;
  }

  dimension: minimum {
    type: number
    sql: ${TABLE}."MINIMUM" ;;
  }

  dimension: spend_platform {
    type: string
    sql: ${TABLE}."SPEND_PLATFORM" ;;
  }

  dimension: total_adspend {
    type: number
    sql: ${TABLE}."TOTAL_ADSPEND" ;;
  }

  dimension: total_clicks {
    type: number
    sql: ${TABLE}."TOTAL_CLICKS" ;;
  }

  dimension: total_impressions {
    type: number
    sql: ${TABLE}."TOTAL_IMPRESSIONS" ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
