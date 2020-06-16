view: veritone_pixel_matchback {
  sql_table_name: "CSV_UPLOADS"."VERITONE_PIXEL_MATCHBACK"
    ;;

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
    hidden: yes
    datatype: date
    sql: ${TABLE}."DATE" ;;
  }

  dimension: order_id {
    type: string
    primary_key: yes
    hidden: yes
    sql: ${TABLE}."ORDER_ID" ;;
  }

  dimension_group: request {
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
    hidden: yes
    datatype: date
    sql: ${TABLE}."REQUEST_DATE" ;;
  }

  dimension: sale_value_dim {
    type: number
    hidden: yes
    sql: ${TABLE}."SALE_VALUE" ;;
  }

  measure: sale_value {
    type: sum
    hidden: yes
    value_format: "$#,##0.00"
    sql: ${TABLE}."SALE_VALUE" ;;
  }

  measure: count {
    type: count
    hidden: yes
    drill_fields: []
  }
}
