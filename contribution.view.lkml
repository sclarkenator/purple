view: contribution {
  sql_table_name: SALES.CONTRIBUTION ;;

  dimension: contribution_pk {
    type: string
    primary_key:  yes
    hidden:  yes
    sql: NVL(${TABLE}.item_id,0)||'-'||NVL(${TABLE}.order_id,0)||'-'||${TABLE}.system ;; }

  dimension: order_id {
    type: string
    hidden:  yes
    sql: ${TABLE}."ORDER_ID" ;;
  }

  dimension: item_id {
    type: string
    hidden:  yes
    sql: ${TABLE}."ITEM_ID" ;;
  }

  dimension: system {
    hidden:  yes
    type: string
    sql: ${TABLE}."SYSTEM" ;;
  }

  measure: affiliate_fees {
    hidden: yes
    group_label: "Net-to-CM"
    view_label: "Contribution Margin"
    label: "7 - Affiliate Fees (old)"
    description: "Affiliate fees directly tied to an order"
    value_format: "#,##0"
    type: sum
    sql: ${TABLE}."AFFILIATE_FEES" ;;
  }

  measure: cancelled_amt {
    hidden: yes
    group_label: "Gross-to-Net"
    view_label: "Contribution Margin"
    label: "1 - Cancelled ($) (old)"
    description: "Gross $ value of cancelled items/orders"
    value_format: "#,##0"
    type: sum
    sql: ${TABLE}."CANCELLED_AMT" ;;
  }

  measure: cogs {
    hidden: yes
    group_label: "Net-to-CM"
    view_label: "Contribution Margin"
    label: "1 - COGS (old)"
    description: "Item-specific COGS based on Apr/May estimated costs in NS"
    value_format: "#,##0"
    type: sum
    sql: ${TABLE}."COGS" ;;
  }

  measure: contribution {
    hidden: yes
    view_label: "Contribution Margin"
    label: "Contribution ($) (old)"
    description: "Contribution margin, what is left after netting out all item-level costs"
    value_format: "#,##0"
    type: sum
    sql: ${TABLE}."CONTRIBUTION_MARGIN" ;;
  }
  measure: freight {
    hidden: yes
    group_label: "Net-to-CM"
    view_label: "Contribution Margin"
    label: "6 - Shipping (old)"
    description: "All shipping expenses tied to fulfilling an item"
    value_format: "#,##0"
    type: sum
    sql: ${TABLE}."FREIGHT" ;;
  }

  measure: freight_in {
    hidden: yes
    group_label: "Net-to-CM"
    view_label: "Contribution Margin"
    label: "3 - Freight In (old)"
    description: "In-bound freight, assumed at 8.9% of COGS"
    value_format: "#,##0"
    type: sum
    sql: ${TABLE}."FREIGHT_IN" ;;
  }

  measure: gross_amt {
    hidden: yes
    view_label: "Contribution Margin"
    label: "Gross Sales ($) (old)"
    description: "Gross sales"
    value_format: "#,##0"
    type: sum
    sql: ${TABLE}."GROSS_SALES" ;;
  }

  measure: net_amt {
    hidden: yes
    view_label: "Contribution Margin"
    label: "Net Sales ($) (old)"
    description: "Net sales (gross - cancellations - returns - retro discounts"
    value_format: "#,##0"
    type: sum
    sql: ${TABLE}."NET_SALES" ;;
  }

  measure: labor {
    hidden: yes
    group_label: "Net-to-CM"
    view_label: "Contribution Margin"
    label: "2 - Labor (old)"
    description: "Per unit labor costs, based on October time studies"
    value_format: "#,##0"
    type: sum
    sql: ${TABLE}."LABOR" ;;
  }

  measure: merchant_fees {
    hidden: yes
    group_label: "Net-to-CM"
    view_label: "Contribution Margin"
    label: "4 - Merchant Fees (old)"
    description: "Merchant fees tied to order. 15% for Amazon, 6% for Affirm, 3% for all other DTC. 0% for Wholesale"
    value_format: "#,##0"
    type: sum
    sql: ${TABLE}."MERCHANT_FEES" ;;
  }

  measure: net_units {
    hidden:  yes
    value_format: "#,##0"
    type: sum
    sql: ${TABLE}."NET_UNITS" ;;
  }

  measure: ordered_qty {
    view_label: "Contribution Margin"
    label: "Gross units (old)"
    description: "Gross units ordered"
    hidden: yes
    value_format: "#,##0"
    type: sum
    sql: ${TABLE}."ORDERED_QTY" ;;
  }

  measure: retro_discount_amt {
    hidden: yes
    group_label: "Gross-to-Net"
    view_label: "Contribution Margin"
    label: "3 - Retro Discount (old)"
    description: "Discounts applied after the order is initially placed. These are handled by Customer Care."
    value_format: "#,##0"
    type: sum
    sql: ${TABLE}."RETRO_DISCOUNT_AMT" ;;
  }

  measure: return_amt {
    hidden: yes
    group_label: "Gross-to-Net"
    view_label: "Contribution Margin"
    label: "2 - Returns (old)"
    description: "Refunded trial/non-trial returns for DTC"
    value_format: "#,##0"
    type: sum
    sql: ${TABLE}."RETURN_AMT" ;;
  }

  measure: warranty {
    hidden: yes
    group_label: "Net-to-CM"
    view_label: "Contribution Margin"
    label: "5 - Warranty (old)"
    description: "Budgeted warranty allowance, based on 3.1% of COGS"
    value_format: "#,##0"
    type: sum
    sql: ${TABLE}."WARRANTY" ;;
  }
}
