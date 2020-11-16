view: expedited_shipping {
  sql_table_name: "SALES"."EXPEDITED_SHIPPING"
    ;;

  dimension: available {
    type: number
    sql: ${TABLE}."AVAILABLE" ;;
  }

  dimension: avg_sales {
    type: number
    sql: ${TABLE}."AVG_SALES" ;;
  }

  dimension: description {
    type: string
    sql: ${TABLE}."DESCRIPTION" ;;
  }

  dimension: expedited_shipping {
    type: yesno
    sql: ${TABLE}."EXPEDITED_SHIPPING" ;;
  }

  dimension: sku_id {
    type: string
    sql: ${TABLE}."SKU_ID" ;;
  }

  dimension_group: snapshot_ts {
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
    sql: CAST(${TABLE}."SNAPSHOT_TS" AS TIMESTAMP_NTZ) ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
