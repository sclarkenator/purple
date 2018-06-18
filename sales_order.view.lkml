view: sales_order {
  sql_table_name: SALES.SALES_ORDER ;;

  measure: total_orders {
    view_label: "Order info"
    label: "Total unique orders"
    description:"Unique orders placed"
    type: count_distinct
    sql: ${order_id} ;;
  }

  measure: total_order_amt {
    view_label: "Order info"
    description: "Total order amount, excluding tax"
    type: sum
    sql: ${TABLE}.net_amt ;;
  }

  measure: average_order_size {
    view_label: "Order info"
    description: "Average total order amount, excluding tax"
    type: average
    sql: ${TABLE}.net_amt ;;
  }

  dimension: channel_id {
    view_label: "Order info"
    description:  "1-DTC | 2-Wholesale"
    can_filter: yes
    type:number
    sql: ${TABLE}.CHANNEL_id ;;
  }

  dimension: created {
    view_label: "Order info"
    hidden: yes
    type: date_time
    sql: ${TABLE}.CREATED ;;
  }

  dimension: created_by_id {
    view_label: "Order info"
    hidden: yes
    type: number
    sql: ${TABLE}.CREATED_BY_ID ;;
  }

  dimension: customer_id {
    view_label: "Customer info"
    hidden: yes
    type: number
    sql: ${TABLE}.CUSTOMER_ID ;;
  }

  dimension: email {
    view_label: "Order info"
    hidden: yes
    type: string
    sql: ${TABLE}.EMAIL ;;
  }

  dimension: etail_order_id {
    view_label: "Order info"
    hidden: yes
    type: string
    sql: ${TABLE}.ETAIL_ORDER_ID ;;
  }

  dimension_group: in_hand {
    view_label: "Order info"
    type: time
    hidden: yes
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
    sql: ${TABLE}.IN_HAND ;;
  }

  dimension: insert_ts {
    view_label: "Order info"
    hidden: yes
    type: string
    sql: ${TABLE}.INSERT_TS ;;
  }

  dimension: is_upgrade {
    label: "Upgrade order?"
    description: "Is this order an upgrade on a previous order?"
    view_label: "Order info"
    type: string
    sql: ${TABLE}.IS_UPGRADE ;;
  }

  dimension: memo {
    view_label: "Order info"
    hidden: yes
    type: string
    sql: ${TABLE}.MEMO ;;
  }

  dimension: modified {
    view_label: "Order info"
    hidden: yes
    type: string
    sql: ${TABLE}.MODIFIED ;;
  }

  dimension: net_amt {
    view_label: "Order info"
    label:  "Total Order Size"
    description: "Gross sales, excluding taxes."
    type: number
    sql: ${TABLE}.NET_AMT ;;
  }

  dimension: Order_size_buckets{
    view_label: "Order info"
    type:  tier
    style: integer
    tiers: [300,500,1000,2000,3000,5000]
    sql: ${TABLE}.NET_AMT ;;
  }

  dimension: order_id {
    view_label: "Order info"
    hidden: yes
    type: number
    sql: ${TABLE}.ORDER_ID ;;
  }

  dimension: payment_method {
    view_label: "Order info"
    hidden: yes
    type: string
    sql: ${TABLE}.PAYMENT_METHOD ;;
  }

  dimension: recycle_fee_amt {
    view_label: "Order info"
    hidden:yes
    type: number
    sql: ${TABLE}.RECYCLE_FEE_AMT ;;
  }

  dimension: related_tranid {
    view_label: "Order info"
    hidden: yes
    type: string
    sql: ${TABLE}.RELATED_TRANID ;;
  }

  dimension_group: sales_effective {
    view_label: "Order info"
    hidden: yes
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
    sql: ${TABLE}.SALES_EFFECTIVE ;;
  }

  dimension_group: shipment_received {
    view_label: "Order info"
    hidden: yes
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
    sql: ${TABLE}.SHIPMENT_RECEIVED ;;
  }

  dimension: shipping_amt {
    view_label: "Order info"
    hidden: yes
    type: number
    sql: ${TABLE}.SHIPPING_AMT ;;
  }

  dimension: shopify_discount_code {
    view_label: "Order info"
    hidden: yes
    type: string
    sql: ${TABLE}.SHOPIFY_DISCOUNT_CODE ;;
  }

  dimension: shopify_risk_analysis {
    view_label: "Order info"
    hidden: yes
    type: string
    sql: ${TABLE}.SHOPIFY_RISK_ANALYSIS ;;
  }

  dimension: shopify_risk_rating {
    view_label: "Order info"
    hidden: yes
    type: string
    sql: ${TABLE}.SHOPIFY_RISK_RATING ;;
  }

  dimension: source {
    view_label: "Order info"
    label:  "Order source"
    description: "System where order was placed"
    #hidden: yes
    type: string
    sql: ${TABLE}.SOURCE ;;
  }

  dimension: status {
    label: "Status of order"
    view_label: "Order info"
    type: string
    sql: ${TABLE}.STATUS ;;
  }

  dimension: system {
    view_label: "Order info"
    hidden: yes
    type: string
    sql: ${TABLE}.SYSTEM ;;
  }

  dimension: tax_amt {
    hidden: yes
    view_label: "Order info"
    type: number
    sql: ${TABLE}.TAX_AMT ;;
  }

  dimension_group: trandate {
    view_label: "Order info"
    hidden: yes
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
    sql: ${TABLE}.TRANDATE ;;
  }

  dimension: tranid {
    view_label: "Order info"
    hidden: yes
    type: string
    sql: ${TABLE}.TRANID ;;
  }

  dimension: transaction_number {
    view_label: "Order info"
    hidden: yes
    type: string
    sql: ${TABLE}.TRANSACTION_NUMBER ;;
  }

  dimension: update_ts {
    view_label: "Order info"
    hidden: yes
    type: string
    sql: ${TABLE}.UPDATE_TS ;;
  }

  dimension: warranty {
    view_label: "Order info"
    hidden: yes
    type: string
    sql: ${TABLE}.WARRANTY ;;
  }

  dimension: warranty_claim_id {
    view_label: "Order info"
    hidden: yes
    type: number
    sql: ${TABLE}.WARRANTY_CLAIM_ID ;;
  }

}
