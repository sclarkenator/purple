view: sales_order {
  sql_table_name: SALES.SALES_ORDER ;;

  measure: total_orders {
    label: "Total Unique Orders"
    #description:"Unique orders placed"
    type: count_distinct
    sql: ${order_id} ;; }

  measure: average_order_size {
    label: "Average Order Size ($)"
    description: "Average total order amount, excluding tax"
    type: average
    value_format: "$#,##0.00"
    sql: ${TABLE}.gross_amt ;; }

  dimension: order_system {
    primary_key:  yes
    hidden:  yes
    sql: ${TABLE}.order_id||'-'||${TABLE}.system ;; }

  dimension: channel_source {
    label: "Order Source"
    description: "Where was the order placed? (Shopify US, Shopify CA, Amazon US, Amazon CA, Other)"
    case: {
      when: { sql: ${TABLE}.system = 'SHOPIFY-US' or ${TABLE}.source = 'Shopify - US' or ${TABLE}.source is null or ${TABLE}.source = 'Direct Entry' ;;
        label: "SHOPIFY-US" }
      when: { sql: ${TABLE}.system = 'SHOPIFY-CA' or ${TABLE}.source = 'Shopify - CA' ;; label: "SHOPIFY-CA" }
      when: { sql: ${TABLE}.system = 'AMAZON.COM' or ${TABLE}.source = 'Amazon FBA - US' or ${TABLE}.system = 'AMAZON-US' ;; label: "AMAZON-US" }
      when: { sql: ${TABLE}.system = 'AMAZON-CA'  or ${TABLE}.source = 'Amazon FBA - CA';; label: "AMAZON-CA" }
      else: "OTHER" } }

  dimension: channel_id {
    label: "Channel ID"
    description:  "1 = DTC, 2 = Wholesale"
    type: number
    sql: ${TABLE}.CHANNEL_id ;; }

  dimension: channel {
    label: "Channel"
    description:  "DTC or Wholesale"
    type: string
    sql:  case when ${channel_id} = 2 then 'Wholesale' else 'DTC' end  ;; }

  dimension: created {
    hidden: yes
    type: date_time
    sql: ${TABLE}.CREATED ;; }

  dimension: created_by_id {
    hidden: yes
    type: number
    sql: ${TABLE}.CREATED_BY_ID ;; }

  dimension: customer_id {
    hidden: yes
    type: number
    sql: ${TABLE}.CUSTOMER_ID ;; }

  dimension: email {
    hidden: yes
    type: string
    sql: ${TABLE}.EMAIL ;; }

  dimension: etail_order_id {
    hidden: yes
    type: string
    sql: ${TABLE}.ETAIL_ORDER_ID ;; }

  dimension_group: in_hand {
    label: "In Hand"
    type: time
    hidden: yes
    timeframes: [raw, date, day_of_week, day_of_month, week, week_of_year, month, month_name, quarter, quarter_of_year, year]
    convert_tz: no
    datatype: timestamp
    sql: ${TABLE}.IN_HAND ;; }

  dimension_group: minimum_ship {
    label: "Minimum Ship by Date"
    description: "Wholesale = The earliest date the order could be fulfilled, DTC = Customer requested a delay"
    view_label: "Fulfillment"
    #hidden: yes
    type: time
    timeframes: [raw, date, day_of_week, day_of_month, week, week_of_year, month, month_name, quarter, quarter_of_year, year]
    convert_tz: no
    datatype: timestamp
    sql: to_timestamp_ntz(${TABLE}.minimum_ship) ;; }

  dimension_group: ship_by {
    label: "Ship by"
    description: "This is the date order must be fulfilled by to arrive as expected (used by wholesale)"
    view_label: "Fulfillment"
    type: time
    timeframes: [raw, date, day_of_week, day_of_month, week, week_of_year, month, month_name, quarter, quarter_of_year, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.SHIP_BY ;; }

  dimension: insert_ts {
    hidden: yes
    type: string
    sql: ${TABLE}.INSERT_TS ;; }

  dimension: is_upgrade {
    label: "Is Order Upgrade"
    description: "Yes - this order an upgrade on a previous order"
    type: string
    sql: ${TABLE}.IS_UPGRADE ;; }

  dimension: memo {
    hidden: yes
    type: string
    sql: ${TABLE}.MEMO ;; }

  dimension: modified {
    hidden: yes
    type: string
    sql: ${TABLE}.MODIFIED ;; }

  dimension: gross_amt {
    label:  "Gross Order Size ($)"
    description: "Total gross sales for all items on order, excluding taxes."
    type: number
    sql: ${TABLE}.gross_amt ;;  }

  dimension: Order_size_buckets{
    label: "Order Size (Buckets)"
    description: "Different price buckets for total gross order amount (150,600,1000,1500,2500)"
    type:  tier
    style: integer
    tiers: [150,600,1000,1500,2500]
    sql: ${TABLE}.gross_amt ;; }

  dimension: order_id {
    label: "Order ID"
    hidden: no
    html: <a href = "https://system.na2.netsuite.com/app/accounting/transactions/salesord.nl?id={{value}}&whence=" target="_blank"> {{value}} </a> ;;
    description: "This is Netsuite's internal ID. This will be a hyperlink to the sales order in Netsuite."
    type: number
    sql: ${TABLE}.ORDER_ID ;; }

  dimension: payment_method {
    label: "Order Payment Method (shopify)"
    description: "For Shopify-US orders only. The customer's method of payment"
    type: string
    sql: ${TABLE}.PAYMENT_METHOD ;; }

  dimension: recycle_fee_amt {
    hidden:yes
    type: number
    sql: ${TABLE}.RECYCLE_FEE_AMT ;; }

  dimension: related_tranid {
    label: "Related Transaction ID"
    description: "Netsuite's internal related transaction id"
    type: string
    sql: ${TABLE}.RELATED_TRANID ;; }

  dimension_group: sales_effective {
    hidden: yes
    type: time
    timeframes: [raw, date, day_of_week, day_of_month, week, week_of_year, month, month_name, quarter, quarter_of_year, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.SALES_EFFECTIVE ;; }

  dimension_group: shipment_received {
    hidden: yes
    type: time
    timeframes: [raw, date, day_of_week, day_of_month, week, week_of_year, month, month_name, quarter, quarter_of_year, year]
    convert_tz: no
    datatype: timestamp
    sql: ${TABLE}.SHIPMENT_RECEIVED ;; }

  dimension: shipping_amt {
    hidden: yes
    type: number
    sql: ${TABLE}.SHIPPING_AMT ;; }

  dimension: shopify_discount_code {
    hidden: yes
    type: string
    sql: ${TABLE}.SHOPIFY_DISCOUNT_CODE ;; }

  dimension: shopify_risk_analysis {
    hidden: yes
    type: string
    sql: ${TABLE}.SHOPIFY_RISK_ANALYSIS ;; }

  dimension: shopify_risk_rating {
    hidden: yes
    type: string
    sql: ${TABLE}.SHOPIFY_RISK_RATING ;; }

  dimension: source {
    label:  "Order Source"
    description: "System where order was placed"
    hidden: yes
    type: string
    sql: ${TABLE}.SOURCE ;; }

  dimension: status {
    label: "Status of Order"
    #hidden:  yes
    type: string
    sql: ${TABLE}.STATUS ;; }

  dimension: system {
    hidden: yes
    type: string
    sql: ${TABLE}.SYSTEM ;; }

  dimension: tax_amt {
    hidden: yes
    type: number
    sql: ${TABLE}.TAX_AMT ;; }

  dimension_group: trandate {
    hidden: yes
    type: time
    timeframes: [raw, date, day_of_week, day_of_month, week, week_of_year, month, month_name, quarter, quarter_of_year, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.TRANDATE ;; }

  dimension: tranid {
    label: "Transaction ID"
    description: "Netsuite's Sale Order Number"
    type: string
    sql: ${TABLE}.TRANID ;; }

  dimension: transaction_number {
    hidden: yes
    type: string
    sql: ${TABLE}.TRANSACTION_NUMBER ;; }

  dimension: update_ts {
    hidden: yes
    type: string
    sql: ${TABLE}.UPDATE_TS ;; }

  dimension: warranty {
    hidden: yes
    type: string
    sql: ${TABLE}.WARRANTY ;; }

  dimension: warranty_claim_id {
    hidden: yes
    type: number
    sql: ${TABLE}.WARRANTY_CLAIM_ID ;; }

  dimension: warranty_order_flg {
    label: "Is Warranty Order"
    description: "Yes if this order has a warranty replacement"
    type: yesno
    sql: ${TABLE}.WARRANTY_CLAIM_ID is not null ;; }

  dimension: manna_transmission {
    label: "Manna Transmission"
    description: "At the sales header level this is confirmation/acceptance from manna to netsuite that they will start the process of fulfillment"
    view_label: "Fulfillment"
    type: date
    sql: ${TABLE}.manna_transmission ;; }

  measure: manna_transmission_Average {
    view_label: "Fulfillment"
    group_label: "Average Days:"
    label: "to Manna Transmission"
    description: "Finds the average time elapsed between Order Date and Manna Transmission Date"
    type: average
    sql:  DateDiff('Day',${TABLE}.CREATED,${TABLE}.manna_transmission) ;; }

  dimension: manna_transmission_succ {
    label: "Is Manna Transmission Success"
    description: "Yes if an order has successfully transmitted to Manna"
    view_label: "Fulfillment"
    type: yesno
    sql: ${TABLE}.MANNA_TRANSMISSION_SUCCESS = '1';; }


}
