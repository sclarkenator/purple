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
    type: number
    sql: ${TABLE}.AMOUNT ;;
  }

  dimension: created {
    type: string
    sql: ${TABLE}.CREATED ;;
  }

  dimension: discount_code_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.DISCOUNT_CODE_ID ;;
  }

  dimension: etail_order_line_id {
    type: number
    sql: ${TABLE}.ETAIL_ORDER_LINE_ID ;;
  }

  dimension: insert_mst {
    type: string
    sql: ${TABLE}.INSERT_MST ;;
  }

  dimension: order_id {
    type: number
    sql: ${TABLE}.ORDER_ID ;;
  }

  dimension: product_line_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.PRODUCT_LINE_ID ;;
  }

  dimension: refund_link_id {
    type: number
    sql: ${TABLE}.REFUND_LINK_ID ;;
  }

  dimension: refunded_amount {
    type: number
    sql: ${TABLE}.REFUNDED_AMOUNT ;;
  }

  dimension: retroactive_discount_line_id {
    type: number
    sql: ${TABLE}.RETROACTIVE_DISCOUNT_LINE_ID ;;
  }

  dimension: sku_id {
    type: number
    sql: ${TABLE}.SKU_ID ;;
  }

  dimension: system {
    type: string
    sql: ${TABLE}.SYSTEM ;;
  }

  dimension: update_mst {
    type: string
    sql: ${TABLE}.UPDATE_MST ;;
  }

  measure: count {
    type: count
    drill_fields: [product_line.product_line_id, discount_code.discount_code_id]
  }
}
