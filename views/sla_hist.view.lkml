view: sla_hist {
  sql_table_name: "SHIPPING"."SLA_HIST"
    ;;

  dimension: days {
    type: number
    sql: ${TABLE}."DAYS" ;;
  }

  dimension_group: effective {
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
    sql: ${TABLE}."EFFECTIVE_DATE" ;;
  }

  dimension: sku_id {
    type: string
    sql: ${TABLE}."SKU_ID" ;;
  }

}
