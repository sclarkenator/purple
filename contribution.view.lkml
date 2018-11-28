view: contribution {
  sql_table_name: SALES.CONTRIBUTION ;;

  dimension: contribution_pk {
    type: string
    primary_key:  yes
    hidden:  yes
    sql: ${TABLE}.item_id||'-'||${TABLE}.order_id||'-'||${TABLE}.system ;; }

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
    group_label: "Net-to-CM"
    view_label: "Contribution Margin"
    label: "7 - Affiliate Fees"
    description: "Affiliate fees directly tied to an order"
    value_format: "#,##0"
    type: sum
    sql: ${TABLE}."AFFILIATE_FEES" ;;
  }

  measure: cancelled_amt {
    group_label: "Gross-to-Net"
    view_label: "Contribution Margin"
    label: "1 - Cancelled ($)"
    description: "Gross $ value of cancelled items/orders"
    value_format: "#,##0"
    type: sum
    sql: ${TABLE}."CANCELLED_AMT" ;;
  }

  measure: cogs {
    group_label: "Net-to-CM"
    view_label: "Contribution Margin"
    label: "1 - COGS"
    description: "Item-specific COGS based on Apr/May estimated costs in NS"
    value_format: "#,##0"
    type: sum
    sql: ${TABLE}."COGS" ;;
  }

  measure: contribution {
    view_label: "Contribution Margin"
    label: "Contribution ($)"
    description: "Contribution margin, what is left after netting out all item-level costs"
    value_format: "#,##0"
    type: sum
    sql: ${TABLE}."CONTRIBUTION" ;;
  }
  measure: freight {
    group_label: "Net-to-CM"
    view_label: "Contribution Margin"
    label: "6 - Shipping"
    description: "All shipping expenses tied to fulfilling an item"
    value_format: "#,##0"
    type: sum
    sql: ${TABLE}."FREIGHT" ;;
  }

  measure: freight_in {
    group_label: "Net-to-CM"
    view_label: "Contribution Margin"
    label: "3 - Freight In"
    description: "In-bound freight, assumed at 8.9% of COGS"
    value_format: "#,##0"
    type: sum
    sql: ${TABLE}."FREIGHT_IN" ;;
  }

  measure: gross_amt {
    view_label: "Contribution Margin"
    label: "Gross Sales ($)"
    description: "Gross sales"
    value_format: "#,##0"
    type: sum
    sql: ${TABLE}."GROSS_SALES" ;;
  }

  measure: net_amt {
    view_label: "Contribution Margin"
    label: "Net Sales ($)"
    description: "Net sales (gross - cancellations - returns - retro discounts"
    value_format: "#,##0"
    type: sum
    sql: ${TABLE}."NET_SALES" ;;
  }

  measure: labor {
    group_label: "Net-to-CM"
    view_label: "Contribution Margin"
    label: "2 - Labor"
    description: "Per unit labor costs, based on October time studies"
    value_format: "#,##0"
    type: sum
    sql: ${TABLE}."LABOR" ;;
  }

  measure: merchant_fees {
    group_label: "Net-to-CM"
    view_label: "Contribution Margin"
    label: "4 - Merchant Fees"
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
    label: "Gross units"
    description: "Gross units ordered"
    hidden:  no
    value_format: "#,##0"
    type: sum
    sql: ${TABLE}."ORDERED_QTY" ;;
  }

  measure: retro_discount_amt {
    group_label: "Gross-to-Net"
    view_label: "Contribution Margin"
    label: "3 - Retro Discount"
    description: "Discounts applied after the order is initially placed. These are handled by Customer Care."
    value_format: "#,##0"
    type: sum
    sql: ${TABLE}."RETRO_DISCOUNT_AMT" ;;
  }

  measure: return_amt {
    group_label: "Gross-to-Net"
    view_label: "Contribution Margin"
    label: "2 - Returns"
    description: "Refunded trial/non-trial returns for DTC"
    value_format: "#,##0"
    type: sum
    sql: ${TABLE}."RETURN_AMT" ;;
  }

  measure: warranty {
    group_label: "Net-to-CM"
    view_label: "Contribution Margin"
    label: "5 - Warranty"
    description: "Budgeted warranty allowance, based on 3.1% of COGS"
    value_format: "#,##0"
    type: sum
    sql: ${TABLE}."WARRANTY" ;;
  }
}
