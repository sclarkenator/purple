view: outbound {
  sql_table_name: HIGHJUMP.OUTBOUND ;;

  dimension_group: hj_created {
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
    sql: ${TABLE}."HJ_CREATED" ;;
  }

  dimension: hj_units_ordered {
    type: number
    sql: ${TABLE}."HJ_UNITS_ORDERED" ;;
  }

  dimension: hj_units_shipped {
    type: number
    sql: ${TABLE}."HJ_UNITS_SHIPPED" ;;
  }

  dimension: internal_id {
    type: number
    sql: ${TABLE}."INTERNAL_ID" ;;
  }

  dimension_group: ns_created {
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
    sql: ${TABLE}."NS_CREATED" ;;
  }

  dimension: ns_ordered_units {
    type: number
    sql: ${TABLE}."NS_ORDERED_UNITS" ;;
  }

  dimension: ns_shipped_units {
    type: number
    sql: ${TABLE}."NS_SHIPPED_UNITS" ;;
  }

  dimension: ns_sku {
    type: string
    sql: ${TABLE}."NS_SKU" ;;
  }

  dimension: ordered_units_diff {
    type: number
    sql: ${TABLE}."ORDERED_UNITS_DIFF" ;;
  }

  dimension: price {
    type: number
    sql: ${TABLE}."PRICE" ;;
  }

  dimension: product {
    type: string
    sql: ${TABLE}."PRODUCT" ;;
  }

  dimension: product_class {
    type: string
    sql: ${TABLE}."PRODUCT_CLASS" ;;
  }

  dimension: sku {
    type: string
    sql: ${TABLE}."SKU" ;;
  }

  dimension: transaction_number {
    type: string
    sql: ${TABLE}."TRANSACTION_NUMBER" ;;
  }

  dimension: transaction_type {
    type: string
    sql: ${TABLE}."TRANSACTION_TYPE" ;;
  }

  dimension: units_shipped_diff {
    type: number
    sql: ${TABLE}."UNITS_SHIPPED_DIFF" ;;
  }

  measure: total_hj_units_ordered {
    type: sum
    sql: ${TABLE}."HJ_UNITS_ORDERED" ;;
  }

  measure: total_hj_units_shipped {
    type: sum
    sql: case when ${TABLE}."TRANSACTION_TYPE" = 'Work Order' then ${TABLE}."HJ_UNITS_SHIPPED" else 0 end ;;
  }

  measure: total_hj_units_built {
    type: sum
    sql: case when ${TABLE}."TRANSACTION_TYPE" != 'Work Order' then ${TABLE}."HJ_UNITS_SHIPPED" else 0 end ;;
  }

  measure: total_ns_ordered_units {
    type: sum
    sql: ${TABLE}."NS_UNITS_ORDERED" ;;
  }

  measure: total_ns_shipped_units {
    type: sum
    sql: case when ${TABLE}."TRANSACTION_TYPE" = 'Work Order' then ${TABLE}."HJ_UNITS_SHIPPED" else 0 end ;;
  }

  measure: total_ns_built_units {
    type: sum
    sql:  case when ${TABLE}."TRANSACTION_TYPE" != 'Work Order' then ${TABLE}."HJ_UNITS_SHIPPED" else 0 end ;;
  }

  measure: total_ordered_units_diff {
    type: sum
    sql: ${TABLE}."ORDERED_UNITS_DIFF" ;;
  }

  measure: total_units_shipped_diff {
    type: sum
    sql: ${TABLE}."UNITS_SHIPPED_DIFF" ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
