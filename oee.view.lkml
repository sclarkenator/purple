view: oee {
  sql_table_name: PRODUCTION.OEE ;;

  dimension: cycle_time {
    hidden: yes
    type: number
    sql: ${TABLE}."CYCLE_TIME" ;;
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

  dimension: ideal_production {
    hidden: yes
    type: number
    sql: ${TABLE}."IDEAL_PRODUCTION" ;;
  }

  dimension: machine {
    type: string
    sql: ${TABLE}."MACHINE" ;;
  }

  dimension: operating_time {
    hidden: yes
    type: number
    sql: ${TABLE}."OPERATING_TIME" ;;
  }

  dimension: product_type {
    type: string
    sql: ${TABLE}."PRODUCT_TYPE" ;;
  }

  dimension: reject_scrap {
    hidden:  yes
    type: number
    sql: ${TABLE}."REJECT_SCRAP" ;;
  }

  dimension: scheduled {
    hidden:  yes
    type: number
    sql: ${TABLE}."SCHEDULED" ;;
  }

  dimension: total_available {
    hidden:  yes
    type: number
    sql: ${TABLE}."TOTAL_AVAILABLE" ;;
  }

  dimension: total_production {
    hidden:  yes
    type: number
    sql: ${TABLE}."TOTAL_PRODUCTION" ;;
  }

  dimension: unscheduled_downtime {
    hidden:  yes
    type: number
    sql: ${TABLE}."UNSCHEDULED_DOWNTIME" ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }

  measure: Total_Availble_Time{
    type: sum
    sql: ${TABLE}."TOTAL_AVAILABLE";;
  }

 measure: Total_Scheduled_Time {
  type: sum
  sql: ${TABLE}."SCHEDULED";;
  }

  measure: Total_Operating_Time {
    type: sum
    sql: ${TABLE}."OPERATING_TIME" ;;
  }

  measure: Total_Production_Sum {
    type: sum
    sql: ${TABLE}."TOTAL_PRODUCTION" ;;
  }

  measure: Average_Cycle_Time {
    type: average
    sql: ${TABLE}."CYCLE_TIME" ;;
  }

  measure: Total_Reject_Scrap{
    type: sum
    sql: ${TABLE}."REJECT_SCRAP" ;;
  }

  measure: Total_unscheduled_downtime {
    type: sum
    sql: ${TABLE}."UNSCHEDULED_DOWNTIME" ;;
  }

}
