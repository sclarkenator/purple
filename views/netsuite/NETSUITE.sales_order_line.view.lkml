view: sales_order_line {
  sql_table_name: SALES.SALES_ORDER_LINE ;;

  dimension: payment_method {
    hidden: yes
    view_label: "Sales Order"
    group_label: " Advanced"
    label: "Payment Method"
    description: "Blank is no special cirumstance.  Values include Affirm, Progressive, Paypal, etc"
    type: string
    sql: sales_order.payment_method ;;
  }

  dimension: item_order{
    type: string
    primary_key:  yes
    hidden:  yes
    sql: ${TABLE}.item_id||'-'||${TABLE}.order_id||'-'||${TABLE}.system ;; }

  measure: avg_cost {
    hidden: yes
    label:  "Avgerage Cost ($)"
    description:  "Average unit cost, only valid looking at item-level data"
    type: average
    value_format_name: decimal_2
    sql:  ${TABLE}.estimated_Cost ;; }

  measure: total_estimated_cost {
    hidden: yes
    label: "Estimated Costs ($)"
    description: "Estimated cost value from NetSuite for the cost of materials"
    type: sum
  drill_fields: [order_id, sales_order.tranid, created_date, SLA_Target_date,sales_order.minimum_ship_date ,item.product_description, location, sales_order.source, total_units,gross_amt]
    value_format: "$#,##0.00"
    sql: ${TABLE}.estimated_Cost;; }

  measure: total_gross_Amt {
    group_label: "Gross Sales"
    label:  "Gross Sales ($0.k)"
    description:  "Total the customer paid, excluding tax and freight, in $K"
    type: sum
   drill_fields: [order_id, sales_order.tranid, created_date, SLA_Target_date,sales_order.minimum_ship_date ,item.product_description,carrier, location, sales_order.source, total_units,gross_amt]
    value_format: "$#,##0,\" K\""
    sql:  ${TABLE}.gross_amt ;; }

  measure: total_gross_Amt_non_rounded {
    group_label: "Gross Sales"
    label:  "Gross Sales ($)"
    description:  "Total the customer paid, excluding tax and freight, in $"
    type: sum
   drill_fields: [order_id, sales_order.tranid, created_date, SLA_Target_date,sales_order.minimum_ship_date ,item.product_description, location, sales_order.source, total_units,gross_amt]
    value_format: "$#,##0"
    sql:  ${TABLE}.gross_amt ;; }

  measure: gross_gross_Amt {
    hidden:  yes
    label:  "Gross-Gross Sales ($0.k)"
    description:  "Total the customer paid plus value of discounts they received, excluding tax and freight"
    type: sum
   drill_fields: [order_id, sales_order.tranid, created_date, SLA_Target_date,sales_order.minimum_ship_date ,item.product_description, location, sales_order.source, total_units,gross_amt]
    value_format: "$#,##0,\" K\""
    sql:  ${TABLE}.gross_amt + ${TABLE}.discount_amt ;; }

  measure: total_discounts {
    label:  "Total Discounts ($)"
    value_format:"$#,##0"
    description:  "Total of all applied discounts when order was placed"
    type: sum
    sql:  ${TABLE}.discount_amt ;; }

  measure: avg_days_to_fulfill {
    group_label: "Average Days:"
    label: "to Fulfillment"
    description: "Average number of days between order and fulfillment"
    view_label: "Fulfillment"
    type:  average_distinct
    value_format: "#.0"
    sql_distinct_key: ${fulfillment.PK};;
    sql: datediff(day,${TABLE}.created,${fulfilled_raw}) ;; }

  measure: mf_fulfilled {
    view_label: "Fulfillment"
    label: "Mattress Firm SLA (numerator)"
    hidden: yes
    description: "Total units successfully fulfilled before the ship by date"
    filters: {
      field: sales_order.customer_id
      value: "2662" }
    type: sum
    sql:  case when ${fulfilled_date} <= ${sales_order.ship_by_date} then ${ordered_qty} else 0 end ;; }

  measure: mf_units {
    view_label: "Fulfillment"
    label: "Mattress Firm SLA (denominator)"
    hidden: yes
    description: "Total units not cancelled before the ship by date"
    filters: {
      field: sales_order.customer_id
      value: "2662" }
    type: sum
    sql: case when ${cancelled_order.cancelled_date} is null or (${cancelled_order.cancelled_date} >  ${sales_order.ship_by_date}) then ${ordered_qty} else 0 end ;;  }

  measure: mf_on_time {
    view_label: "Fulfillment"
    group_label: "SLA"
    label: "Mattress Firm Shipped on Time (% of units)"
    description: "Percent of units that  shipped out by the required ship-by date to arrive to Mattress Firm on time (mf fulfilled/mf units)"
    value_format_name: percent_0
    type: number
    sql: ${mf_fulfilled}/nullif(${mf_units},0) ;; }

  measure: whlsl_fulfilled {
    view_label: "Fulfillment"
    label: "Wholesale SLA (old)"
    hidden: yes
    description: "Was the order shipped out by the required ship-by date to arrive on time"
    type: sum_distinct
    sql_distinct_key: ${pk_concat_ful_sales_order} ;;
    sql:  case when ${fulfilled_date} <= ${sales_order.ship_by_date} then ${ordered_qty} else 0 end ;; }

  dimension: Due_Date_old {
    view_label: "Fulfillment"
    hidden: yes
    type: date
    sql: Case
          When sales_order.channel_id <> 2 THEN
            Case
              When upper(${carrier}) not in ('XPO','MANNA','PILOT') THEN
              Case When sales_order.minimum_ship is null Then dateadd(d,3,${created_date})
               Else
                 Case
                     When sales_order.minimum_ship = ${created_date} THEN dateadd(d,3,sales_order.minimum_ship)
                      Else sales_order.minimum_ship
                  END
                  END
               Else dateadd(d,14,${created_date})
            END
          WHEN sales_order.channel_id = 2 THEN Case When sales_order.SHIP_BY is not null Then sales_order.SHIP_BY Else dateadd(d,3,${created_date}) END
          Else dateadd(d,3,${created_date})
        END
              ;;
  }

  dimension: Due_Date {
    view_label: "Fulfillment"
    hidden: yes
    type: date
    sql: case
      -- wholesale is ship by date (from sales order)
      WHEN ${sales_order.channel_id} = 2 and ${sales_order.ship_by_date} is not null
        THEN ${sales_order.ship_by_date}
      -- fedex is min ship date
      WHEN ${sales_order.channel_id} <> 2 and upper(${carrier}) not in ('XPO','MANNA','PILOT') and ${sales_order.minimum_ship_date} > ${created_date}
        THEN ${sales_order.minimum_ship_date}
      -- fedex without min ship date is created + 3
      WHEN ${sales_order.channel_id} <> 2 and upper(${carrier}) not in ('XPO','MANNA','PILOT')
        THEN dateadd(d,3,${created_date})
      --whiteglove is created + 14
      WHEN ${sales_order.channel_id} <> 2 and upper(${carrier}) in ('XPO','MANNA','PILOT')
        THEN dateadd(d,14,${created_date})
      --catch all is creatd +3
      Else dateadd(d,3,${created_date}) END ;;
  }

  dimension: due_date_dif_flag {
    hidden: yes
    type: yesno
    sql: ${Due_Date_old}=${Due_Date}  ;;
  }

dimension_group: SLA_Target {
  label: "SLA Target"
  view_label: "Fulfillment"
  type: time
  timeframes: [raw, date, day_of_week, day_of_month, week, week_of_year, month, month_name, quarter, quarter_of_year, year]
  convert_tz: no
  datatype: timestamp
  sql: to_timestamp_ntz(${Due_Date}) ;;
}

dimension: SLA_Buckets {
  group_label: " Advanced"
  label: "Days Past SLA Target Buckets"
  view_label: "Fulfillment"
  description: "# days in realtion to Target date"
  type: tier
  style: integer
  tiers: [1,2,3,4,5,6,7,11,15,21]
  sql: datediff(d,${SLA_Target_date},current_date) ;;
}

  dimension: sla_Before_today{
    group_label: "SLA Target Date"
    view_label: "Fulfillment"
    label: "z - Is Before Today (mtd)"
    type: yesno
    sql: ${Due_Date}::date < current_date;; }

  dimension: sla_current_week_num{
    group_label: "SLA Target Date"
    view_label: "Fulfillment"
    label: "z - Before Current Week"
    type: yesno
    sql: date_part('week',${Due_Date}::date) < date_part('week',current_date);; }

  dimension: sla_prev_week{
    group_label: "SLA Target Date"
    view_label: "Fulfillment"
    label: "z - Previous Week"
    type: yesno
    sql: date_part('week',${Due_Date}::date) = date_part('week',current_date)-1;; }

  measure: sales_eligible_for_SLA{
    label: "zQty Eligible SLA"
    hidden:  yes
    view_label: "Fulfillment"
    type: sum_distinct
    sql_distinct_key: ${pk_concat} ;;
    sql: CASE
            WHEN ${cancelled_order.cancelled_date} is null THEN ${TABLE}.gross_amt
            WHEN ${cancelled_order.cancelled_date} > ${SLA_Target_date} THEN ${TABLE}.gross_amt
            WHEN ${cancelled_order.cancelled_date} >= ${fulfilled_date} THEN ${TABLE}.gross_amt
            ELSE 0
          END;;
  }

  measure: sales_Fulfilled_in_SLA{
    label: "zQty Fulfilled in SLA"
    view_label: "Fulfillment"
    hidden:  yes
    type: sum_distinct
    sql_distinct_key: ${pk_concat} ;;
    sql: Case
          when ${cancelled_order.cancelled_date} < ${fulfilled_date} Then 0
          Else
            case
              when ${fulfilled_date} <= ${Due_Date} THEN ${gross_amt}
              Else 0
            END
        END;;
  }

  measure: zSLA_Achievement_prct {
    view_label: "Fulfillment"
    group_label: "SLA"
    label: "SLA $ Achievement %"
    hidden: no
    value_format_name: percent_1
    type: number
    drill_fields: [customer_table.customer_id ,order_id, sales_order.tranid, created_date, sales_order.ship_by_date,sales_order.minimum_ship_date,fulfilled_date, SLA_Target_date ,item.product_description,Qty_Fulfilled_in_SLA ,total_units,SLA_Achievement_prct]
    sql: Case when ${sales_eligible_for_SLA} = 0 then 0 Else ${sales_Fulfilled_in_SLA}/${sales_eligible_for_SLA} End ;;
  }

  dimension: pk_concat_ful_sales_order {
    hidden: yes
    type: string
    sql:  NVL(${fulfillment.PK},'_')||'_'||NVL(${item_order},'_');;
  }

  dimension: pk_concat {
    hidden: yes
    type: string
    sql:  NVL(${fulfillment.PK},'_')||'_'||NVL(${cancelled_order.item_order},'_')||'_'||NVL(${item_order},'_');;
  }

  measure: Qty_eligible_for_SLA{
    label: "Qty Eligible SLA"
    group_label: "SLA"
    view_label: "Fulfillment"
    type: sum_distinct
    sql_distinct_key: ${pk_concat} ;;
    sql: Case
            when ${cancelled_order.cancelled_date} is null THEN ${ordered_qty}
            When ${cancelled_order.cancelled_date} < ${SLA_Target_date} THEN 0
            WHEN ${cancelled_order.cancelled_date} > ${SLA_Target_date} THEN ${ordered_qty}
            WHEN ${cancelled_order.cancelled_date} >= ${fulfilled_date} THEN ${ordered_qty}
            Else 0
            END ;;
  }

measure: Qty_Fulfilled_in_SLA{
  label: "Qty Fulfilled in SLA"
  group_label: "SLA"
  view_label: "Fulfillment"
  type: sum_distinct
  sql_distinct_key: ${pk_concat} ;;
  sql: Case
        when ${cancelled_order.cancelled_date} < ${fulfilled_date} Then 0
        when ${fulfilled_date} <= ${Due_Date} THEN ${ordered_qty}
        Else 0
      END ;;
}

dimension: SLA_fulfilled {
    label: "     * Is SLA fulfilled"
    description: "Was item fulfilled in SLA window"
    view_label: "Fulfillment"
    type: yesno
    sql: ${cancelled_order.cancelled_date} >= ${fulfilled_date} AND ${fulfilled_date} <= ${Due_Date} ;;
  }

  measure: SLA_Achievement_prct {
  view_label: "Fulfillment"
  label: "SLA Achievement %"
  group_label: "SLA"
  hidden: no
  value_format_name: percent_1
  type: number
  drill_fields: [customer_table.customer_id ,order_id, sales_order.tranid, created_date, sales_order.ship_by_date,sales_order.minimum_ship_date,fulfilled_date, SLA_Target_date ,item.product_description,Qty_Fulfilled_in_SLA ,total_units,SLA_Achievement_prct]
  sql: Case when ${Qty_eligible_for_SLA} = 0 then 0 Else ${Qty_Fulfilled_in_SLA}/${Qty_eligible_for_SLA} End ;;
}

  measure: whlsl_units {
    view_label: "Fulfillment"
    label: "Wholesale SLA (units)"
    hidden: yes
    description: "How many items are there on the order to be shipped?"
    type: sum
    sql: case when ${cancelled_order.cancelled_date} is null or (${cancelled_order.cancelled_date} >  ${sales_order.ship_by_date}) then ${ordered_qty} else 0 end ;; }

  measure: whlsl_on_time {
    view_label: "Fulfillment"
    group_label: "SLA"
    label: "Wholesale Shipped on Time (% of units)"
    description: "Percent of units shipped out by the required ship-by date to arrive on time (Wholesale fulfilled/Wholesale units)"
    value_format_name: percent_0
    type: number
    sql: ${whlsl_fulfilled}/nullif(${whlsl_units},0) ;; }

    measure: amazon_ca_sales {
    label: "Amazon-CA Gross Amount ($0.k)"
    description: "used to generate the sales by channel report"
    hidden: yes
    value_format: "$#,##0,\" K\""
    type: sum
    sql: case when ${sales_order.channel_source} = 'AMAZON-CA' then ${TABLE}.gross_amt else 0 end ;; }

  measure: amazon_us_sales {
    label: "Amazon-US Gross Amount ($0.k)"
    description: "used to generate the sales by channel report"
    hidden: yes
    value_format: "$#,##0,\" K\""
    type: sum
    sql: case when ${sales_order.channel_source} = 'AMAZON-US' then ${TABLE}.gross_amt else 0 end ;; }

  measure: shopify_ca_sales {
    label: "Shopify-CA Gross Amount ($0.k)"
    description: "used to generate the sales by channel report"
    hidden: yes
    value_format: "$#,##0,\" K\""
    type: sum
    sql: case when ${sales_order.channel_source} = 'SHOPIFY-CA' then ${TABLE}.gross_amt else 0 end ;; }

  measure: shopify_us_sales {
    label: "Shopify-US GrossAmount ($0.k)"
    description: "US Shopify gross sales as reported in Netsuite"
    hidden: yes
    value_format: "$#,##0,\" K\""
    type: sum
    sql: case when ${sales_order.channel_source} = 'SHOPIFY-US' then ${TABLE}.gross_amt else 0 end ;; }

  measure: unfulfilled_orders {
    group_label: "Gross Sales Unfulfilled"
    label: "Unfulfilled Units ($)"
    view_label: "Fulfillment"
    description: "Orders placed that have not been fulfilled"
    value_format: "$#,##0"
    type: number
    #sql_distinct_key: ${pk_concat_ful_sales_order};;
    drill_fields: [order_id, sales_order.tranid, created_date, SLA_Target_date,sales_order.minimum_ship_date ,item.product_description, location, sales_order.source, total_units,gross_amt,fulfilled_orders,unfulfilled_orders]
    sql: (${total_gross_Amt}/nullif(${total_units},0))*(${total_units}-${fulfillment.count}) ;; }

  measure: unfulfilled_orders_units {
    group_label: "Gross Sales Unfulfilled"
    view_label: "Fulfillment"
    label: "Unfulfilled Orders (units)"
    description: "Orders placed that have not been fulfilled"
    type: number
    #sql_distinct_key: ${pk_concat_ful_sales_order};;
    drill_fields: [order_id, sales_order.tranid, created_date, SLA_Target_date,sales_order.minimum_ship_date ,item.product_description, location, sales_order.source, total_units,gross_amt,fulfilled_orders_units,unfulfilled_orders_units]
    sql: ${total_units}-${fulfillment.count} ;;}

  measure: fulfilled_orders {
    group_label: "Gross Sales Fulfilled"
    view_label: "Fulfillment"
    label: "Fulfilled Orders ($)"
    description: "Orders placed that have been fulfilled"
    value_format: "$#,##0"
    type: number
    #sql_distinct_key: ${pk_concat_ful_sales_order};;
    drill_fields: [order_id, sales_order.tranid, created_date, SLA_Target_date,sales_order.minimum_ship_date ,item.product_description, location, sales_order.source, total_units,gross_amt,fulfilled_orders,unfulfilled_orders]
    sql: (${total_gross_Amt}/nullif(${total_units},0))*(${fulfillment.count}) ;; }

  measure: fulfilled_orders_units {
    group_label: "Gross Sales Fulfilled"
    view_label: "Fulfillment"
    label: "Fulfilled Orders (units)"
    description: "Orders placed that have been fulfilled"
    type: number
    #sql_distinct_key: ${pk_concat_ful_sales_order};;
    drill_fields: [order_id, sales_order.tranid, created_date, SLA_Target_date,sales_order.minimum_ship_date ,item.product_description, location, sales_order.source, total_units,gross_amt,fulfilled_orders_units,unfulfilled_orders_units]
    sql: ${fulfillment.count} ;; }

  measure: fulfilled_in_SLA {
    view_label: "Fulfillment"
    label: "West Fulfillment SLA"
    hidden: yes
    description: "Was the order fulfilled from Purple West within 3 days of order (as per website)?"
    filters: {
      field: carrier
      value: "-Pilot,-XPO" }
    filters: {
      field: sales_order.channel_source
      value: "SHOPIFY%" }
##    filters: {
##      field: sales_order.channel_id
##      value: "1" }
      drill_fields: [fulfill_details*]
      type: sum
      sql:  case when ${fulfilled_date} <= to_Date(dateadd(d,3,${TABLE}.created)) then ${ordered_qty} else 0 end ;; }

  measure: SLA_eligible {
    label: "WEST SLA Eligible (3)"
    description: "Was this line item available to fulfill (not cancelled) within the SLA window?"
    view_label: "Fulfillment"
    hidden: yes
    filters: {
      field: carrier
      value: "-Pilot,-XPO" }
    filters: {
      field: sales_order.channel_source
      value: "SHOPIFY%" }
##    filters: {
##      field: sales_order.channel_id
##      value: "1" }
      type:  sum
      sql: case when ${cancelled_order.cancelled_date} is null or to_Date(${cancelled_order.cancelled_date}) > to_date(dateadd(d,3,${created_date})) then ${ordered_qty} else 0 end ;; }

  measure: SLA_achieved{
    label: "West SLA Achievement (% in 3 days)"
    hidden: yes
    description: "Percent of line items fulfilled by Purple West within 3 days of order"
    view_label: "Fulfillment"
    group_label: "SLA"
    type: number
    drill_fields: [customer_table.customer_id ,order_id, sales_order.tranid, created_date, sales_order.ship_by_date, fulfilled_date, SLA_Target_date ,item.product_description,Qty_Fulfilled_in_SLA ,total_units,SLA_Achievement_prct]
    value_format_name: percent_1
    sql: case when datediff(day,${created_date},current_date) < 4 then null else ${fulfilled_in_SLA}/nullif(${SLA_eligible},0) end ;; }

  measure: manna_fulfilled_in_SLA {
      view_label: "Fulfillment"
      label: "Pilot Fulfillment SLA"
      hidden: yes
      description: "Was this item fulfilled from Manna within 14 days of order (as per website)?"
      filters: {
        field: carrier
        value: "Pilot,Manna" }
      filters: {
        field: sales_order.channel_source
        value: "SHOPIFY%" }
##    filters: {
##      field: sales_order.channel_id
##      value: "1" }
        drill_fields: [fulfill_details*]
        type: sum
        sql:  case when ${fulfilled_date} <= to_Date(dateadd(d,14,${TABLE}.created)) then ${ordered_qty} else 0 end ;; }

  measure: manna_SLA_eligible {
    label: "Pilot SLA Eligible (14)"
    description: "Was this Manna line item available to fulfill (not cancelled) within the SLA window?"
    view_label: "Fulfillment"
    hidden: yes
    filters: {
      field: carrier
      value: "Pilot,Manna" }
    filters: {
      field: sales_order.channel_source
      value: "SHOPIFY%" }
##    filters: {
##      field: sales_order.channel_id
##      value: "1" }
      type:  sum
      sql: case when ${cancelled_order.cancelled_date} is null or to_Date(${cancelled_order.cancelled_date}) >= to_Date(dateadd(d,14,${created_date})) then ${ordered_qty} else 0 end ;; }

  measure: manna_fulfilled_in_SLA_14days {
    view_label: "Fulfillment"
    label: "Pilot Fulfillment SLA"
    hidden: yes
    description: "Was this item fulfilled from Manna within 14 days of order (as per website)?"
    filters: {
      field: carrier
      value: "Pilot,Manna" }
    filters: {
      field: sales_order.channel_source
      value: "SHOPIFY%" }
##    filters: {
##      field: sales_order.channel_id
##      value: "1" }
      drill_fields: [fulfill_details*]
      type: sum
      sql:
      case
        when datediff(day,${created_date},current_date) > 14
          AND ${fulfilled_date} <= to_Date(dateadd(d,14,${TABLE}.created))
          then ${ordered_qty}
        else 0
      end ;; }

  measure: manna_SLA_eligible_14days {
    label: "Pilot SLA Eligible (14)"
    description: "Was this Manna line item available to fulfill (not cancelled) within the SLA window?"
    view_label: "Fulfillment"
    hidden: yes
    filters: {
      field: carrier
      value: "Pilot,Manna" }
    filters: {
      field: sales_order.channel_source
      value: "SHOPIFY%" }
##    filters: {
##      field: sales_order.channel_id
##      value: "1" }
      type:  sum
      sql:
        case
          when datediff(day,${created_date},current_date) > 14
            AND ${cancelled_order.cancelled_date} is null
            or to_Date(${cancelled_order.cancelled_date}) >= to_Date(dateadd(d,14,${created_date}))
            then ${ordered_qty}
          else 0
        end ;; }

  measure: manna_sla_achieved{
    label: "Pilot SLA Achievement (% in 14 days)"
    view_label: "Fulfillment"
    group_label: "SLA"
    hidden: no
    description: "Percent of line items fulfilled by Manna within 14 days of order"
    type: number
    drill_fields: [customer_table.customer_id ,order_id, sales_order.tranid, created_date, sales_order.ship_by_date, fulfilled_date, SLA_Target_date ,item.product_description,Qty_Fulfilled_in_SLA ,total_units,SLA_Achievement_prct]
    value_format_name: percent_1
    sql:${manna_fulfilled_in_SLA_14days}/nullif(${manna_SLA_eligible_14days},0) ;; }

  measure: XPO_fulfilled_in_SLA {
    view_label: "Fulfillment"
    label: "XPO Fulfillment SLA"
    hidden: yes
    description: "Was this item fulfilled from Manna within 14 days of order (as per website)?"
    filters: {
      field: carrier
      value: "XPO" }
    filters: {
      field: sales_order.channel_source
      value: "SHOPIFY%" }
##    filters: {
##      field: sales_order.channel_id
##      value: "1" }
      drill_fields: [fulfill_details*]
      type: sum
      sql:  case when ${fulfilled_date} <= to_Date(dateadd(d,14,${TABLE}.created)) and ${cancelled_order.cancelled_date} is null then ${ordered_qty} else 0 end ;; }

  measure: XPO_SLA_eligible {
    label: "Manna SLA Eligible (14)"
    description: "Was this Manna line item available to fulfill (not cancelled) within the SLA window?"
    view_label: "Fulfillment"
    hidden: yes
    filters: {
      field: carrier
      value: "XPO" }
    filters: {
      field: sales_order.channel_source
      value: "SHOPIFY%" }
##    filters: {
##      field: sales_order.channel_id
##      value: "1" }
      type:  sum
      sql: case when ${cancelled_order.cancelled_date} is null or to_Date(${cancelled_order.cancelled_date}) > to_Date(dateadd(d,14,${created_date})) then ${ordered_qty} else 0 end ;; }

  measure: xpo_sla_achieved{
    label: "XPO SLA Achievement (% in 14 days)"
    view_label: "Fulfillment"
    group_label: "SLA"
    description: "Percent of line items fulfilled by Manna within 1 days of order"
    type: number
    drill_fields: [customer_table.customer_id ,order_id, sales_order.tranid, created_date, sales_order.ship_by_date, fulfilled_date, SLA_Target_date ,item.product_description,Qty_Fulfilled_in_SLA ,total_units,SLA_Achievement_prct]
    value_format_name: percent_1
    sql: case when datediff(day,${created_date},current_date) > 14 then ${XPO_fulfilled_in_SLA}/nullif(${XPO_SLA_eligible},0) else null end ;; }

  measure: total_line_item {
  label: "Total Line Items"
    description: "Total line items to fulfill"
    hidden: yes
    type: count_distinct
    sql:  ${item_order} ;; }

  measure: return_rate_units {
    group_label: "Return Rates"
    label: "Return Rate (% of units)"
    description: "Units returned/Units fulfilled"
    view_label: "Returns"
    type: number
    sql: ${return_order_line.units_returned} / nullif(${total_units},0) ;;
    value_format_name: "percent_1" }

  measure: return_rate_dollars {
    group_label: "Return Rates"
    label: "Return Rate (% of $)"
    description: "Total $ returned / Total $ fulfilled"
    view_label: "Returns"
    type: number
    sql: ${return_order_line.total_gross_amt} / nullif(${total_gross_Amt},0) ;;
    value_format_name: "percent_1" }

  measure: total_units {
    group_label: "Gross Sales"
    label:  "Gross Sales (units)"
    description: "Total units purchased, before returns and cancellations"
    type: sum
    drill_fields: [order_id, sales_order.tranid, created_date, SLA_Target_date,sales_order.minimum_ship_date ,item.product_description, location, sales_order.source, total_units,gross_amt]
    sql:  ${TABLE}.ordered_qty ;; }

  dimension: total_units_dem {
    group_label: " Advanced"
    label:  "Gross Sales (units) (dimension version)"
    description: "Dimension version: Total units purchased, before returns and cancellations"
    type: number
    drill_fields: [order_id, sales_order.tranid, created_date, SLA_Target_date,sales_order.minimum_ship_date ,item.product_description, location, sales_order.source, total_units,gross_amt]
    sql:  ${TABLE}.ordered_qty ;; }

  measure: total_standard_cost {
    #hidden: yes
    label: "Total Standard Cost"
    description: "Total Cost (cost per unit * number of units)"
    group_label: "Product"
    type:  sum
    value_format: "$#,##0"
    sql:  ${TABLE}.ordered_qty * ${standard_cost.standard_cost} ;;
  }

  measure: dates{
    label: "Count of Days"
    hidden:  yes
    type: count_distinct
    sql: ${TABLE}.Created::date ;; }

dimension: has_standard_cost {
  label: "    * Has Standard Cost"
  type: yesno
  description: "Data exists for what it costs Purple to make the product"
  sql: ${standard_cost.standard_cost} is not null ;; }

dimension: days_to_cancel {
  view_label: "Cancellations"
  label: "# days from order"
  description: "Number of days after initial order was placed that the order was cancelled. 0 means the order was cancelled on the day it was placed"
  type: tier
  style: integer
  hidden:  yes
  tiers: [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28]
  sql: datediff(d,${created_date},${cancelled_order.cancelled_date}) ;; }

  dimension: order_age_bucket {
    view_label: "Fulfillment"
    group_label: " Advanced"
    label: "  Order Age (bucket)"
    description: "Number of days between today and when order was placed (1,2,3,4,5,6,7,11,15,21)"
    type:  tier
    tiers: [1,2,3,4,5,6,7,11,15,21]
    style: integer
    sql: datediff(day,
      case when ${sales_order.minimum_ship_date} > coalesce(dateadd(d,-3,${sales_order.ship_by_date}), ${created_date}) and ${sales_order.minimum_ship_date} > ${created_date} then ${sales_order.minimum_ship_date}
        when dateadd(d,-3,${sales_order.ship_by_date}) > coalesce(${sales_order.minimum_ship_date}, ${created_date}) and dateadd(d,-3,${sales_order.ship_by_date}) > ${created_date} then ${sales_order.ship_by_date}
        else ${created_date} end
      , current_date) ;; }
    #sql: datediff(day,coalesce(dateadd(d,-3,${sales_order.ship_by_date}),${created_date}),current_date) ;; }

  dimension: order_age_bucket2 {
    view_label: "Fulfillment"
    group_label: " Advanced"
    label: "  Order Age (bucket 2)"
    hidden: yes
    description: "Number of days between today and when order was placed (1,2,3,4,5,6,7,11,15,21)"
    type:  tier
    tiers: [1,2,3,4,5,6,7,8,9,10,11,12,13,14,21,28]
    style: integer
    sql: datediff(day,
      case when ${sales_order.minimum_ship_date} > coalesce(dateadd(d,-3,${sales_order.ship_by_date}), ${created_date}) and ${sales_order.minimum_ship_date} > ${created_date} then ${sales_order.minimum_ship_date}
        when dateadd(d,-3,${sales_order.ship_by_date}) > coalesce(${sales_order.minimum_ship_date}, ${created_date}) and dateadd(d,-3,${sales_order.ship_by_date}) > ${created_date} then ${sales_order.ship_by_date}
        else ${created_date} end
      , current_date) ;; }
    #sql: datediff(day,coalesce(dateadd(d,-3,${sales_order.ship_by_date}),${created_date}),current_date) ;; }


  dimension: order_age_raw {
    label: "Order Age Raw"
    description: "Number of days between today and when order was placed"
    hidden:  yes
    type:  number
    sql: datediff(day,
      case when ${sales_order.minimum_ship_date} > coalesce(dateadd(d,-3,${sales_order.ship_by_date}), ${created_date}) and ${sales_order.minimum_ship_date} > ${created_date} then ${sales_order.minimum_ship_date}
        when dateadd(d,-3,${sales_order.ship_by_date}) > coalesce(${sales_order.minimum_ship_date}, ${created_date}) and dateadd(d,-3,${sales_order.ship_by_date}) > ${created_date} then ${sales_order.ship_by_date}
        else ${created_date} end
      , current_date) ;; }

  dimension: order_age_bucket_2 {
    label: "Order Age Orginal (bucket)"
    description: "Number of days between today and min ship date or when order was placed (1,2,3,4,5,6,7,14)"
    hidden: yes
    type:  tier
    tiers: [1,2,3,4,5,6,7,14]
    style: integer
    sql: datediff(day,${created_date},current_date) ;; }

  dimension: manna_order_age_bucket {
    view_label: "Fulfillment"
    label: "Manna Order Age (Bucket)"
    hidden: yes
    description: "Number of days between today and when order was placed for Manna (7,14,21,28,35,42)"
    type:  tier
    tiers: [7,14,21,28,35,42]
    style: integer
    sql: datediff(day,${created_date},current_date) ;; }


  dimension: before_today_flag {
    label:  "Is Before Today"
    hidden: yes
    #view_label:  "x - report filters"
    type: yesno
    sql: ${created_date}  < current_date ;; }

  dimension: yesterday_flag {
    label:  "Was Yesterday"
    hidden:  yes
    #view_label:  "x - report filters"
    type: yesno
    sql: ${created_date} = dateadd(d,-1,current_date) ;; }

  dimension: free_item {
    label: "     * Zero Dollar Items (promo/free)"
    description: "Yes if this item is free" #with purchase of mattress
    type: yesno
    sql: ((${pre_discount_amt} = ${discount_amt}) and ${discount_amt} <> 0) or (${gross_amt} = 0 and ${discount_amt} > 30)  ;; }

  dimension: discounted_item {
    label: "     * Is Discounted"
    description: "Yes if this item had any discount, including if free"
    type: yesno
    sql: (${discount_amt} > 0)  ;; }

  dimension: order_system {
        type: string
    primary_key:  no
    hidden:  yes
    sql: ${TABLE}.order_id||'-'||${TABLE}.system ;; }


  dimension: item_order_refund{
    type:  string
    hidden:  yes
    sql: ${TABLE}.item_id||'-'||${TABLE}.order_id||'-'||${TABLE}.system ;; }

  dimension: city {
    label: "City"
    group_label: "Customer Address"
    view_label: "Customer"
    hidden: yes
    type: string
    sql: ${TABLE}.CITY ;; }

  dimension: company_id {
    hidden: yes
    type: number
    sql: ${TABLE}.COMPANY_ID ;; }

  dimension: country {
    label: "Country"
    group_label: "Customer address"
    view_label: "Customer"
    hidden: yes
    type: string
    map_layer_name: countries
    sql: ${TABLE}.COUNTRY ;; }

  dimension: MTD_flg{
    group_label: "    Order Date"
    view_label: "Sales Order"
    label: "z - Is Before Today (mtd)"
    hidden:  yes
    description: "This field is for formatting on (week/month/quarter/year) to date reports"
    type: yesno
    sql: ${TABLE}.Created < current_date and month(${TABLE}.Created) = month(dateadd(day,-1,current_date)) and year(${TABLE}.Created) = year(current_date) ;; }

  dimension: Before_today{
    view_label: "Sales Order"
    group_label: "    Order Date"
    label: "z - Is Before Today (mtd)"
    #hidden:  yes
    description: "This field is for formatting on (week/month/quarter/year) to date reports"
    type: yesno
    sql: ${TABLE}.Created < current_date;; }

  dimension: week_bucket{
    view_label: "Sales Order"
      group_label: "    Order Date"
      label: "z - Week Bucket"
      description: "Grouping by week, for comparing last week, to the week before, to last year"
      type: string
      sql: case when date_part('year', ${TABLE}.Created::date) = date_part('year', current_date) and date_part('week',${TABLE}.Created::date) = date_part('week', current_date) then 'Current Week'
          when date_part('year', ${TABLE}.Created::date) = date_part('year', current_date) and date_part('week',${TABLE}.Created::date) = date_part('week', current_date) -1 then 'Last Week'
          when date_part('year', ${TABLE}.Created::date) = date_part('year', current_date) and date_part('week',${TABLE}.Created::date) = date_part('week', current_date) -2 then 'Two Weeks Ago'
          when date_part('year', ${TABLE}.Created::date) = date_part('year', current_date) -1 and date_part('week',${TABLE}.Created::date) = date_part('week', current_date) then 'Current Week LY'
          when date_part('year', ${TABLE}.Created::date) = date_part('year', current_date) -1 and date_part('week',${TABLE}.Created::date) = date_part('week', current_date) -1 then 'Last Week LY'
          when date_part('year', ${TABLE}.Created::date) = date_part('year', current_date) -1 and date_part('week',${TABLE}.Created::date) = date_part('week', current_date) -2 then 'Two Weeks Ago LY'
          else 'Other' end;; }

  dimension: Before_today_ly{
    view_label: "Sales Order"
    group_label: "    Order Date"
    label: "z - Is Before Today Last Year (mtd)"
    hidden:  yes
    type: yesno
    sql: ${TABLE}.Created < dateadd('year',-1,current_date);; }

  dimension: last_30{
    view_label: "Sales Order"
    group_label: "    Order Date"
    label: "z - Last 30 Days"
    #hidden:  yes
    description: "Yes/No for if the date is in the last 30 days"
    type: yesno
    sql: ${TABLE}.Created > dateadd(day,-30,current_date);; }

  dimension: current_week_num{
    view_label: "Sales Order"
    group_label: "    Order Date"
    label: "z - Before Current Week"
    #hidden:  yes
    description: "Yes/No for if the date is in the last 30 days"
    type: yesno
    sql: date_part('week',${TABLE}.Created) < date_part('week',current_date);; }

  dimension: prev_week{
    view_label: "Sales Order"
    group_label: "    Order Date"
    label: "z - Previous Week"
    #hidden:  yes
    description: "Yes/No for if the date is in the last 30 days"
    type: yesno
    sql: date_part('week',${TABLE}.Created) = date_part('week',current_date)-1;; }

  dimension: Shipping_Addresee{
    hidden:  yes
    description: "The name on the shipping address"
    type: string
    sql: ${TABLE}.Ship_company;; }

  dimension: MTD_fulfilled_flg{
    group_label: "    Fulfilled Date"
    label: "z - Month to Date (current year)"
    #hidden:  yes
    view_label: "Fulfillment"
    description: "This field is for formatting on (week/month/quarter/year) to date reports"
    type: yesno
    sql: ${fulfilled_raw}::date <= current_date and month(${fulfilled_raw}::date) = month(dateadd(day,-1,current_date)) and year(${fulfilled_raw}::date) = year(current_date) ;; }

  dimension: ff_Before_today{
    group_label: "    Fulfilled Date"
    view_label: "Fulfillment"
    label: "z - Is Before Today (mtd)"
    description: "This field is for formatting on (week/month/quarter/year) to date reports"
    type: yesno
    sql: ${fulfilled_raw}::date < current_date;; }

  dimension: ff_current_week_num{
    group_label: "    Fulfilled Date"
    view_label: "Fulfillment"
    label: "z - Before Current Week"
    description: "Yes/No for if the date is in the last 30 days"
    type: yesno
    sql: date_part('week',${fulfilled_raw}::date) < date_part('week',current_date);; }

  dimension: ff_prev_week{
    group_label: "    Fulfilled Date"
    view_label: "Fulfillment"
    label: "z - Previous Week"
    description: "Yes/No for if the date is in the last 30 days"
    type: yesno
    sql: date_part('week',${fulfilled_raw}::date) = date_part('week',current_date)-1;; }

  dimension: week_bucket_ff{
    group_label: "    Fulfilled Date"
    view_label: "Fulfillment"
    label: "z - Week Bucket"
    description: "Grouping by week, for comparing last week, to the week before, to last year"
    type: string
    sql: case when date_part('year', ${fulfilled_raw}::date) = date_part('year', current_date) and date_part('week',${fulfilled_raw}::date) = date_part('week', current_date) then 'Current Week'
        when date_part('year', ${fulfilled_raw}::date) = date_part('year', current_date) and date_part('week',${fulfilled_raw}::date) = date_part('week', current_date) -1 then 'Last Week'
        when date_part('year', ${fulfilled_raw}::date) = date_part('year', current_date) and date_part('week',${fulfilled_raw}::date) = date_part('week', current_date) -2 then 'Two Weeks Ago'
        when date_part('year', ${fulfilled_raw}::date) = date_part('year', current_date) -1 and date_part('week',${fulfilled_raw}::date) = date_part('week', current_date) then 'Current Week LY'
        when date_part('year', ${fulfilled_raw}::date) = date_part('year', current_date) -1 and date_part('week',${fulfilled_raw}::date) = date_part('week', current_date) -1 then 'Last Week LY'
        when date_part('year', ${fulfilled_raw}::date) = date_part('year', current_date) -1 and date_part('week',${fulfilled_raw}::date) = date_part('week', current_date) -2 then 'Two Weeks Ago LY'
        else 'Other' end;; }

  dimension_group: created {
    view_label: "Sales Order"
    label: "    Order"
    description:  "Time and date order was placed"
    type: time
    timeframes: [raw, hour_of_day, date, day_of_week, day_of_month, week, week_of_year, month, month_name, quarter, quarter_of_year, year]
    convert_tz: no
    datatype: timestamp
    sql: to_timestamp_ntz(${TABLE}.Created) ;; }

  dimension: day_of_week {
    hidden:  yes
    label:  "Day of Week"
    description: "Abbreviated day of week (Sun, Mon, Tue, etc)"
    type: string
    case: {
      when: { sql: ${created_day_of_week} = 'Sunday' ;; label: "Sun" }
      when: { sql: ${created_day_of_week} = 'Monday' ;; label: "Mon" }
      when: { sql: ${created_day_of_week} = 'Tuesday' ;;  label: "Tue" }
      when: { sql: ${created_day_of_week} = 'Wednesday' ;; label: "Wed" }
      when: { sql: ${created_day_of_week} = 'Thursday' ;; label: "Thu" }
      when: { sql: ${created_day_of_week} = 'Friday' ;; label: "Fri" }
      when: { sql: ${created_day_of_week} = 'Saturday' ;; label: "Sat" } } }

  parameter: timeframe_picker{
    label: "Date Granularity Sales"
    hidden: yes
    type: string
    allowed_value: { value: "Date"}
    allowed_value: { value: "Week"}
    allowed_value: { value: "Month"}
    default_value: "Date" }

  dimension: dynamic_timeframe {
    type: date
    allow_fill: no
    hidden: yes
    sql:
      CASE
      When {% parameter timeframe_picker %} = 'Date' Then ${created_date}
      When {% parameter timeframe_picker %} = 'Week' Then ${created_week}
      When {% parameter timeframe_picker %} = 'Month'Then ${created_month}||'-01'
      END;; }

  dimension: 7_day_window {
    hidden: yes
    type: yesno
    sql: datediff(d,${created_date},dateadd(d,-1,current_date)) < 7 ;; }

  dimension: 30_day_window {
    hidden: yes
    type: yesno
    sql: datediff(d,${created_date},dateadd(d,-1,current_date)) < 30 ;; }

  dimension: 60_day_window {
    hidden: yes
    type: yesno
    sql: datediff(d,${created_date},dateadd(d,-1,current_date)) < 60 ;; }

  dimension: 90_day_window {
    hidden: yes
    type: yesno
    sql: datediff(d,${created_date},dateadd(d,-1,current_date)) < 90 ;; }

  dimension: customer_age_bucket {
    label: "Customer Age Bucket"
    hidden: yes
    type: string
    sql:  case
        when datediff(months, to_date(${TABLE}.Created), current_date()) < 12 then '<12 mon'
        when datediff(months, to_date(${TABLE}.Created), current_date()) >= 12 and datediff(months, to_date(${TABLE}.Created), current_date()) < 18 then '12-18 mon'
        when datediff(months, to_date(${TABLE}.Created), current_date()) >= 18 and datediff(months, to_date(${TABLE}.Created), current_date()) < 24 then '18-24 mon'
        else '24+ mon'
        end ;;
  }

  measure: 7_day_sales {
    label: "7 Day Average (units)"
    description: "Units ordered in the last 7 days /7"
    #view_label: "Time-slice totals"
    hidden: yes
    type: sum
    value_format_name: decimal_0
    filters: {
      field: 7_day_window
      value: "yes" }
    sql: ${ordered_qty}/7 ;; }

  measure: 30_day_sales {
    label: "30 Day Average Sales (units)"
    description: "Units ordered in the last 30 days /30"
    #view_label: "Time-slice totals"
    hidden:  yes
    type: sum
    value_format_name: decimal_0
    filters: {
      field: 30_day_window
      value: "yes" }
    sql: ${ordered_qty}/30 ;; }

  measure: 60_day_sales {
    label: "60 Day Average Sales (units)"
    description: "Units ordered in the last 60 days /60"
    #view_label: "Time-slice totals"
    hidden: yes
    type: sum
    value_format_name: decimal_0
    filters: {
      field: 60_day_window
      value: "yes" }
    sql: ${ordered_qty}/60 ;; }

  measure: 90_day_sales {
    label: "90 Day Average Sales (units)"
    description: "Units ordered in the last 90 days /90"
    #view_label: "Time-slice totals"
    hidden:  yes
    type: sum
    value_format_name: decimal_0
    filters: {
      field: 90_day_window
      value: "yes" }
    sql: ${ordered_qty}/90 ;; }

  dimension: rolling_7day {
    label: "Is in Last 7 Day"
    #view_label:  "x - report filters"
    hidden: yes
    description: "Filter to show just most recent 7 completed days"
    type: yesno
    sql: ${created_date} between dateadd(d,-7,current_date) and dateadd(d,-1,current_date)  ;; }

  dimension:  4_week_filter {
    label: "Is in Last 4 Weeks"
    #view_label:  "x - report filters"
    hidden: yes
    type:  yesno
    sql: ${created_date} >=
      case when dayofweek(current_date) = 6 then dateadd(day,-27,current_date)
        when dayofweek(current_date) = 5 then dateadd(day,-26,current_date)
        when dayofweek(current_date) = 4 then dateadd(day,-25,current_date)
        when dayofweek(current_date) = 3 then dateadd(day,-24,current_date)
        when dayofweek(current_date) = 2 then dateadd(day,-23,current_date)
        when dayofweek(current_date) = 1 then dateadd(day,-22,current_date)
        else dateadd(day,-21,current_date) end   ;; }

  dimension: department_id {
    hidden: yes
    description: "Internal department IDs (accounting)"
    type: number
    sql: ${TABLE}.DEPARTMENT_ID ;; }

  dimension: discount_amt {
    hidden: yes
    description:  "Amount of discount to individual items applied at initial order"
    type: number
    sql: ${TABLE}.DISCOUNT_AMT ;; }

  dimension: discount_cancel_type {
    hidden: yes
    type: string
    sql: ${TABLE}.DISCOUNT_CANCEL_TYPE ;; }

  dimension: discount_code {
    hidden: yes
    type: string
    sql: ${TABLE}.DISCOUNT_CODE ;; }

  dimension: estimated_cost {
    hidden: yes
    label: "Estimated COGS"
    description: "Estimated COGS, excluding freight"
    type: number
    sql: ${TABLE}.ESTIMATED_COST ;; }

  dimension: retail_order_line_id {
    hidden:  yes
    label: "Shopify Order Line ID"
    description: "You can use this ID to look up orders in Shopify"
    type: string
    sql: ${TABLE}.ETAIL_ORDER_LINE_ID ;; }

  dimension_group: fulfilled {
    view_label: "Fulfillment"
    label: "    Fulfilled"
    description:  "Date item within order shipped for Fed-ex orders, date customer receives delivery from Manna or date order is on truck for wholesale"
    type: time
    timeframes: [raw,hour,date, day_of_week, day_of_month, week, week_of_year, month, month_name, quarter, quarter_of_year, year]
    convert_tz: no
    datatype: date
    sql: case when ${sales_order.transaction_type} = 'Cash Sale' then ${sales_order.created} else ${fulfillment.fulfilled_F_raw} end ;;
    }

  dimension_group: fulfilled_old {
    view_label: "Fulfillment"
    label: "    Fulfilled1"
    hidden:  yes
    description:  "Date item within order shipped for Fed-ex orders, date customer receives delivery from Manna or date order is on truck for wholesale"
    type: time
    timeframes: [raw,hour,date, day_of_week, day_of_month, week, week_of_year, month, month_name, quarter, quarter_of_year, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.FULFILLED ;;
    }

  dimension: is_fulfilled {
    view_label: "Fulfillment"
    label: "     * Is fulfilled"
    description:  "Has order been fulfilled"
    type: yesno
    sql: ${fulfilled_date} is not null;; }

  dimension: fulfilled_status {
    view_label: "Fulfillment"
    #hidden: yes
    label: "   Status"
    description: "Fulfillment status - On Time, Late, Open, Late (open)"
    type: string
    sql:
    CASE
    When ${SLA_Target_date} >= ${fulfilled_date} then 'On Time'
    When ${SLA_Target_date} < ${fulfilled_date} then 'Late'
    When ${fulfilled_date} is null and current_date() > ${SLA_Target_date} Then 'Late (open)'
    else 'Open'
    END;; }

  dimension: fulfillment_method {
    label: "Fulfillment Method"
    description: "Use Shipping Provider instead"
    view_label: "Fulfillment"
    hidden:  yes
    type: string
    sql: ${TABLE}.FULFILLMENT_METHOD ;; }

  dimension: insert_ts {
    hidden: yes
    type: string
    sql: ${TABLE}.INSERT_TS ;; }

  dimension: item_id {
    hidden:  yes
    type: number
    sql: ${TABLE}.ITEM_ID ;; }

  dimension: location {
    label:  "Fulfillment Warehouse"
    group_label: " Advanced"
    description:  "Warehouse that order was fulfilled out of"
    view_label: "Fulfillment"
    type: string
    sql: ${TABLE}.LOCATION ;; }

  dimension: memo {
    group_label: " Advanced"
    label:  "Memo"
    description:  "Notes field from the Shopify Draft Order Line"
    type: string
    sql: ${TABLE}.memo ;; }

  dimension: gross_amt {
    group_label: " Advanced"
    label: "Gross Sales Item Level ($)"
    description: "Gross sales is what the customer paid on initial order per sku, net of discounts, excluding tax, freight or other fees"
    type: number
    sql: ${TABLE}.gross_amt ;; }

  dimension: order_id {
    hidden: yes
    html: <a href = "https://system.na2.netsuite.com/app/accounting/transactions/salesord.nl?id={{value}}&whence=" target="_blank"> {{value}} </a> ;;
    description: "This is Netsuite's transaction ID. This will be a hyperlink to the sales order in Netsuite."
    type: number
    sql: ${TABLE}.ORDER_ID ;; }

  dimension: ordered_qty {
    hidden: yes
    description: "Gross Sales (units)"
    type: number
    sql: ${TABLE}.ORDERED_QTY ;; }

  dimension: pre_discount_amt {
    hidden:  yes
    label: "Pre-Discounted Price"
    description: "Price of item before any discounts or promotions are applied"
    type: number
    sql: ${TABLE}.PRE_DISCOUNT_AMT ;; }

  dimension: refund_link_id {
    hidden: yes
    type: number
    sql: ${TABLE}.REFUND_LINK_ID ;; }

  dimension: street_address {
    label: "Street Address"
    view_label: "Customer"
    group_label: "Customer Address"
    type: string
    sql: ${TABLE}.STREET_ADDRESS ;;
    required_access_grants:[can_view_pii] }

  dimension: system {
    hidden: yes
    label: "Source System"
    description: "This is the system the data came from"
    type: string
    sql: ${TABLE}.SYSTEM ;; }

 #dimension: tax_amt {
    #label: "Tax ($)"
    #description: "Tax Amount from Sales Line"
    #hidden: yes
    #type: number
    #sql: ${sales_order.TAX_AMT} ;; }

  dimension: update_ts {
    hidden: yes
    type: string
    sql: ${TABLE}.UPDATE_TS ;; }

  measure: Total_Average_Cost{
    hidden: yes
    type: sum
    description: "The average cost of the item at time of order creation."
    value_format: "$#,##0"
    sql: ${TABLE}.AVERAGE_COST ;; }

  measure: Qty_Picked {
    view_label: "Fulfillment"
    group_label: "By Status"
    label: "Picked (units)"
    type: sum
    drill_fields: [order_id, sales_order.tranid, created_date, SLA_Target_date,sales_order.minimum_ship_date ,item.product_description, location, sales_order.source, total_units,gross_amt]
    description: "The Qty of items that are in the picked state"
    sql: ${TABLE}.PICKED ;; }

  measure: Qty_Committed {
    view_label: "Fulfillment"
    group_label: "By Status"
    label: "Committed (units)"
    type: sum
   drill_fields: [order_id, sales_order.tranid, created_date, SLA_Target_date,sales_order.minimum_ship_date ,item.product_description, location, sales_order.source, total_units,gross_amt]
    description: "The Qty of items that are in the committed state"
    sql: ${TABLE}.QUANTITY_COMMITTED ;; }

  measure: Qty_Packed {
    view_label: "Fulfillment"
    group_label: "By Status"
    label: "Packed (units)"
    type: sum
   drill_fields: [order_id, sales_order.tranid, created_date, SLA_Target_date,sales_order.minimum_ship_date ,item.product_description, location, sales_order.source, total_units,gross_amt]
    description: "The Qty of items that are in the packed state"
    sql: ${TABLE}.PACKED ;; }

  dimension: zip {
    view_label: "Customer"
    group_label: "Customer Address"
    label: "Zipcode (5)"
    type: zipcode
    map_layer_name: us_zipcode_tabulation_areas
    sql: split_part(${TABLE}.ZIP,'-',1) ;; }

  dimension: zip_1 {
    view_label: "Geography"
    label: "Zipcode (5)"
    description: "5-digit ship-to zipcode"
    type: zipcode
    map_layer_name: us_zipcode_tabulation_areas
    sql: split_part(${TABLE}.ZIP,'-',1) ;; }

  dimension: carrier {
    view_label: "Fulfillment"
    label: "   Carrier (expected)"
    description: "Derived field based on fulfillment location."
    #hidden: yes
    type: string
    sql: case
          when ${location} ilike '%mainfreight%' then 'MainFreight'
          when ${location} ilike '%xpo%' then 'XPO'
          when ${location} ilike '%pilot%' then 'Pilot'
          when ${location} is null then 'FBA'
          when ${location} ilike '%100-%' then 'Purple'
          when ${location} ilike '%le store%' or ${location} ilike '%howroom%' then 'Store take-with'
          else 'Other' end ;;
    }

  dimension: DTC_carrier {
    view_label: "Fulfillment"
    group_label: " Advanced"
    label: "Carrier (Grouping)"
    description: "From Netsuite sales order line, the carrier field grouped into Purple, XPO, and Pilot"
    hidden: no
    type: string
    sql:  CASE WHEN upper(coalesce(${carrier},'')) not in ('XPO','MANNA','PILOT','MAINFREIGHT') THEN 'Purple' Else ${carrier} END;; }

  dimension: week_2019_start {
    hidden: yes
    group_label: "Created Date"
    label: "z - Week Start 2019"
    description: "Looking at the week of year for grouping (including all time) but only showing 2019 week start date."
    type: string
    sql: to_char( ${TABLE}.created,'MON-DD');; }


  dimension: line_shipping_method {
    hidden: no
    group_label: " Advanced"
    view_label: "Fulfillment"
    description: "Shipping method from shopify "
    type: string
    sql: ${TABLE}.line_shipping_method;; }

  dimension: IS_3PL_TRANSMIT_SUCCESS {
    hidden: yes
    type: string
    sql: ${TABLE}.IS_3PL_TRANSMIT_SUCCESS;; }

  dimension: TRANSMITTED_TO_ID {
    hidden: yes
    type: string
    sql: ${TABLE}.TRANSMITTED_TO_ID;; }


  measure: days_to_cancel_measure {
    view_label: "Cancellations"
    label: "      Avg days from order to cancellation"
    description: "Number of days after initial order was placed that the order was cancelled. 0 means the order was cancelled on the day it was placed"
    type: average
    sql: datediff(d,${created_date},${cancelled_order.cancelled_date}) ;; }




  set: fulfill_details {
    fields: [order_id,item_id,created_date,fulfilled_date] }
}
