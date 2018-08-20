view: hotjar_data {
  sql_table_name: MARKETING.HOTJAR_DATA ;;

  dimension_group: created {
    type: time
    timeframes: [
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}."CREATED" ;;
  }

  dimension: first_heard {
    type: string
    sql: ${TABLE}."FIRST_HEARD" ;;
  }

  dimension: how_heard {
    type: string
    sql: ${TABLE}."HOW_HEARD" ;;
  }

  dimension: token {
    type: string
    sql: ${TABLE}."TOKEN" ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }

  measure: respondants {
    type: count_distinct
    sql: ${TABLE}.token ;;
  }
}
