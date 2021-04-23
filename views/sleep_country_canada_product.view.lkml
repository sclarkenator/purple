view: sleep_country_canada_product {
  sql_table_name: "WHOLESALE"."SLEEP_COUNTRY_CANADA_PRODUCT"
    ;;

  dimension_group: created {
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
    sql: ${TABLE}."CREATED" ;;
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
    sql: CAST(${TABLE}."INSERT_TS" AS TIMESTAMP_NTZ) ;;
  }

  dimension: item_id {
    type: number
    sql: ${TABLE}."ITEM_ID" ;;
  }

  dimension: purple_sku {
    type: string
    sql: ${TABLE}."PURPLE_SKU" ;;
  }

  dimension: scc_sku {
    type: string
    primary_key: yes
    sql: ${TABLE}."SCC_SKU" ;;
  }

  measure: count_orders {
    type: count_distinct
    sql:  ${scc.order_id} ;;

  }

  measure: AOV {
    type:  number
    value_format: "$#,##0"
    view_label: "Scc"
    sql:  ${scc.net_sales} / NVL(${count_orders}, 1) ;;
  }

  measure: mattress_order_count{
    type:  count_distinct
    sql:  case when ${item.category_raw} = 'MATTRESS' THEN ${scc.order_id} END ;;
  }

  measure: AMOV {
    type: number
    value_format: "$#,##0"
    view_label: "Scc"
    sql:  case when ${v_scc_order_flg.has_mattress} >0 THEN (${v_scc_order_flg.mattress_sales} / ${v_scc_order_flg.has_mattress}) END;;
  }

  measure: NAMOV {
    type: number
    value_format: "$#,##0"
    view_label: "Scc"
    sql:  case when ${v_scc_order_flg.no_mattress} > 0 THEN (${v_scc_order_flg.non_mattress_sales} / ${v_scc_order_flg.no_mattress}) END ;;
  }

  measure: mattress_order_non_mattress_sales {
    type: sum
    sql_distinct_key: ${scc.pk} ;;
    view_label: "Scc"
    sql:case when ${item.category_raw} <> 'MATTRESS' AND ${v_scc_order_flg.has_mattress_dim} THEN ${scc.net_sales_dim} END ;;
  }

  measure: AAAV {
    type: number
    value_format: "$#,##0"
    view_label: "Scc"
    sql: case when ${v_scc_order_flg.has_mattress} > 0 THEN (${mattress_order_non_mattress_sales} / ${v_scc_order_flg.has_mattress}) END  ;;
  }

}
