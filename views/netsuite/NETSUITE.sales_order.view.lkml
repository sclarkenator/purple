view: sales_order {
  sql_table_name: SALES.SALES_ORDER ;;

  dimension: valid_address{
    label: "     * Is Address Valid? (Yes/No)"
    description: "Has the address been validated? Source: netsuite.sales_order"
    type: string
    hidden:  no
    view_label: "Fulfillment"
    group_label: " Advanced"
    sql: ${TABLE}.shipping_address_validated ;;
  }

  dimension: ship_to_phone{
    type: string
    hidden:  no
    view_label: "Fulfillment"
    group_label: " Advanced"
    sql: ${TABLE}.phone_number_reference ;;
    required_access_grants:[can_view_pii]
  }

  dimension: shipping_phone_number{
    type: string
    hidden:  no
    view_label: "Fulfillment"
    group_label: " Advanced"
    sql: ${TABLE}.shipping_phone_number ;;
    required_access_grants:[can_view_pii]
  }

  dimension: cannot_ship{
    type: string
    hidden:  yes
    view_label: "Fulfillment"
    group_label: " Advanced"
    sql: case when ${valid_address} = 'No' then 'address not validated'
    when ${shipping_hold} = 'T' then 'shipping hold'
    when ${status} = 'Pending Approval' then 'pending approval'
    end;;
  }

  measure: total_orders {
    label: "Total Unique Orders"
    description: "Distinct Orders. Source:netsuite.sales_order"
    drill_fields: [sales_order_line.sales_order_details*]
    type: count_distinct
    sql: ${order_id} ;; }

  measure: unique_customers {
    label: "Distinct Customers"
    description: "Counts distinct email addresses in customer table.
      Source: netsuite.sales_order"
    view_label: "Customer"
    #drill_fields: [sales_order_line.sales_order_details*]
    type: count_distinct
    hidden: no
    sql: ${TABLE}.email ;; }

  measure: average_order_size {
    label: "AOV ($)"
    description: "Average total order amount, excluding tax.
      Source: netsuite.sales_order"
    drill_fields: [sales_order_line.sales_order_details*]
    type: average
    value_format: "$#,##0"
    sql:case when ${sales_order.gross_amt}>0 then ${sales_order.gross_amt} end;; }

  measure: max_order_size {
    label: " Max Order Size ($)"
    description: "Max total order amount, excluding tax.
      Source: netsuite.sales_order"
    drill_fields: [sales_order_line.sales_order_details*]
    type: max
    value_format: "$#,##0.00"
    sql: ${TABLE}.gross_amt ;; }

  measure: min_order_size {
    label: " Min Order Size ($)"
    description: "Min total order amount, excluding tax.
      Source: netsuite.sales_order"
    drill_fields: [sales_order_line.sales_order_details*]
    type: min
    value_format: "$#,##0.00"
    sql: ${TABLE}.gross_amt ;; }

  dimension: order_system {
    primary_key:  yes
    type: string
    hidden:  yes
    sql: ${TABLE}.order_id||'-'||${TABLE}.system ;; }

  dimension: channel_source {
    group_label: " Advanced"
    label: " Order Source (buckets)"
    description: "Merging the order source and system (Shopify US, Shopify CA, Amazon US, Amazon CA, Other). Source: netsuite.sales_order"
    case: {
      when: { sql: (lower(${TABLE}.system) like ('%shopify%') and lower(${TABLE}.system) like ('%us%'))
              or (lower(${TABLE}.source) like ('%shopify%') and lower(${TABLE}.source) like ('%us%'))
              or (lower(${TABLE}.source) like ('%direct entry%')) or (${TABLE}.source is null)
              or ${TABLE}.source = 'Shopify - POS';;
        label: "SHOPIFY-US" }
      when: { sql: (lower(${TABLE}.system) like ('%shopify%') and lower(${TABLE}.system) like ('%ca%'))
          or (lower(${TABLE}.source) like ('%shopify%') and lower(${TABLE}.source) like ('%ca%')) ;;
        label: "SHOPIFY-CA" }
      when: { sql: (lower(${TABLE}.system) like ('%amazon%')  and lower(${TABLE}.system) like ('%ca%'))
          or (lower(${TABLE}.source) like ('%amazon%')  and lower(${TABLE}.source) like ('%ca%')) ;;
        label: "AMAZON-CA"  }
      when: { sql: (lower(${TABLE}.source) like ('%amazon%')) or  (lower(${TABLE}.system) like ('%amazon%')) ;;
        label: "AMAZON-US" }
      when: { sql: (${TABLE}.source = 'Commerce Tools' ) ;;
        label: "COMMERCE TOOLS" }
      else: "OTHER" } }

  dimension: Amazon_fulfillment{
    group_label: " Advanced"
    label: "Amazon Fulfillment"
    description: "Whether the purchase from amazon was deliverd by amazon or purple.
      Source: netsuite.sales_order"
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
    group_label: " Advanced"
    label: "Channel Filter"
    hidden: yes
    type: string
    sql:  case when ${channel_id} = 1 then 'DTC'
               when ${channel_id} = 2 then 'Wholesale'
               when ${channel_id} = 3 then 'General'
               when ${channel_id} = 4 then 'Employee Store'
               when ${channel_id} = 5 then 'Owned Retail'
              else 'Other' end  ;; }

  dimension: channel2 {
    group_label: " Advanced"
    label: "Channel"
    description:  "Which Netsuite Channel was the order processed through (DTC, Wholesale, Owned Retail, etc).
      Source: netsuite.sales_order"
    type: string
    sql:  case when ${channel_id} = 1 then 'DTC'
               when ${channel_id} = 2 then 'Wholesale'
               when ${channel_id} = 3 then 'General'
               when ${channel_id} = 4 then 'Employee Store'
               when ${channel_id} = 5 then 'Owned Retail'
              else 'Other' end  ;; }

  dimension: dtc_channel_sub_category {
    label: "DTC Channel Sub-Category"
    group_label: " Advanced"
    hidden: yes
    description: "Which DTC Sub-Category was the order processed through (Merchandise, Shopify, Direct Entry, etc).
      Source: netsuite.sales_order"
    type: string
    sql: case when ${source} = 'Amazon-FBM-US' OR ${source} = 'Amazon-FBA' OR ${source} = 'Amazon FBA - US' OR ${source} = 'eBay' then 'Merchant'
              when ${source} = 'SHOPIFY-US Historical' OR ${source} = 'SHOPIFY-CA' OR ${source} = 'Shopify - US' OR ${source} = 'Shopify - Canada' then 'Shopify'
              when ${source} = 'Direct Entry' then 'Direct Entry'
              else 'Other' end ;;  }

  # dimension: channel_ret {
  #   hidden: yes
  #   ##this is for joining the modeled return rate file only
  #   ##moved to sales order line
  #   type: string
  #   sql:
  #     case when ${zendesk_sell.order_id} is not null then 'Inside sales'
  #       when ${channel_id} = 1 then 'Web'
  #       when ${channel_id} = 5 then 'Retail'
  #       else 'Other'
  #     end
  #   ;;
  # }

  dimension: trandate {
    hidden: yes
    sql: ${TABLE}.trandate ;;}

  dimension: created {
    hidden: yes
    type: date_time
    sql: ${TABLE}.CREATED ;; }

  dimension: created_date {
    label: "Sales Order Created Date"
    type: date
    group_label: " Advanced"
    description: "Created date from netsuite on the sale order. Source:netsuite.sales_order"
    sql: ${created}::date ;;
  }

  dimension: shipping_hold {
    hidden: yes
    group_label: " Advanced"
    view_label: "Fulfillment"
    label: "Shipping Hold?"
    description: "T/F T if there is a shipping hold.
      Source: netsuite.sales_order"
    type: string
    sql: ${TABLE}.SHIPPING_HOLD ;; }

  dimension: created_by_id {
    hidden: yes
    type: number
    sql: ${TABLE}.CREATED_BY_ID ;; }

  dimension: 3PL_MSFID {
    view_label: "Fulfillment"
    group_label: " Advanced"
    label: "3PL MSFID"
    description: "The Pilot Order ID
      Source:netsuite.sales_order"
    hidden: no
    type: string
    sql: ${TABLE}."3PL_MSFID_ESONUS" ;; }

  dimension: showroom {
    hidden: yes
    group_label: " Advanced"
    label: "Showroom"
    description: "Flag for orders made in the Alpine Showroom. Source: netsuite.sales_order"
    type: yesno
    sql: ${TABLE}.showroom ;; }

  dimension: customer_id {
    hidden: yes
    type: number
    sql: ${TABLE}.CUSTOMER_ID ;; }

  dimension: email {
    group_label: "  Customer details"
    view_label: "Customer"
    hidden:  yes
    label: "Customer Email"
    description: "Customer Email Address on the Netsuite sales order record. Source:netsuite.sales_order used for calculations only to avoid PII"
    type: string
    sql: ${TABLE}.email ;; }

  dimension: email1 {
    group_label: "  Customer details"
    view_label: "Customer"
    hidden:  no
    label: "Customer Email"
    description: "Customer Email Address on the Netsuite sales order record. Source:netsuite.sales_order"
    type: string
    sql: CASE WHEN '{{ _user_attributes['can_view_pii'] }}' = 'yes' THEN ${TABLE}.email
              ELSE '**********' || '@' || SPLIT_PART(${TABLE}.email, '@', 2) END ;; }

  dimension: etail_order_id {
    hidden: yes
    type: string
    sql: ${TABLE}.ETAIL_ORDER_ID ;; }

  dimension_group: in_hand {
    label: "NetSuite In Hand"
    view_label: "Fulfillment"
    type: time
    hidden: yes
    timeframes: [raw, date, day_of_week, day_of_month, week, week_of_year, month, month_name, quarter, quarter_of_year, year]
    convert_tz: no
    datatype: timestamp
    sql: ${TABLE}.IN_HAND ;; }

  dimension: Kount_Status {
    hidden: no
    group_label: " Advanced"
    label: "Kount Status"
    description: "Kount Fraud Status. Source:netsuite.sales_order"
    type: string
    sql: ${TABLE}.kount_status ;; }

  dimension: fraud {
    hidden: no
    label: "Kount Status grouped"
    group_label: " Advanced"
    case: {
      when: {sql: ${Kount_Status} is null OR ${Kount_Status} = 'Approved' ;;
            label: "Clear"}
      when: {sql: ${Kount_Status} = 'Denied' ;;
        label: "Denied"}
      when: {sql: ${Kount_Status} = 'Under Review' ;;
        label: "Under Review"}
      when: {sql: ${Kount_Status} = 'New' ;;
        label: "New"}
      }
    }

  dimension_group: minimum_ship {
    label: "Minimum Ship by"
    description: "Wholesale = The earliest date the order could be fulfilled, DTC = Customer requested a delay.
      Source: netsuite.sales_order"
    view_label: "Fulfillment"
    hidden: yes
    type: time
    timeframes: [raw, date, day_of_week, day_of_month, week, week_of_year, month, month_name, quarter, quarter_of_year, year]
    convert_tz: no
    datatype: timestamp
    sql: to_timestamp_ntz(${TABLE}.minimum_ship) ;; }

  dimension_group: ship_by {
    label: "Ship by"
    description: "This is the date order must be fulfilled by to arrive as expected (used by wholesale).
      Source: netsuite.sales_order"
    view_label: "Fulfillment"
    hidden: yes
    type: time
    timeframes: [raw, date, day_of_week, day_of_month, week, week_of_year, month, month_name, quarter, quarter_of_year, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.SHIP_BY ;; }

  dimension_group: ship_by_2 {
    label: "Ship by and Minimum Ship"
    description: "Picking the date in the future of the created date.
      Source: netsuite.sales_order"
    view_label: "Fulfillment"
    type: time
    hidden: yes
    timeframes: [raw, date, day_of_week, day_of_month, week, week_of_year, month, month_name, quarter, quarter_of_year, year]
    convert_tz: no
    datatype: date
    sql: case when ${sales_order.minimum_ship_date} > ${sales_order.ship_by_date} then ${sales_order.minimum_ship_date}
      else dateadd(d,-3,${sales_order.ship_by_date}) end ;; }

  dimension_group: ship_order_by {
    label: "Ship by or Order"
    description: "Using ship by date unless blank then order date.
      Source: netsuite.sales_order"
    view_label: "Fulfillment"
    type:time
    hidden: no
    timeframes: [raw, date, day_of_week, day_of_month, week, week_of_year, month, month_name,month_num, quarter, quarter_of_year, year]
    convert_tz: no
    datatype: date
    sql:nvl(${TABLE}.SHIP_BY,${TABLE}.Created::date) ;; }

  dimension: insert_ts {
    hidden: yes
    type: string
    sql: ${TABLE}.INSERT_TS ;; }

  dimension: is_upgrade {
    group_label: " Advanced"
    label: "  * Is Warranty Exchange"
    description: "Yes - this order is an upgrade from the original order on a warranty claim. Source: netsuite.sales_order"
    #type: string
    #sql: ${TABLE}.IS_UPGRADE ;; }
    type: yesno
    sql: ${TABLE}.IS_UPGRADE = 'T' ;; }

  dimension: is_exchange {
    group_label: " Advanced"
    label: "  * Is Return Exchange"
    description: "Yes - this order is an exchange from the original order on a return. Source: netsuite.sales_order"
    type: yesno
    sql: ${TABLE}.EXCHANGE = 'T' ;; }

  dimension: is_exchange_upgrade_warranty {
    hidden: no
    group_label: " Advanced"
    label: "  * Is Return Exchange or Warranty Exchange or Warranty"
    description: "Source: looker calculation"
    type: yesno
    sql:
      case
        when ${TABLE}.EXCHANGE = 'T' then 1
        when ${TABLE}.IS_UPGRADE = 'T' then 1
        when ${TABLE}.WARRANTY_CLAIM_ID is not null or ${TABLE}.warranty = 'T' then 1
        else 0
      end = 1
    ;;
  }
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
    label:"Gross Order Size ($)"
    description: "Total gross sales for all items on order, excluding taxes. Source:netsuite.sales_order"
    type: number
    sql: ${TABLE}.gross_amt ;;  }

  dimension: Order_size_buckets{
    group_label: " Advanced"
    label: " Order Size (buckets)"
    description: "Different price buckets for total gross order amount (150,600,1000,1500,2500). Source:netsuite.sales_order"
    hidden:   no
    type:  tier
    style: integer
    tiers: [150,600,1000,1500,2500]
    sql: ${TABLE}.gross_amt ;; }

  dimension: Order_size_buckets_v2{
    label: "Order Size (buckets)"
    description: "$500 price  (500/1000/1500/etc). Source: netsuite.sales_order"
    hidden:  yes
    type:  tier
    style: integer
    tiers: [500,1000,1500,2000,2500,3000,3500,4000]
    sql: ${TABLE}.gross_amt ;; }

  dimension: Order_size_buckets_v3{
    label: "Order Size (buckets by 100)"
    description: "Different price buckets for total gross order amount, by 100 increments. Source: netsuite.sales_order"
    hidden:   yes
    type:  tier
    style: integer
    tiers: [150,600,700,800,900,1000,1100,1200,1300,1400,1500,1600,1700,1800,1900,2000,2100,2200,2300,2400,2500,2600,2700,2800,2900,3000,3100]
    sql: ${TABLE}.gross_amt ;; }

  dimension: order_type_hyperlink {
    hidden: yes
    type: string
    sql: case when ${transaction_type} = 'Cash Sale' then 'cashsale' else 'salesord' end;;
  }

  dimension: order_id {
    group_label: " Advanced"
    label: "Order ID"
    description: "This is Netsuite's internal ID. This will be a hyperlink to the sales order in Netsuite.
      Source:netsuite.sales_order"
    hidden: no
    link: {
      label: "Netsuite"
      url: "https://4651144.app.netsuite.com/app/accounting/transactions/{{order_type_hyperlink._value}}.nl?id={{value}}&whence="
      icon_url: "https://www.google.com/s2/favicons?domain=www.netsuite.com"
      }
    #html: <a href = "https://system.na2.netsuite.com/app/accounting/transactions/{{order_type_hyperlink._value}}.nl?id={{value}}&whence=" target="_blank"> {{value}} </a> ;;
    type: string
    sql: ${TABLE}.order_id ;; }

  dimension: order_id_count{
    group_label: " Advanced"
    label: "Order ID"
    hidden: yes
    type: number
    sql: count(${TABLE}.ORDER_ID) ;; }

  dimension: payment_method {
    group_label: " Advanced"
    label: "Order Payment Method (shopify)"
    description: "The customer's method of payment. Source:netsuite.sales_order"
    type: string
    sql: ${TABLE}.PAYMENT_METHOD ;; }

    dimension: fin_flag {
    label: "     * Is Financed"
    hidden: yes
    description: "For Shopify-US orders only. Payment with Affirm, Progressive, Splitit, or Zibby.
      Source: netsuite.sales_order"
    type: number
    sql: case when (${TABLE}.PAYMENT_METHOD ilike 'AFFIRM'
                  or ${TABLE}.PAYMENT_METHOD ilike 'PROGRESSIVE'
                  or ${TABLE}.PAYMENT_METHOD ilike 'SPLITIT'
                  or ${TABLE}.PAYMENT_METHOD ilike 'ZIBBY') then 1
              when ${TABLE}.payment_method is null then 0 else 0 end ;; }


  dimension: payment_method_flag {
    label: "     * Is Financed"
    description: "For Shopify-US orders only. Payment with Affirm, Progressive, Splitit, or Zibby.
      Source: netsuite.sales_order"
    type: yesno
    sql: ${fin_flag}=1 ;; }

  dimension: recycle_fee_amt {
    label: "Recycle Fee"
    group_label: " Advanced"
    description: "The mattress recycle fee that applied to this order, or 0 if no fee applied."
    type: number
    sql: ${TABLE}.RECYCLE_FEE_AMT ;; }

  dimension: has_recycle_fee {
    label: "     * Has Recycle Fee"
    description: "Does this order have a mattress recycle fee?"
    type: yesno
    sql: coalesce(${TABLE}.RECYCLE_FEE_AMT,0) > 0 ;; }

  dimension: related_tranid {
    group_label: " Advanced"
    label: "Related Transaction ID"
    description: "Netsuite's internal related transaction id. Source:netsuite.sales_order"
    type: string
    sql: ${TABLE}.related_tranid ;; }

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
    description: "System where order was placed
      Source: netsuite.sales_order"
    #hidden: yes
    type: string
    sql: ${TABLE}.SOURCE ;; }

  dimension: status {
    group_label: " Advanced"
    label: "Status"
    description: "Billed, Shipped, Closed, Cancelled, Pending Fullfillment, etc. Source:netsuite.sales_order"
    #hidden:  yes
    type: string
    sql: ${TABLE}.STATUS ;; }

  dimension: system {
    group_label: " Advanced"
    label: "System"
    description: "System the order originated in. (Amazon, Shopify, Netsuite). Source:netsuite.sales_order"
    #hidden: yes
    type: string
    sql: ${TABLE}.SYSTEM ;; }

  dimension: tax_amt {
    hidden: yes
    type: number
    sql: ${TABLE}.TAX_AMT ;; }

  measure: tax_amt_total {
    label: "Total Tax ($)"
    description: "Amount of Tax Collected Source:netsuite.sales_order"
    #hidden: yes
    type: sum
    sql: ${TABLE}.TAX_AMT ;; }

  dimension: order_age_bucket {
    view_label: "Fulfillment"
    group_label: " Advanced"
    label: "Order Age (bucket)"
    description: "Number of days between today and when order was placed (1,2,3,4,5,6,7,11,15,21)
      Source:netsuite.sales_order"
    type:  tier
    tiers: [1,2,3,4,5,6,7,11,15,21]
    style: integer
    sql: datediff(day,
      case when ${minimum_ship_date} >= coalesce(dateadd(d,-3,${ship_by_date}), ${trandate_date}) and ${minimum_ship_date} >= ${trandate_date} then ${minimum_ship_date}
        when dateadd(d,-3,${ship_by_date}) >= coalesce(${minimum_ship_date}, ${trandate_date}) and dateadd(d,-3,${ship_by_date}) >= ${trandate_date} then ${ship_by_date}
        else ${trandate_date} end
      , current_date) ;; }
    #sql: datediff(day,coalesce(dateadd(d,-3,${sales_order.ship_by_date}),${created_date}),current_date) ;; }

  dimension: order_age_bucket2 {
    view_label: "Fulfillment"
    group_label: " Advanced"
    label: "Order Age (bucket 2)"
    hidden: no
    description: "Number of days between today and when order was placed (1,2,3,4,5,6,7,8,9,10,11,12,13,14,21,28)
      Source: netsuite.sales_order"
    type:  tier
    tiers: [1,2,3,4,5,6,7,8,9,10,11,12,13,14,21,28]
    style: integer
    sql: datediff(day,
      case when ${minimum_ship_date} >= coalesce(dateadd(d,-3,${ship_by_date}), ${trandate_date}) and ${minimum_ship_date} >= ${trandate_date} then ${minimum_ship_date}
        when dateadd(d,-3,${ship_by_date}) >= coalesce(${minimum_ship_date}, ${trandate_date}) and dateadd(d,-3,${ship_by_date}) >= ${trandate_date} then ${ship_by_date}
        else ${trandate_date} end
      , current_date) ;; }
    #sql: datediff(day,coalesce(dateadd(d,-3,${sales_order.ship_by_date}),${created_date}),current_date) ;; }

  dimension: order_age_raw {
    label: "Order Age Raw"
    description: "Number of days between today and when order was placed
      Source: netsuite.sales_order"
    hidden:  yes
    type:  number
    sql: datediff(day,
      case when ${minimum_ship_date} >= coalesce(dateadd(d,-3,${ship_by_date}), ${trandate_date}) and ${minimum_ship_date} >= ${trandate_date} then ${minimum_ship_date}
        when dateadd(d,-3,${ship_by_date}) >= coalesce(${minimum_ship_date}, ${trandate_date}) and dateadd(d,-3,${ship_by_date}) >= ${trandate_date} then ${ship_by_date}
        else ${trandate_date} end
      , current_date) ;; }

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
    description: "Netsuite's Sale Order Number
      Source: netsuite.sales_order"
    link: {
      label: "NetSuite"
      url: "https://system.na2.netsuite.com/app/accounting/transactions/salesord.nl?id={{order_id._value}}&whence="
      icon_url: "https://www.google.com/s2/favicons?domain=www.netsuite.com"
      }
    type: string
    sql: ${TABLE}.TRANID ;; }

  dimension: transaction_number {
    hidden: yes
    type: string
    sql: ${TABLE}.TRANSACTION_NUMBER ;; }

  dimension: transaction_type {
    hidden: yes
    type: string
    sql: ${TABLE}.TRANSACTION_TYPE ;; }

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
    label: "  * Is Warranty Order"
    description: "Yes if this order has a warranty replacement. Source:netsuite.sales_order"
    type: yesno
    sql: ${TABLE}.WARRANTY_CLAIM_ID is not null or ${TABLE}.warranty = 'T' ;; }

  dimension: manna_transmission {
    label: "Manna Transmission"
    hidden: yes
    description: "At the sales header level this is confirmation/acceptance from manna to netsuite that they will start the process of fulfillment.
      Source: netsuite.sales_order"
    view_label: "Fulfillment"
    type: date
    sql: ${TABLE}.manna_transmission ;; }

  measure: manna_transmission_Average {
    view_label: "Fulfillment"
    group_label: "Average Days:"
    label: "to Manna Transmission"
    description: "Finds the average time elapsed between Order Date and Manna Transmission Date
      Source:netsuite.sales_order"
    drill_fields: [sales_order_line.fulfillment_details]
    type: average
    sql:  DateDiff('Day',${TABLE}.CREATED,${TABLE}.manna_transmission) ;; }

  dimension: manna_transmission_succ {
    label: "Is 3PL Transmission Success"
    hidden: yes
    description: "Yes if an order has successfully transmitted to 3PL. Source: netsuite.sales_order"
    view_label: "Fulfillment"
    type: yesno
    sql: ${TABLE}.IS_3PL_TRANSMISSION_SUCCESS = '1';; }

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
    label: "Retail Location ID"
    description: "Netsuite retail store ID. Source: netsuite.sales_order"
    group_label: " Advanced"
    view_label: "Sales Order"
    type: string
    sql: ${TABLE}.showroom_name ;;
    hidden: yes
  }
