view: scc_targets {
  sql_table_name: "CSV_UPLOADS"."SCC_TARGETS"
    ;;

  dimension_group: date {
    type: time
    hidden: yes
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

  dimension_group: merged_date {
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
    sql: coalesce(${TABLE}."DATE", ${scc.created_date}) ;;
  }

  dimension: source {
    type: string
    sql: ${TABLE}."SOURCE" ;;
  }

  dimension: target {
    type: number
    sql: ${TABLE}."TARGET" ;;
  }

  dimension: pk {
    type: string
    primary_key: yes
    sql: ${date_date} || ${source} ;;
  }

  measure: total_target {
    type: sum
    value_format: "$#,##0"
    sql: ${TABLE}."TARGET" ;;
  }
}
