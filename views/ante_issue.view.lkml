view: ante_issue {
  sql_table_name: "OPS"."ANTE_ISSUE"
    ;;

  dimension: PK {
    primary_key: yes
    hidden: yes
    sql: ${created_date}||'-'||${issue_key} ;;
  }

  dimension: issue_id {
    type: string
    sql: ${TABLE}."ISSUE_ID" ;;
  }

  dimension: issue_key {
    type: string
    sql: ${TABLE}."ISSUE_KEY" ;;
  }

  dimension: title {
    type: string
    sql: ${TABLE}."TITLE" ;;
  }

  dimension_group: created {
    type: time
    label: "   Created"
    timeframes: [raw,time,date,week,month,quarter,year]
    sql: CAST(${TABLE}."CREATED" AS TIMESTAMP_NTZ) ;;
  }

  dimension: description {
    type: string
    sql: ${TABLE}."DESCRIPTION" ;;
  }

  dimension_group: start_dt {
    type: time
    timeframes: [raw,date,week,month,quarter,year]
    convert_tz: no
    label: "  Start"
    datatype: date
    sql: ${TABLE}."START_DT" ;;
  }

  dimension_group: end_dt {
    type: time
    timeframes: [raw,date,week,month,quarter,year]
    convert_tz: no
    label: " End"
    datatype: date
    sql: ${TABLE}."END_DT" ;;
  }

  dimension: status {
    type: string
    sql: ${TABLE}."STATUS" ;;
  }

  dimension: type {
    type: string
    sql: ${TABLE}."TYPE" ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
