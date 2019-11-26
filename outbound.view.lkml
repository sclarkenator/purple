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

  dimension: link {
    type: string
    sql: case when ${TABLE}.transaction_type = 'Sales Order' then "https://4651144.app.netsuite.com/app/accounting/transactions/salesord.nl?id=" || ${TABLE}."INTERNAL_ID" || "&whence= "
        when  ${TABLE}.transaction_type = 'Transfer Order' then "https://4651144.app.netsuite.com/app/accounting/transactions/salesord.nl?id=" || ${TABLE}."INTERNAL_ID" || "&whence= "
        when  ${TABLE}.transaction_type = 'Work Order' then "https://4651144.app.netsuite.com/app/accounting/transactions/salesord.nl?id=" || ${TABLE}."INTERNAL_ID" || "&whence= "
        end;;
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

  dimension: ns_sku {
    type: string
    sql: ${TABLE}."NS_SKU" ;;
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

  measure: hj_units_ordered {
    type: sum
    sql: ${TABLE}."HJ_UNITS_ORDERED" ;;
  }

  measure: hj_built_or_shipped {
    type: sum
    label: "HJ Built/Shipped"
    sql: ${TABLE}."HJ_BUILT_OR_SHIPPED" ;;
  }

  measure: ns_units_ordered {
    type: sum
    sql: ${TABLE}."NS_UNITS_ORDERED" ;;
  }

  measure: ns_built_or_shipped {
    type: sum
    label: "NS Built/Shipped"
    sql: ${TABLE}."NS_BUILT_OR_SHIPPED" ;;
  }

  measure: ordered_diff {
    type: number
    sql: ${TABLE}."ORDERED_DIFF" ;;
  }

  measure: built_or_shipped_diff {
    type: number
    sql: ${TABLE}."BUILT_OR_SHIPPED_DIFF" ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
