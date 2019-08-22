view: rpt_monthly_awards {
  sql_table_name: CUSTOMER_CARE.RPT_MONTHLY_AWARDS ;;

  dimension: agent {
    type: string
    sql: ${TABLE}."AGENT" ;;
  }

  dimension: avg_handle_time {
    type: number
    sql: ${TABLE}."AVG_HANDLE_TIME" ;;
  }

  dimension: avg_hold_time {
    type: number
    sql: ${TABLE}."AVG_HOLD_TIME" ;;
  }

  dimension: avg_talk_time {
    type: number
    sql: ${TABLE}."AVG_TALK_TIME" ;;
  }

  dimension: campaign {
    type: string
    sql: ${TABLE}."CAMPAIGN" ;;
  }

  dimension: handled {
    type: number
    sql: ${TABLE}."HANDLED" ;;
  }

  dimension_group: insert_ts {
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

  dimension: longest_talk_time {
    type: number
    sql: ${TABLE}."LONGEST_TALK_TIME" ;;
  }

  dimension: occupancy {
    type: number
    sql: ${TABLE}."OCCUPANCY" ;;
  }

  dimension_group: report_month {
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
    sql: ${TABLE}."REPORT_MONTH" ;;
  }

  dimension: working_rate {
    type: number
    sql: ${TABLE}."WORKING_RATE" ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }

  dimension: primary_key {
    primary_key: yes
    sql: CONCAT(${working_rate},${agent},${longest_talk_time}) ;;
    #NOT STRICTLY UNIQUE, COULD BE DUPLICATES
  }




}
