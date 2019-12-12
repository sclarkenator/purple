view: sales_order {
  sql_table_name: SALES.SALES_ORDER ;;

  measure: total_orders {
    label: "Total Unique Orders"
    #description:"Unique orders placed"
    drill_fields: [order_id, tranid,sales_order_line.created_date,sales_order_line.SLA_Target_date,minimum_ship_date ,item.product_description, sales_order_line.location, source, sales_order_line.total_units,sales_order_line.gross_amt]
    type: count_distinct
    description: "Distinct Orders"
    sql: ${order_id} ;; }

  measure: unique_customers {
    label: "Distinct customers"
    description: "Counts distinct email addresses in customer table"
    view_label: "Customer"
    type: count_distinct
    hidden: no
    sql: ${TABLE}.email ;; }

measure: upt {
  label: "UPT"
  description: "Units per transaction"
  type: number
  sql: ${sales_order_line.total_units}/count (distinct ${order_id}) ;; }

  measure: average_order_size {
    label: "Average Order Size ($)"
    description: "Average total order amount, excluding tax"
    type: average
    value_format: "$#,##0.00"
    sql: ${TABLE}.gross_amt ;; }

  measure: max_order_size {
    label: " Max Order Size ($)"
    description: "Max total order amount, excluding tax"
    type: max
    value_format: "$#,##0.00"
    sql: ${TABLE}.gross_amt ;; }

  measure: min_order_size {
    label: " Min Order Size ($)"
    description: "Min total order amount, excluding tax"
    type: min
    value_format: "$#,##0.00"
    sql: ${TABLE}.gross_amt ;; }

  dimension: order_system {
    primary_key:  yes
    type: string
    hidden:  yes
    sql: ${TABLE}.order_id||'-'||${TABLE}.system ;; }

  dimension: channel_source {
    label: "   Order Source (buckets)"
    description: "Merging the order source and system (Shopify US, Shopify CA, Amazon US, Amazon CA, Other)"
    case: {
      when: { sql: (lower(${TABLE}.system) like ('%shopify%') and lower(${TABLE}.system) like ('%us%'))
              or (lower(${TABLE}.source) like ('%shopify%') and lower(${TABLE}.source) like ('%us%'))
              or (lower(${TABLE}.source) like ('%direct entry%')) or (${TABLE}.source is null);;
        label: "SHOPIFY-US" }
      when: { sql: (lower(${TABLE}.system) like ('%shopify%') and lower(${TABLE}.system) like ('%ca%'))
          or (lower(${TABLE}.source) like ('%shopify%') and lower(${TABLE}.source) like ('%ca%')) ;;
        label: "SHOPIFY-CA" }
      when: { sql: (lower(${TABLE}.system) like ('%amazon%')  and lower(${TABLE}.system) like ('%ca%'))
          or (lower(${TABLE}.source) like ('%amazon%')  and lower(${TABLE}.source) like ('%ca%')) ;;
        label: "AMAZON-CA"  }
      when: { sql: (lower(${TABLE}.source) like ('%amazon%')) or  (lower(${TABLE}.system) like ('%amazon%')) ;;
        label: "AMAZON-US" }
      else: "OTHER" } }

  dimension: Amazon_fulfillment{
    group_label: " Advanced"
    label: "Amazon Fulfillment"
    description: "Whether the purchase from amazon was deliverd by amazon or purple"
    case: {
      when: { sql: lower(${TABLE}.source) like ('%fbm%') ;;  label: "Purple" }
      when: { sql: lower(${TABLE}.source) like ('%fba%') ;;  label: "Amazon" }
      else: "Not Amazon" } }

  dimension: channel_id {
    label: "Channel ID"
    hidden: yes
    description:  "1 = DTC, 2 = Wholesale"
    type: number
    sql: ${TABLE}.CHANNEL_id ;; }

  dimension: channel {
    label: "Channel Filter"
    hidden: yes
    view_label: "Filters"
    type: string
    sql:  case when ${channel_id} = 1 then 'DTC'
               when ${channel_id} = 2 then 'Wholesale'
               when ${channel_id} = 3 then 'General'
               when ${channel_id} = 4 then 'Employee Store'
               when ${channel_id} = 5 then 'Owned Retail'
              else 'Other' end  ;; }

  dimension: channel2 {
    label: "  Channel"
    description:  "Which Netsuite Channel was the order processed through (DTC, Wholesale, Owned Retail, etc)"
    type: string
    sql:  case when ${channel_id} = 1 then 'DTC'
               when ${channel_id} = 2 then 'Wholesale'
               when ${channel_id} = 3 then 'General'
               when ${channel_id} = 4 then 'Employee Store'
               when ${channel_id} = 5 then 'Owned Retail'
              else 'Other' end  ;; }

  dimension: created {
    hidden: yes
    type: date_time
    sql: ${TABLE}.CREATED ;; }

  dimension: shipping_hold {
    group_label: " Advanced"
    view_label: "Fulfillment"
    label: "Shipping Hold?"
    type: string
    sql: ${TABLE}.SHIPPING_HOLD ;; }

  dimension: created_by_id {
    hidden: yes
    type: number
    sql: ${TABLE}.CREATED_BY_ID ;; }

  dimension: 3PL_MSFID {
    label: "3PL MSFID"
    view_label: "Fulfillment"
    group_label: " Advanced"
    description: "The Pilot Order ID"
    hidden: no
    type: string
    sql: ${TABLE}."3PL_MSFID_ESONUS" ;; }

  dimension: showroom {
    group_label: " Advanced"
    description: "Flag for orders made in the Alpine Showroom"
    type: yesno
    sql: ${TABLE}.showroom ;; }

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
    label: "NetSuite In Hand"
    view_label: "Fulfillment"
    type: time
    hidden: no
    timeframes: [raw, date, day_of_week, day_of_month, week, week_of_year, month, month_name, quarter, quarter_of_year, year]
    convert_tz: no
    datatype: timestamp
    sql: ${TABLE}.IN_HAND ;; }

  dimension_group: minimum_ship {
    label: "Minimum Ship by"
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

  dimension_group: ship_by_2 {
    label: "Ship by and Minimum Ship"
    description: "Picking the date in the future of the created date"
    view_label: "Fulfillment"
    type: time
    timeframes: [raw, date, day_of_week, day_of_month, week, week_of_year, month, month_name, quarter, quarter_of_year, year]
    convert_tz: no
    datatype: date
    sql: case when ${sales_order.minimum_ship_date} > ${sales_order.ship_by_date} then ${sales_order.minimum_ship_date}
      else dateadd(d,-3,${sales_order.ship_by_date}) end ;; }

  dimension: insert_ts {
    hidden: yes
    type: string
    sql: ${TABLE}.INSERT_TS ;; }

  dimension: is_upgrade {
    group_label: " Advanced"
    label: "Is Order Upgrade"
    description: "Yes - this order an upgrade on a previous order"
    #type: string
    #sql: ${TABLE}.IS_UPGRADE ;; }
    type: yesno
    sql: ${TABLE}.IS_UPGRADE = 'T' ;; }

  dimension: memo {
    hidden: yes
    type: string
    sql: ${TABLE}.MEMO ;; }

  dimension: modified {
    hidden: yes
    type: string
    sql: ${TABLE}.MODIFIED ;; }

  dimension: gross_amt {
    group_label: " Advanced"
    label:  "Gross Order Size ($)"
    description: "Total gross sales for all items on order, excluding taxes."
    type: number
    sql: ${TABLE}.gross_amt ;;  }

  dimension: Order_size_buckets{
    label: "   Order Size (buckets)"
    description: "Different price buckets for total gross order amount (150,600,1000,1500,2500)"
    hidden:   no
    type:  tier
    style: integer
    tiers: [150,600,1000,1500,2500]
    sql: ${TABLE}.gross_amt ;; }

  dimension: Order_size_buckets_v2{
    label: "Order Size (buckets)"
    description: "$500 price  (500/1000/1500/etc)"
    hidden:  yes
    type:  tier
    style: integer
    tiers: [500,1000,1500,2000,2500,3000,3500,4000]
    sql: ${TABLE}.gross_amt ;; }

  dimension: Order_size_buckets_v3{
    label: "Order Size (buckets by 100)"
    description: "Different price buckets for total gross order amount, by 100 increments"
    hidden:   yes
    type:  tier
    style: integer
    tiers: [150,600,700,800,900,1000,1100,1200,1300,1400,1500,1600,1700,1800,1900,2000,2100,2200,2300,2400,2500,2600,2700,2800,2900,3000,3100]
    sql: ${TABLE}.gross_amt ;; }


  dimension: order_id {
    group_label: " Advanced"
    label: "Order ID"
    hidden: no
    html: <a href = "https://system.na2.netsuite.com/app/accounting/transactions/salesord.nl?id={{value}}&whence=" target="_blank"> {{value}} </a> ;;
    description: "This is Netsuite's internal ID. This will be a hyperlink to the sales order in Netsuite."
    type: number
    sql: ${TABLE}.ORDER_ID ;; }

  dimension: order_id_count{
    group_label: " Advanced"
    label: "Order ID"
    hidden: yes
    type: number
    sql: count(${TABLE}.ORDER_ID) ;; }

  dimension: payment_method {
    group_label: " Advanced"
    label: "Order Payment Method (shopify)"
    description: "For Shopify-US orders only. The customer's method of payment"
    type: string
    sql: ${TABLE}.PAYMENT_METHOD ;; }

  dimension: payment_method_flag {
    label: "     * Is Financed"
    description: "For Shopify-US orders only. Payment with Affirm or Progressive"
    type: yesno
    sql: ${TABLE}.PAYMENT_METHOD ilike 'AFFIRM' or ${TABLE}.PAYMENT_METHOD ilike 'PROGRESSIVE' ;; }

  dimension: recycle_fee_amt {
    hidden:yes
    type: number
    sql: ${TABLE}.RECYCLE_FEE_AMT ;; }

  dimension: related_tranid {
    group_label: " Advanced"
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
    label: "Shopify Discount Code"
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
    group_label: " Advanced"
    label:  "Order Source"
    description: "System where order was placed"
    #hidden: yes
    type: string
    sql: ${TABLE}.SOURCE ;; }

  dimension: status {
    group_label: " Advanced"
    label: "Status"
    description: "Billed, Shipped, Closed, Cancelled, Pending Fullfillment, etc"
    #hidden:  yes
    type: string
    sql: ${TABLE}.STATUS ;; }

  dimension: system {
    group_label: " Advanced"
    label: "System"
    description: "System the order originated in. (Amazon, Shopify, Netsuite)"
    #hidden: yes
    type: string
    sql: ${TABLE}.SYSTEM ;; }

  dimension: tax_amt {
    hidden: yes
    type: number
    sql: ${TABLE}.TAX_AMT ;; }

  measure: tax_amt_total {
    label: "Total Tax ($)"
    description: "Amount of Tax Collected"
    #hidden: yes
    type: sum
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
    group_label: " Advanced"
    description: "Netsuite's Sale Order Number"
    link: {
      label: "NetSuite"
      url: "https://system.na2.netsuite.com/app/accounting/transactions/salesord.nl?id={{order_id._value}}&whence="}
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
    group_label: " Advanced"
    label: "Is Warranty Order"
    description: "Yes if this order has a warranty replacement"
    type: yesno
    sql: ${TABLE}.WARRANTY_CLAIM_ID is not null or ${TABLE}.warranty = 'T' ;; }

  dimension: manna_transmission {
    label: "Manna Transmission"
    hidden: yes
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
    hidden: yes
    description: "Yes if an order has successfully transmitted to Manna"
    view_label: "Fulfillment"
    type: yesno
    sql: ${TABLE}.MANNA_TRANSMISSION_SUCCESS = '1';; }

  dimension: bill_of_lading_number {
    label: "Bill of Landing Number"
    hidden: yes
    type: string
    sql: ${TABLE}.bill_of_lading_number ;;
  }

  dimension: SHIPPING_ADDRESS_VALIDATED {
    hidden: yes
    type: string
    sql: ${TABLE}.SHIPPING_ADDRESS_VALIDATED ;;
  }

  dimension: WAREHOUSE_EDGE_STATUS {
    hidden: yes
    type: string
    sql: ${TABLE}.WAREHOUSE_EDGE_STATUS ;;
  }

  dimension: DOWNLOAD_TO_WAREHOUSE_EDGE {
    hidden: yes
    type: string
    sql: ${TABLE}.DOWNLOAD_TO_WAREHOUSE_EDGE ;;
  }

  dimension: store_id {
    label: "Retail store ID"
    description: "Netsuite retail store ID"
    group_label: " Advanced"
    view_label: "Sales Order"
    type: string
    sql: ${TABLE}.showroom_name ;;
  }

}