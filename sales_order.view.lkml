view: sales_order {
  sql_table_name: SALES.SALES_ORDER ;;

  measure: net_order_amt {
    description: "Net order amount, excluding tax"
    type: sum
    sql: ${TABLE}.net_amt ;;
  }

  measure: average_order_size {
    description: "Average net order amount, excluding tax"
    type: average
    sql: ${TABLE}.net_amt ;;
  }

  dimension: channel_id {
    can_filter: yes
    type:number
    sql: ${TABLE}.CHANNEL_id ;;
  }

  dimension: created {
    hidden: yes
    type: date_time
    sql: ${TABLE}.CREATED ;;
  }

  dimension: created_by_id {
    view_label: "ID Fields"
    hidden: yes
    type: number
    sql: ${TABLE}.CREATED_BY_ID ;;
  }

  dimension: customer_id {
    view_label: "ID Fields"
    hidden: yes
    type: number
    sql: ${TABLE}.CUSTOMER_ID ;;
  }

  dimension: email {
    hidden: yes
    type: string
    sql: ${TABLE}.EMAIL ;;
  }

  dimension: etail_order_id {
    view_label: "ID Fields"
    #hidden: yes
    type: string
    sql: ${TABLE}.ETAIL_ORDER_ID ;;
  }

  dimension_group: in_hand {
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
    datatype: date
    sql: ${TABLE}.IN_HAND ;;
  }

  dimension: insert_ts {
    hidden: yes
    type: string
    sql: ${TABLE}.INSERT_TS ;;
  }

  dimension: is_upgrade {
    type: string
    sql: ${TABLE}.IS_UPGRADE ;;
  }

  dimension: memo {
    hidden: yes
    type: string
    sql: ${TABLE}.MEMO ;;
  }

  dimension: modified {
    hidden: yes
    type: string
    sql: ${TABLE}.MODIFIED ;;
  }

  dimension: net_amt {
    label:  "Order Size"
    description: "Net order size, excluding taxes."
    type: number
    sql: ${TABLE}.NET_AMT ;;
  }

  dimension: Order_size_buckets{
    type:  tier
    style: integer
    tiers: [300,500,1000,2000,3000,5000]
    sql: ${TABLE}.NET_AMT ;;
  }

  dimension: order_id {
    hidden: yes
    view_label: "ID Fields"
    type: number
    sql: ${TABLE}.ORDER_ID ;;
  }

  dimension: payment_method {
    hidden: yes
    type: string
    sql: ${TABLE}.PAYMENT_METHOD ;;
  }

  dimension: recycle_fee_amt {
    hidden:yes
    type: number
    sql: ${TABLE}.RECYCLE_FEE_AMT ;;
  }

  dimension: related_tranid {
    view_label: "ID Fields"
    hidden: yes
    type: string
    sql: ${TABLE}.RELATED_TRANID ;;
  }

  dimension_group: sales_effective {
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
    sql: ${TABLE}.SHIPMENT_RECEIVED ;;
  }

  dimension: shipping_amt {
    hidden: yes
    type: number
    sql: ${TABLE}.SHIPPING_AMT ;;
  }

  dimension: shopify_discount_code {
    hidden: yes
    type: string
    sql: ${TABLE}.SHOPIFY_DISCOUNT_CODE ;;
  }

  dimension: shopify_risk_analysis {
    hidden: yes
    type: string
    sql: ${TABLE}.SHOPIFY_RISK_ANALYSIS ;;
  }

  dimension: shopify_risk_rating {
    hidden: yes
    type: string
    sql: ${TABLE}.SHOPIFY_RISK_RATING ;;
  }

  dimension: source {
    type: string
    sql: ${TABLE}.SOURCE ;;
  }

  dimension: status {
    hidden: yes
    type: string
    sql: ${TABLE}.STATUS ;;
  }

  dimension: system {
    hidden: yes
    type: string
    sql: ${TABLE}.SYSTEM ;;
  }

  dimension: tax_amt {
    type: number
    sql: ${TABLE}.TAX_AMT ;;
  }

  dimension_group: trandate {
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
    view_label: "ID Fields"
    hidden: yes
    type: string
    sql: ${TABLE}.TRANID ;;
  }

  dimension: transaction_number {
    view_label: "ID Fields"
    hidden: yes
    type: string
    sql: ${TABLE}.TRANSACTION_NUMBER ;;
  }

  dimension: update_ts {
    hidden: yes
    type: string
    sql: ${TABLE}.UPDATE_TS ;;
  }

  dimension: warranty {
    hidden: yes
    type: string
    sql: ${TABLE}.WARRANTY ;;
  }

  dimension: warranty_claim_id {
    view_label: "ID Fields"
    hidden: yes
    type: number
    sql: ${TABLE}.WARRANTY_CLAIM_ID ;;
  }

}