dimension: store_name{
  label: "Deprecated Location Name"
  hidden: yes
  description: "Owned Retail Location Name. Manually grouped from Location ID. Source: netsuite.sales_order"
  view_label: "Owned Retail"
  type: string
  sql: case when ${store_id} = 'CA-01' then 'San Diego'
  when ${store_id} = 'CA-02' then 'Santa Clara'
  when ${store_id} = 'CA-03' then 'Santa Monica'
  when ${store_id} = 'WA-01' then 'Seattle'
  when ${store_id} in ('FO-01','FO_01') then 'Salt Lake'
  when ${store_id} = 'UT-01' then 'Lehi'
  when ${store_id} = 'TX-01' then 'Austin'
  when ${store_id} = 'VA-01' then 'Tysons'
  when ${store_id} = 'WA-02' then  'Lynnwood'
  when ${store_id} = 'OH-01' then  'Columbus'
  else ${store_id} end;;
}

  dimension: date_diff_yoy {
    hidden:  yes
    description: "Used as a filter to compare periods of time to the same time period last year only (doesn't work for 2 years ago). Ex. - Last 90 days this year to those days last year
      Source: netsuite.sales_order"
    group_label: " Advanced"
    view_label: "Sales Order"
    type: number
    sql:datediff(day
      ,case when datediff(day,${created},current_date()) > 270 then dateadd(year,1,${created}) else ${created} end
      ,current_date());;
    }


  dimension: before_after_mattress_price_increase {
    group_label: " Advanced"
    label: "Before or after mattress price increase"
    description: "30 days before or after the mattress price increase on 7/15/2020"
    hidden: no
    type: string
    sql: case when ${TABLE}.CREATED between '2020-06-14' and '2020-07-14' then 'Before'
              when ${TABLE}.CREATED between '2020-07-15' and '2020-08-14' then 'After'
              else 'Other'
              end ;;
    }
}
