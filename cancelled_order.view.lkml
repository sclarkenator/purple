view: cancelled_order {
  sql_table_name: SALES.CANCELLED_ORDER ;;

  measure: units_cancelled {
    description: "Total individual units cancelled"
    type:  sum
    sql:  ${TABLE}.cancelled_qty  ;;
  }

  measure: amt_cancelled {
    description: "Total USD amount of cancelled order"
    type: sum
    sql: ${TABLE}.net_amt ;;
  }

  dimension: item_order{
    primary_key:  yes
    hidden:  yes
    sql: ${TABLE}.item_id||'-'||${TABLE}.order_id ;;
  }

 dimension_group: cancelled {
    label: "Cancelled"
    description: "Date order was cancelled. Cancelled time is available for full-order cancellations."
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
    sql: ${TABLE}.CANCELLED ;;
  }

  dimension: cancelled_order_type {
    label:  "Cancellation type"
    description:  "Full order or partial order"
    type: string
    sql: ${TABLE}.CANCELLED_ORDER_TYPE ;;
  }

  dimension: cancelled_qty {
    type: number
    sql: ${TABLE}.CANCELLED_QTY ;;
  }

  dimension: channel_id {
    hidden:  yes
    type: number
    sql: ${TABLE}.CHANNEL_ID ;;
  }

  dimension: full_cancelled_ts {
    hidden:  yes
    type: string
    sql: ${TABLE}.FULL_CANCELLED_TS ;;
  }

  dimension: insert_ts {
    hidden:  yes
    type: string
    sql: ${TABLE}.INSERT_TS ;;
  }

  dimension: item_id {
    type: number
    hidden: yes
    sql: ${TABLE}.ITEM_ID ;;
  }

  dimension: net_amt {
    label:  "Net returned amount"
    type: number
    sql: ${TABLE}.NET_AMT ;;
  }

  dimension: order_id {
    hidden:  yes
    type: number
    sql: ${TABLE}.ORDER_ID ;;
  }

  dimension: refunded {
    type: string
    sql: ${TABLE}.REFUNDED ;;
  }

  dimension: revenue_item {
    label:"Revenue item flag"
    description:  "Select yes for all product-specific refunds. No to just capture non-product (recycle-fee, freight, etc)"
    type: string
    sql: ${TABLE}.REVENUE_ITEM ;;
  }

  dimension: shopify_cancel_reason_id {
    label: "Cancellation reason"
    type: number
    sql: ${TABLE}.SHOPIFY_CANCEL_REASON_ID ;;
  }

  dimension: shopify_discount_code {
    hidden:  yes
    type: string
    sql: ${TABLE}.SHOPIFY_DISCOUNT_CODE ;;
  }

  dimension: system {
    hidden:  yes
    type: string
    sql: ${TABLE}.SYSTEM ;;
  }

  dimension: update_ts {
    hidden:  yes
    type: string
    sql: ${TABLE}.UPDATE_TS ;;
  }

  measure: count {
    type: count
    drill_fields: [item.item_id, item.model_name, item.category_name, item.sub_category_name, item.product_line_name]
  }
}
