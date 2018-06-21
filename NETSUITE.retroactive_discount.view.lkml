view: retroactive_discount {
  sql_table_name: SALES.RETROACTIVE_DISCOUNT ;;

  measure: total_retro_discounts {
    type:  sum
    sql:  ${TABLE}.amount;;
  }

  dimension: item_order{
    primary_key:  yes
    hidden:  yes
    sql: ${TABLE}.sku_id||'-'||${TABLE}.order_id ;;
  }

  dimension: amount {
    label:  "Discount amount"
    type: number
    sql: ${TABLE}.AMOUNT ;;
  }

  dimension: discount_amt_bucket {
    label: "Discount buckets"
    type:  tier
    tiers: [50,100,150,200,350,500,1000]
    style: integer
    sql: ${TABLE}.AMOUNT ;;
  }

  dimension_group: created {
    label:  "Discount applied"
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
    datatype: timestamp
    sql: ${TABLE}.CREATED ;;
  }

  dimension: discount_code_id {
    description: "Type of discount applied"
    type: number
    # hidden: yes
    sql: ${TABLE}.DISCOUNT_CODE_ID ;;
  }

  dimension: etail_order_line_id {
    hidden: yes
    type: number
    sql: ${TABLE}.ETAIL_ORDER_LINE_ID ;;
  }

  dimension: insert_mst {
    hidden: yes
    type: string
    sql: ${TABLE}.INSERT_MST ;;
  }

  dimension: order_id {
    hidden: yes
    type: number
    sql: ${TABLE}.ORDER_ID ;;
  }

  dimension: product_line_id {
    hidden: yes
    type: number
    # hidden: yes
    sql: ${TABLE}.PRODUCT_LINE_ID ;;
  }

  dimension: refund_link_id {
    hidden: yes
    type: number
    sql: ${TABLE}.REFUND_LINK_ID ;;
  }

  dimension: refunded_amount {
    description: "Amount refunded, including tax"
    hidden: yes
    type: number
    sql: ${TABLE}.REFUNDED_AMOUNT ;;
  }

  dimension: retroactive_discount_line_id {
    hidden: yes
    type: number
    sql: ${TABLE}.RETROACTIVE_DISCOUNT_LINE_ID ;;
  }

  dimension: sku_id {
    hidden: yes
    type: number
    sql: ${TABLE}.SKU_ID ;;
  }

  dimension: system {
    hidden: yes
    type: string
    sql: ${TABLE}.SYSTEM ;;
  }

  dimension: update_mst {
    hidden: yes
    type: string
    sql: ${TABLE}.UPDATE_MST ;;
  }

  measure: count {
    label: "Distinct discounts applied"
    type: count
    drill_fields: [product_line.product_line_id, discount_code.discount_code_id]
  }
}
