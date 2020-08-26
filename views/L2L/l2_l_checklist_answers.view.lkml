view: l2_l_checklist_answers {
  sql_table_name: L2L.CHECKLIST_ANSWER ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: string
    sql: ${TABLE}."ID" ;;
  }

  dimension: answer {
    type: string
    sql: ${TABLE}."ANSWER" ;;
  }

  dimension: checklist {
    type: string
    sql: ${TABLE}."CHECKLIST" ;;
  }

  dimension: control_limit_high {
    type: number
    sql: ${TABLE}."CONTROL_LIMIT_HIGH" ;;
  }

  dimension: control_limit_low {
    type: number
    sql: ${TABLE}."CONTROL_LIMIT_LOW" ;;
  }

  dimension_group: created {
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
    sql: ${TABLE}."CREATED" ;;
  }

  dimension: createdby {
    type: string
    sql: ${TABLE}."CREATEDBY" ;;
  }

  dimension: dispatch {
    type: string
    sql: ${TABLE}."DISPATCH" ;;
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

  dimension_group: lastupdated {
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
    sql: ${TABLE}."LASTUPDATED" ;;
  }

  dimension: lastupdatedby {
    type: string
    sql: ${TABLE}."LASTUPDATEDBY" ;;
  }

  dimension: na {
    type: yesno
    sql: ${TABLE}."NA" ;;
  }

  dimension: reject_limit_high {
    type: number
    sql: ${TABLE}."REJECT_LIMIT_HIGH" ;;
  }

  dimension: reject_limit_low {
    type: number
    sql: ${TABLE}."REJECT_LIMIT_LOW" ;;
  }

  dimension: site {
    type: string
    sql: ${TABLE}."SITE" ;;
  }

  dimension: task_hash {
    type: string
    sql: ${TABLE}."TASK_HASH" ;;
  }

  dimension: task_number {
    type: string
    sql: ${TABLE}."TASK_NUMBER" ;;
  }

  dimension_group: update_ts {
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
    type: count
    drill_fields: [id]
  }
}
