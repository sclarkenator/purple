view: sales_order {
  sql_table_name: SALES.SALES_ORDER ;;

  measure: total_orders {
    view_label: "Sales"
    label: "Total unique orders"
    description:"Unique orders placed"
    type: count_distinct
    sql: ${order_id} ;;
  }

  measure: average_order_size {
    view_label: "Sales"
    description: "Average total order amount, excluding tax"
    type: average
    value_format: "$#,##0.00"
    sql: ${TABLE}.gross_amt ;;
  }

  dimension: order_system {
    view_label: "Sales"
    primary_key:  yes
    hidden:  yes
    sql: ${TABLE}.order_id||'-'||${TABLE}.system ;;
  }

  dimension: channel_source {
    view_label: "Sales"
    label: "Order source"
    description: "Where was the order placed?"
    case: {
      when: {
        sql: ${TABLE}.system = 'SHOPIFY-US' or ${TABLE}.source = 'Shopify - US' or ${TABLE}.source is null or ${TABLE}.source = 'Direct Entry' ;;
        label: "SHOPIFY-US"
      }

      when: {
        sql: ${TABLE}.system = 'SHOPIFY-CA' or ${TABLE}.source = 'Shopify - CA' ;;
        label: "SHOPIFY-CA"
      }

      when: {
        sql: ${TABLE}.system = 'AMAZON.COM' or ${TABLE}.source = 'Amazon FBA - US' or ${TABLE}.system = 'AMAZON-US' ;;
        label: "AMAZON-US"
      }

      when: {
        sql: ${TABLE}.system = 'AMAZON-CA'  or ${TABLE}.source = 'Amazon FBA - CA';;
        label: "AMAZON-CA"
      }

      else: "OTHER"
    }
  }

  dimension: channel_id {
    view_label: "Sales"
    description:  "1-DTC | 2-Wholesale"
    can_filter: yes
    type:number
    sql: ${TABLE}.CHANNEL_id ;;
  }

  dimension: created {
    view_label: "Sales"
    hidden: yes
    type: date_time
    sql: ${TABLE}.CREATED ;;
  }

  dimension: created_by_id {
    view_label: "Sales"
    hidden: yes
    type: number
    sql: ${TABLE}.CREATED_BY_ID ;;
  }

  dimension: customer_id {
    view_label: "Customer"
    hidden: yes
    type: number
    sql: ${TABLE}.CUSTOMER_ID ;;
  }

  dimension: email {
    view_label: "Sales"
    hidden: yes
    type: string
    sql: ${TABLE}.EMAIL ;;
  }

  dimension: etail_order_id {
    view_label: "Sales"
    hidden: yes
    type: string
    sql: ${TABLE}.ETAIL_ORDER_ID ;;
  }

  dimension_group: in_hand {
    view_label: "Sales"
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

  dimension_group: minimum_ship {
    view_label: "Sales"
    label: "Minimum ship-by date"
    description: "This is the earliest date the wholesale order could be fulfilled"
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
    sql: to_timestamp_ntz(${TABLE}.minimum_ship) ;;
  }

  dimension_group: ship_by {
    view_label: "Fulfillment"
    description: "This is the date the wholesale order must be fulfilled by to arrive as expected"
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
    sql: ${TABLE}.SHIP_BY ;;
  }

  dimension: insert_ts {
    view_label: "Sales"
    hidden: yes
    type: string
    sql: ${TABLE}.INSERT_TS ;;
  }

  dimension: is_upgrade {
    label: "Upgrade order?"
    description: "Is this order an upgrade on a previous order?"
    #view_label: "Sales info"
    type: string
    sql: ${TABLE}.IS_UPGRADE ;;
  }

  dimension: memo {
    view_label: "Sales"
    hidden: yes
    type: string
    sql: ${TABLE}.MEMO ;;
  }

  dimension: modified {
    view_label: "Sales"
    hidden: yes
    type: string
    sql: ${TABLE}.MODIFIED ;;
  }

  dimension: gross_amt {
    view_label: "Sales"
    label:  "Gross order size ($)"
    description: "Total gross sales for all items on order, excluding taxes."
    type: number
    sql: ${TABLE}.gross_amt ;;
  }

  dimension: Order_size_buckets{
    view_label: "Sales"
    description: "Different price buckets for total gross order amount (customizable)"
    type:  tier
    style: integer
    tiers: [150,600,1000,1500,2500]
    sql: ${TABLE}.gross_amt ;;
  }

  dimension: order_id {
    hidden: no
    view_label: "Sales"
    html: <a href = "https://system.na2.netsuite.com/app/accounting/transactions/salesord.nl?id={{value}}&whence=" target="_blank"> {{value}} </a> ;;
    description: "This is Netsuite's transaction ID. This will be a hyperlink to the sales order in Netsuite."
    type: number
    sql: ${TABLE}.ORDER_ID ;;
  }

  dimension: payment_method {
    view_label: "Sales"
    label: "Order payment method"
    description: "**FOR Shopify-US orders only***
    What was the customer's method of payment?"
    hidden: no
    type: string
    sql: ${TABLE}.PAYMENT_METHOD ;;
  }

  dimension: recycle_fee_amt {
    view_label: "Sales"
    hidden:yes
    type: number
    sql: ${TABLE}.RECYCLE_FEE_AMT ;;
  }

  dimension: related_tranid {
    view_label: "Sales"
    hidden: no
    type: string
    sql: ${TABLE}.RELATED_TRANID ;;
  }

  dimension_group: sales_effective {
    view_label: "Sales"
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
    view_label: "Sales"
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
    view_label: "Sales"
    hidden: yes
    type: number
    sql: ${TABLE}.SHIPPING_AMT ;;
  }

  dimension: shopify_discount_code {
    view_label: "Sales"
    hidden: yes
    type: string
    sql: ${TABLE}.SHOPIFY_DISCOUNT_CODE ;;
  }

  dimension: shopify_risk_analysis {
    view_label: "Sales"
    hidden: yes
    type: string
    sql: ${TABLE}.SHOPIFY_RISK_ANALYSIS ;;
  }

  dimension: shopify_risk_rating {
    view_label: "Sales"
    hidden: yes
    type: string
    sql: ${TABLE}.SHOPIFY_RISK_RATING ;;
  }

  dimension: source {
    view_label: "Sales"
    label:  "Order source"
    description: "System where order was placed"
    hidden: yes
    type: string
    sql: ${TABLE}.SOURCE ;;
  }

  dimension: status {
    label: "Status of order"
    view_label: "Sales"
    #hidden:  yes
    type: string
    sql: ${TABLE}.STATUS ;;
  }

  dimension: system {
    view_label: "Sales"
    hidden: yes
    type: string
    sql: ${TABLE}.SYSTEM ;;
  }

  dimension: tax_amt {
    hidden: yes
    view_label: "Sales"
    type: number
    sql: ${TABLE}.TAX_AMT ;;
  }

  dimension_group: trandate {
    view_label: "Sales"
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
    view_label: "Sales"
    description: "Netsuite's Sale Order Number"
    hidden: yes
    type: string
    sql: ${TABLE}.TRANID ;;
  }

  dimension: transaction_number {
    view_label: "Sales"
    hidden: yes
    type: string
    sql: ${TABLE}.TRANSACTION_NUMBER ;;
  }

  dimension: update_ts {
    view_label: "Sales"
    hidden: yes
    type: string
    sql: ${TABLE}.UPDATE_TS ;;
  }

  dimension: warranty {
    view_label: "Sales"
    hidden: yes
    type: string
    sql: ${TABLE}.WARRANTY ;;
  }

  dimension: warranty_claim_id {
    view_label: "Sales"
    hidden: yes
    type: number
    sql: ${TABLE}.WARRANTY_CLAIM_ID ;;
  }

  dimension: warranty_order_flg {
    view_label: "Sales"
    label: "Warranty_order?"
    description: "Was this order a warranty replacement"
    type: yesno
    sql: ${TABLE}.WARRANTY_CLAIM_ID is not null ;;
  }

  dimension: manna_transmission {
    label: "Manna Transmission"
    description: "At the sales header level this is confirmation/acceptance from manna to netsuite that they will start the process of fulfillment"
    type: date
    sql: ${TABLE}.manna_transmission ;;
  }

}
