include: "/views/netsuite/NETSUITE.sales_order_line_base.view.lkml"
view: sales_order_line {
  extends: [sales_order_line_base]

  dimension: payment_method {
    hidden: yes
    view_label: "Sales Order"
    group_label: " Advanced"
    label: "Payment Method"
    description: "Blank is no special cirumstance.  Values include Affirm, Progressive, Paypal, etc"
    type: string
    sql: sales_order.payment_method ;;
  }

  measure: avg_days_to_fulfill {
    group_label: "Average Days:"
    label: "to Fulfillment"
    description: "Average number of days between order and fulfillment"
    view_label: "Fulfillment"
    type:  average_distinct
    value_format: "#.0"
    sql_distinct_key: ${fulfillment.PK};;
    sql: datediff(day,${TABLE}.created,${fulfilled_raw}) ;;
  }

  measure: mf_fulfilled {
    view_label: "Fulfillment"
    label: "Mattress Firm SLA (numerator)"
    hidden: yes
    description: "Total units successfully fulfilled before the ship by date"
    filters: {
      field: sales_order.customer_id
      value: "2662" }
    type: sum
    sql:  case when ${fulfilled_date} <= ${sales_order.ship_by_date} then ${ordered_qty} else 0 end ;;
  }

  measure: mf_units {
    view_label: "Fulfillment"
    label: "Mattress Firm SLA (denominator)"
    hidden: yes
    description: "Total units not cancelled before the ship by date"
    filters: {
      field: sales_order.customer_id
      value: "2662" }
    type: sum
    sql: case when ${cancelled_order.cancelled_date} is null or (${cancelled_order.cancelled_date} >  ${sales_order.ship_by_date}) then ${ordered_qty} else 0 end ;;
  }

  measure: mf_on_time {
    view_label: "Fulfillment"
    group_label: "SLA"
    label: "Mattress Firm Shipped on Time (% of units)"
    description: "Percent of units that  shipped out by the required ship-by date to arrive to Mattress Firm on time (mf fulfilled/mf units)"
    value_format_name: percent_0
    type: number
    sql: ${mf_fulfilled}/nullif(${mf_units},0) ;;
  }

  measure: whlsl_fulfilled {
    view_label: "Fulfillment"
    label: "Wholesale SLA (old)"
    hidden: yes
    description: "Was the order shipped out by the required ship-by date to arrive on time"
    type: sum_distinct
    sql_distinct_key: ${pk_concat_ful_sales_order} ;;
    sql:  case when ${fulfilled_date} <= ${sales_order.ship_by_date} then ${ordered_qty} else 0 end ;;
  }

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
    sql: ${Due_Date}::date < current_date;;
  }

  dimension: sla_current_week_num{
    group_label: "SLA Target Date"
    view_label: "Fulfillment"
    label: "z - Before Current Week"
    type: yesno
    sql: date_trunc(week, ${Due_Date}::date) < date_trunc(week, current_date) ;;
  }

  dimension: sla_prev_week{
    group_label: "SLA Target Date"
    view_label: "Fulfillment"
    label: "z - Previous Week"
    type: yesno
    sql: date_trunc(week, ${Due_Date}::date) = dateadd(week, -1, date_trunc(week, current_date)) ;;
  }

  measure: sales_eligible_for_SLA{
    label: "zQty Eligible SLA"
    hidden:  yes
    view_label: "Fulfillment"
    type: sum_distinct
    sql_distinct_key: ${pk_concat} ;;
    sql: CASE
            WHEN ${cancelled_order.cancelled_date} is null THEN ${TABLE}.gross_amt
            WHEN ${cancelled_order.cancelled_date} > ${SLA_Target_date} THEN ${TABLE}.gross_amt
            WHEN ${cancelled_order.cancelled_date} >= ${fulfillment.left_purple_date} THEN ${TABLE}.gross_amt
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
          when ${cancelled_order.cancelled_date} < ${fulfillment.left_purple_date} Then 0
          Else
            case
              when ${fulfillment.left_purple_date} <= ${Due_Date} THEN ${gross_amt}
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
            WHEN ${cancelled_order.cancelled_date} >= ${fulfillment.left_purple_date} THEN ${ordered_qty}
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
        when ${cancelled_order.cancelled_date} < ${fulfillment.left_purple_date} Then 0
        when ${fulfillment.left_purple_date} <= ${Due_Date} THEN ${ordered_qty}
        Else 0
      END ;;
  }

  dimension: SLA_fulfilled {
    label: "     * Is Fulfilled in SLA"
    description: "Was item fulfilled in SLA window"
    view_label: "Fulfillment"
    type: yesno
    sql: nvl(${cancelled_order.cancelled_date},'2099-01-01') >= ${fulfilled_date} AND ${fulfilled_date} <= ${Due_Date} ;;
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

  dimension: picked_packed_sla {
    label: "Picked/Packed is Fulfilled in SLA"
    hidden: yes
    description: "Was item fulfilled in SLA window for Left Purple Date to Minimun Ship by Date"
    type: yesno
    sql:  ${fulfillment.left_purple_date} <= ${sales_order_line.min_ship_date_date} or (${fulfillment.left_purple_date} is null and ${sales_order_line.min_ship_date_date} < current_date) ;;
  }

  measure: whlsl_units {
    view_label: "Fulfillment"
    label: "Wholesale SLA (units)"
    hidden: yes
    description: "How many items are there on the order to be shipped?"
    type: sum
    sql: case when ${cancelled_order.cancelled_date} is null or (${cancelled_order.cancelled_date} >  ${sales_order.ship_by_date}) then ${ordered_qty} else 0 end ;;
  }

  measure: whlsl_on_time {
    view_label: "Fulfillment"
    group_label: "SLA"
    label: "Wholesale Shipped on Time (% of units)"
    description: "Percent of units shipped out by the required ship-by date to arrive on time (Wholesale fulfilled/Wholesale units)"
    value_format_name: percent_0
    type: number
    sql: ${whlsl_fulfilled}/nullif(${whlsl_units},0) ;;
  }

  measure: amazon_ca_sales {
    label: "Amazon-CA Gross Amount ($0.k)"
    description: "used to generate the sales by channel report"
    hidden: yes
    value_format: "$#,##0,\" K\""
    type: sum
    sql: case when ${sales_order.channel_source} = 'AMAZON-CA' then ${TABLE}.gross_amt else 0 end ;;
  }

  measure: amazon_us_sales {
    label: "Amazon-US Gross Amount ($0.k)"
    description: "used to generate the sales by channel report"
    hidden: yes
    value_format: "$#,##0,\" K\""
    type: sum
    sql: case when ${sales_order.channel_source} = 'AMAZON-US' then ${TABLE}.gross_amt else 0 end ;;
  }

  measure: shopify_ca_sales {
    label: "Shopify-CA Gross Amount ($0.k)"
    description: "used to generate the sales by channel report"
    hidden: yes
    value_format: "$#,##0,\" K\""
    type: sum
    sql: case when ${sales_order.channel_source} = 'SHOPIFY-CA' then ${TABLE}.gross_amt else 0 end ;;
  }

  measure: shopify_us_sales {
    label: "Shopify-US GrossAmount ($0.k)"
    description: "US Shopify gross sales as reported in Netsuite"
    hidden: yes
    value_format: "$#,##0,\" K\""
    type: sum
    sql: case when ${sales_order.channel_source} = 'SHOPIFY-US' then ${TABLE}.gross_amt else 0 end ;;
  }

  measure: unfulfilled_orders {
    group_label: "Gross Sales Unfulfilled"
    label: "Unfulfilled Units ($)"
    view_label: "Fulfillment"
    description: "Orders placed that have not been fulfilled"
    value_format: "$#,##0"
    type: number
    #sql_distinct_key: ${pk_concat_ful_sales_order};;
    drill_fields: [order_id, sales_order.tranid, created_date, SLA_Target_date,sales_order.minimum_ship_date ,item.product_description, location, sales_order.source, total_units,gross_amt,fulfilled_orders,unfulfilled_orders]
    sql: (${total_gross_Amt}/nullif(${total_units},0))*(${total_units}-${fulfillment.count}) ;;
  }

  measure: unfulfilled_orders_units {
    group_label: "Gross Sales Unfulfilled"
    view_label: "Fulfillment"
    label: "Unfulfilled Orders (units)"
    description: "Orders placed that have not been fulfilled"
    type: number
    #sql_distinct_key: ${pk_concat_ful_sales_order};;
    drill_fields: [order_id, sales_order.tranid, created_date, SLA_Target_date,sales_order.minimum_ship_date ,item.product_description, location, sales_order.source, total_units,gross_amt,fulfilled_orders_units,unfulfilled_orders_units]
    sql: ${total_units}-${fulfillment.count} ;;
  }

  measure: fulfilled_orders {
    group_label: "Gross Sales Fulfilled"
    view_label: "Fulfillment"
    label: "Fulfilled Orders ($)"
    description: "Orders placed that have been fulfilled"
    value_format: "$#,##0"
    type: number
    #sql_distinct_key: ${pk_concat_ful_sales_order};;
    drill_fields: [order_id, sales_order.tranid, created_date, SLA_Target_date,sales_order.minimum_ship_date ,item.product_description, location, sales_order.source, total_units,gross_amt,fulfilled_orders,unfulfilled_orders]
    sql: (${total_gross_Amt}/nullif(${total_units},0))*(${fulfillment.count}) ;;
  }

  measure: fulfilled_orders_units {
    group_label: "Gross Sales Fulfilled"
    view_label: "Fulfillment"
    label: "Fulfilled Orders (units)"
    description: "Orders placed that have been fulfilled"
    type: number
    #sql_distinct_key: ${pk_concat_ful_sales_order};;
    drill_fields: [order_id, sales_order.tranid, created_date, SLA_Target_date,sales_order.minimum_ship_date ,item.product_description, location, sales_order.source, total_units,gross_amt,fulfilled_orders_units,unfulfilled_orders_units]
    sql: ${fulfillment.count} ;;
  }

  measure: fulfilled_in_SLA {
    view_label: "Fulfillment"
    label: "West Fulfillment SLA"
    hidden: yes
    description: "Was the order fulfilled from Purple West within 3 days of order (as per website)?"
    filters: {
      field: carrier
      value: "-Pilot,-XPO"
    }
    filters: {
      field: sales_order.channel_source
      value: "SHOPIFY%"
    }
##    filters: {
##      field: sales_order.channel_id
##      value: "1" }
    drill_fields: [fulfill_details*]
    type: sum
    sql:  case when ${fulfilled_date} <= to_Date(dateadd(d,3,${TABLE}.created)) then ${ordered_qty} else 0 end ;;
  }

  measure: SLA_eligible {
    label: "WEST SLA Eligible (3)"
    description: "Was this line item available to fulfill (not cancelled) within the SLA window?"
    view_label: "Fulfillment"
    hidden: yes
    filters: {
      field: carrier
      value: "-Pilot,-XPO"
    }
    filters: {
      field: sales_order.channel_source
      value: "SHOPIFY%"
    }
##    filters: {
##      field: sales_order.channel_id
##      value: "1" }
    type:  sum
    sql: case when ${cancelled_order.cancelled_date} is null or to_Date(${cancelled_order.cancelled_date}) > to_date(dateadd(d,3,${created_date})) then ${ordered_qty} else 0 end ;;
  }

  measure: SLA_achieved{
    label: "West SLA Achievement (% in 3 days)"
    hidden: yes
    description: "Percent of line items fulfilled by Purple West within 3 days of order"
    view_label: "Fulfillment"
    group_label: "SLA"
    type: number
    drill_fields: [customer_table.customer_id ,order_id, sales_order.tranid, created_date, sales_order.ship_by_date, fulfilled_date, SLA_Target_date ,item.product_description,Qty_Fulfilled_in_SLA ,total_units,SLA_Achievement_prct]
    value_format_name: percent_1
    sql: case when datediff(day,${created_date},current_date) < 4 then null else ${fulfilled_in_SLA}/nullif(${SLA_eligible},0) end ;;
  }

  measure: manna_fulfilled_in_SLA {
    view_label: "Fulfillment"
    label: "Pilot Fulfillment SLA"
    hidden: yes
    description: "Was this item fulfilled from Manna within 14 days of order (as per website)?"
    filters: {
      field: carrier
      value: "Pilot,Manna"
    }
    filters: {
      field: sales_order.channel_source
      value: "SHOPIFY%"
    }
##    filters: {
##      field: sales_order.channel_id
##      value: "1" }
    drill_fields: [fulfill_details*]
    type: sum
    sql:  case when ${fulfilled_date} <= to_Date(dateadd(d,14,${TABLE}.created)) then ${ordered_qty} else 0 end ;;
  }

  measure: manna_SLA_eligible {
    label: "Pilot SLA Eligible (14)"
    description: "Was this Manna line item available to fulfill (not cancelled) within the SLA window?"
    view_label: "Fulfillment"
    hidden: yes
    filters: {
      field: carrier
      value: "Pilot,Manna"
    }
    filters: {
      field: sales_order.channel_source
      value: "SHOPIFY%"
    }
##    filters: {
##      field: sales_order.channel_id
##      value: "1" }
    type:  sum
    sql: case when ${cancelled_order.cancelled_date} is null or to_Date(${cancelled_order.cancelled_date}) >= to_Date(dateadd(d,14,${created_date})) then ${ordered_qty} else 0 end ;;
  }

  measure: manna_fulfilled_in_SLA_14days {
    view_label: "Fulfillment"
    label: "Pilot Fulfillment SLA"
    hidden: yes
    description: "Was this item fulfilled from Manna within 14 days of order (as per website)?"
    filters: {
      field: carrier
      value: "Pilot,Manna"
    }
    filters: {
      field: sales_order.channel_source
      value: "SHOPIFY%"
    }
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
                      end ;;
  }

  measure: manna_SLA_eligible_14days {
    label: "Pilot SLA Eligible (14)"
    description: "Was this Manna line item available to fulfill (not cancelled) within the SLA window?"
    view_label: "Fulfillment"
    hidden: yes
    filters: {
      field: carrier
      value: "Pilot,Manna"
    }
    filters: {
      field: sales_order.channel_source
      value: "SHOPIFY%"
    }
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
        end ;;
  }

  measure: manna_sla_achieved{
    label: "Pilot SLA Achievement (% in 14 days)"
    view_label: "Fulfillment"
    group_label: "SLA"
    hidden: no
    description: "Percent of line items fulfilled by Manna within 14 days of order"
    type: number
    drill_fields: [customer_table.customer_id ,order_id, sales_order.tranid, created_date, sales_order.ship_by_date, fulfilled_date, SLA_Target_date ,item.product_description,Qty_Fulfilled_in_SLA ,total_units,SLA_Achievement_prct]
    value_format_name: percent_1
    sql:${manna_fulfilled_in_SLA_14days}/nullif(${manna_SLA_eligible_14days},0) ;;
  }

  measure: XPO_fulfilled_in_SLA {
    view_label: "Fulfillment"
    label: "XPO Fulfillment SLA"
    hidden: yes
    description: "Was this item fulfilled from Manna within 14 days of order (as per website)?"
    filters: {
      field: carrier
      value: "XPO"
    }
    filters: {
      field: sales_order.channel_source
      value: "SHOPIFY%"
    }
##    filters: {
##      field: sales_order.channel_id
##      value: "1" }
    drill_fields: [fulfill_details*]
    type: sum
    sql:  case when ${fulfilled_date} <= to_Date(dateadd(d,14,${TABLE}.created)) and ${cancelled_order.cancelled_date} is null then ${ordered_qty} else 0 end ;;
  }

  measure: XPO_SLA_eligible {
    label: "Manna SLA Eligible (14)"
    description: "Was this Manna line item available to fulfill (not cancelled) within the SLA window?"
    view_label: "Fulfillment"
    hidden: yes
    filters: {
      field: carrier
      value: "XPO"
    }
    filters: {
      field: sales_order.channel_source
      value: "SHOPIFY%"
    }
##    filters: {
##      field: sales_order.channel_id
##      value: "1" }
    type:  sum
    sql: case when ${cancelled_order.cancelled_date} is null or to_Date(${cancelled_order.cancelled_date}) > to_Date(dateadd(d,14,${created_date})) then ${ordered_qty} else 0 end ;;
  }


  measure: xpo_sla_achieved{
    label: "XPO SLA Achievement (% in 14 days)"
    view_label: "Fulfillment"
    group_label: "SLA"
    description: "Percent of line items fulfilled by Manna within 1 days of order"
    type: number
    drill_fields: [customer_table.customer_id ,order_id, sales_order.tranid, created_date, sales_order.ship_by_date, fulfilled_date, SLA_Target_date ,item.product_description,Qty_Fulfilled_in_SLA ,total_units,SLA_Achievement_prct]
    value_format_name: percent_1
    sql: case when datediff(day,${created_date},current_date) > 14 then ${XPO_fulfilled_in_SLA}/nullif(${XPO_SLA_eligible},0) else null end ;;
  }

  measure: total_standard_cost {
    #hidden: yes
    label: "Total Standard Cost"
    description: "Total Cost (cost per unit * number of units)"
    group_label: "Product"
    type:  sum
    value_format: "$#,##0"
    sql:  ${TABLE}.ordered_qty * ${standard_cost.standard_cost} ;;
  }


  dimension: has_standard_cost {
    label: "    * Has Standard Cost"
    type: yesno
    description: "Data exists for what it costs Purple to make the product"
    sql: ${standard_cost.standard_cost} is not null ;;
  }

  dimension: days_to_cancel {
    view_label: "Cancellations"
    label: "# days from order"
    description: "Number of days after initial order was placed that the order was cancelled. 0 means the order was cancelled on the day it was placed"
    type: tier
    style: integer
    hidden:  yes
    tiers: [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28]
    sql: datediff(d,${created_date},${cancelled_order.cancelled_date}) ;;
  }

  dimension_group: fulfilled {
    view_label: "Fulfillment"
    label: "    Fulfilled"
    description:  "Date item within order shipped for Fed-ex orders, date customer receives delivery from Manna or date order is on truck for wholesale"
    type: time
    timeframes: [raw,hour,date, day_of_week, day_of_month, week, week_of_year, month, month_name, quarter, quarter_of_year, year]
    convert_tz: no
    #datatype: date
    sql: case when ${sales_order.transaction_type} = 'Cash Sale' or ${sales_order.source} = 'Amazon-FBA-US'  then ${sales_order.created} else ${fulfillment.fulfilled_F_raw} end ;;
  }

  measure: last_updated_date_fulfilled {
    view_label: "Fulfillment"
    type: date
    sql: MAX(${fulfilled_date}) ;;
    convert_tz: no
  }

  dimension: is_fulfilled {
    view_label: "Fulfillment"
    label: "     * Is Fulfilled"
    description:  "Has order been fulfilled"
    type: yesno
    sql: ${fulfilled_date} is not null;;
  }

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
      END;;
  }

  dimension: wholesale_packed {
    label: "Is Wholesale and Packed"
    type: yesno
    #hidden: yes
    sql: ${sales_order.channel_id} = 2 and ${is_packed} ;;
  }

  dimension: xpo_pilot_packed {
    label: "Is Pilot or XPO and Packed"
    type: yesno
    #hidden: yes
    sql: ${fulfillment.carrier} in ('XPO','Pilot') and ${is_packed} ;;
  }

  measure: days_to_cancel_measure {
    view_label: "Cancellations"
    label: "      Avg days from order to cancellation"
    description: "Number of days after initial order was placed that the order was cancelled. 0 means the order was cancelled on the day it was placed"
    type: average
    sql: datediff(d,${created_date},${cancelled_order.cancelled_date}) ;;
  }

  dimension: MTD_fulfilled_flg{
    group_label: "    Fulfilled Date"
    label: "z - Month to Date (current year)"
    #hidden:  yes
    view_label: "Fulfillment"
    description: "This field is for formatting on (week/month/quarter/year) to date reports"
    type: yesno
    sql: ${fulfilled_raw}::date <= current_date and month(${fulfilled_raw}::date) = month(dateadd(day,-1,current_date)) and year(${fulfilled_raw}::date) = year(current_date) ;;
  }

  dimension: ff_Before_today{
    group_label: "    Fulfilled Date"
    view_label: "Fulfillment"
    label: "z - Is Before Today (mtd)"
    description: "This field is for formatting on (week/month/quarter/year) to date reports"
    type: yesno
    sql: ${fulfilled_raw}::date < current_date;;
  }

  dimension: ff_current_week_num{
    group_label: "    Fulfilled Date"
    view_label: "Fulfillment"
    label: "z - Before Current Week"
    description: "Yes/No for if the date is in the last 30 days"
    type: yesno
    sql: date_trunc(week, ${fulfilled_raw}::date) < date_trunc(week, current_date) ;;
  }

  dimension: ff_prev_week{
    group_label: "    Fulfilled Date"
    view_label: "Fulfillment"
    label: "z - Previous Week"
    description: "Yes/No for if the date is in the last 30 days"
    type: yesno
    sql:  date_trunc(week, ${fulfilled_raw}::date) = dateadd(week, -1, date_trunc(week, current_date)) ;;
  }

  dimension: week_bucket_ff{
    group_label: "    Fulfilled Date"
    view_label: "Fulfillment"
    label: "z - Week Bucket"
    description: "Grouping by week, for comparing last week, to the week before, to last year"
    type: string
    sql:  CASE WHEN date_trunc(week, ${fulfilled_raw}::date) = date_trunc(week, current_date) THEN 'Current Week'
            WHEN date_trunc(week, ${fulfilled_raw}::date) = dateadd(week, -1, date_trunc(week, current_date)) THEN 'Last Week'
            WHEN date_trunc(week, ${fulfilled_raw}::date) = dateadd(week, -2, date_trunc(week, current_date)) THEN 'Two Weeks Ago'
            WHEN date_trunc(week, ${fulfilled_raw}::date) = date_trunc(week, dateadd(week, 1, dateadd(year, -1, current_date))) THEN 'Current Week LY'
            WHEN date_trunc(week, ${fulfilled_raw}::date) = date_trunc(week, dateadd(week, 0, dateadd(year, -1, current_date))) THEN 'Last Week LY'
            WHEN date_trunc(week, ${fulfilled_raw}::date) = date_trunc(week, dateadd(week, -1, dateadd(year, -1, current_date))) THEN 'Two Weeks Ago LY'
            ELSE 'Other' END ;;
  }

  measure: return_rate_units {
    group_label: "Return Rates"
    label: "Return Rate (% of units)"
    description: "Units returned/Units fulfilled"
    view_label: "Returns"
    type: number
    sql: ${return_order_line.units_returned} / nullif(${total_units},0) ;;
    value_format_name: "percent_1"
  }

  measure: return_rate_dollars {
    group_label: "Return Rates"
    label: "Return Rate (% of $)"
    description: "Total $ returned / Total $ fulfilled"
    view_label: "Returns"
    type: number
    sql: ${return_order_line.total_gross_amt} / nullif(${total_gross_Amt},0) ;;
    value_format_name: "percent_1"
  }

  dimension_group: min_ship_date {
    label: "Minimum Ship by"
    description: "Merging Minimum Ship By and Ship By fields from netsuite into a single values.  Min then Ship by."
    view_label: "Fulfillment"
    type: time
    timeframes: [raw, date, day_of_week, day_of_month, week, week_of_year, month, month_name, quarter, quarter_of_year, year]
    sql: coalesce(${sales_order.minimum_ship_date},${sales_order.ship_by_date}) ;;
  }

  dimension_group: transmitted_date {
    label: "Transmitted"
    view_label: "Fulfillment"
    description: "Looking at the trasmitted date that matches the carrier from sales order line"
    type: time
    timeframes: [raw, date, hour_of_day, day_of_week, day_of_month, week, week_of_year, month, month_name, quarter, quarter_of_year, year]
    sql: case when ${carrier} = 'Pilot' then ${v_transmission_dates.TRANSMITTED_TO_PILOT_raw}
      when ${carrier} = 'Mainfreight' then ${v_transmission_dates.TRANSMITTED_TO_MAINFREIGHT_raw}
      when ${carrier} = 'Carry Out' then ${created_raw}
      else ${v_transmission_dates.download_to_warehouse_edge_raw} end;;
  }

  measure: order_to_trasnmitted_days {
    label: "Order to Transmitted (days)"
    view_label: "Fulfillment"
    group_label: "Time Between Benchmarks"
    description: "The average difference between the order date and transmitted date"
    type: average
    value_format: "0.00"
    sql: datediff('day',${created_raw},${transmitted_date_raw}) ;;
  }

  measure: order_to_left_purple_days {
    label: "Order to Left Purple (days)"
    view_label: "Fulfillment"
    group_label: "Time Between Benchmarks"
    description: "The average difference between the order date and transmitted date"
    type: average
    value_format: "0.00"
    sql_distinct_key: ${fulfillment.PK} ;;
    sql: datediff('day',${created_raw},${fulfillment.left_purple_raw}) ;;
  }

  measure: transmitted_to_left_purple_days {
    label: "Transmitted to Left Purple (days)"
    view_label: "Fulfillment"
    group_label: "Time Between Benchmarks"
    description: "The average difference between the order date and transmitted date"
    type: average
    value_format: "0.00"
    sql_distinct_key: ${fulfillment.PK} ;;
    sql: datediff('day',${transmitted_date_raw},${fulfillment.left_purple_raw}) ;;
  }

  measure: transmitted_to_in_hand_days {
    label: "Transmitted to In Hand (days)"
    view_label: "Fulfillment"
    group_label: "Time Between Benchmarks"
    description: "The average difference between the order date and transmitted date"
    type: average
    value_format: "0.00"
    sql_distinct_key: ${fulfillment.PK} ;;
    sql: datediff('day',${transmitted_date_raw},${fulfillment.in_hand_raw}) ;;
  }


  measure: order_to_in_hand_days {
    label: "Order to In Hand (days)"
    view_label: "Fulfillment"
    group_label: "Time Between Benchmarks"
    description: "The average difference between the order date and transmitted date"
    type: average
    value_format: "0.00"
    sql_distinct_key: ${fulfillment.PK} ;;
    sql: datediff('day',${created_raw},${fulfillment.in_hand_raw}) ;;
  }

  measure: left_purple_to_in_hand_days {
    label: "Left Purple to In Hand (days)"
    view_label: "Fulfillment"
    group_label: "Time Between Benchmarks"
    description: "The average difference between the order date and transmitted date"
    type: average
    value_format: "0.00"
    sql_distinct_key: ${fulfillment.PK} ;;
    sql: datediff('day',${fulfillment.left_purple_raw},${fulfillment.in_hand_raw}) ;;
  }

  measure: order_to_transmitted_hours {
    label: " Order to Transmitted (hours)"
    view_label: "Fulfillment"
    group_label: "Time Between Benchmarks"
    description: "The average difference between the order date and transmitted date in hours"
    type: average
    value_format: "0.00"
    sql: timediff('hour',${created_raw},${transmitted_date_raw}) ;;
  }

  measure: order_to_left_purple_hours {
    label: " Order to Left Purple (hours)"
    view_label: "Fulfillment"
    group_label: "Time Between Benchmarks"
    description: "The average difference between the order date and transmitted date in hours"
    type: average
    value_format: "0.00"
    sql_distinct_key: ${fulfillment.PK} ;;
    sql: timediff('hour',${created_raw},${fulfillment.left_purple_raw}) ;;
  }

  measure: transmitted_to_left_purple_hours {
    label: " Transmitted to Left Purple (hours)"
    view_label: "Fulfillment"
    group_label: "Time Between Benchmarks"
    description: "The average difference between the order date and transmitted date in hours"
    type: average
    value_format: "0.00"
    sql_distinct_key: ${fulfillment.PK} ;;
    sql: timediff('hour',${transmitted_date_raw},${fulfillment.left_purple_raw}) ;;
  }

  measure: transmitted_to_in_hand_hours {
    label: " Transmitted to In Hand (hours)"
    view_label: "Fulfillment"
    group_label: "Time Between Benchmarks"
    description: "The average difference between the order date and transmitted date in hours"
    type: average
    value_format: "0.00"
    sql_distinct_key: ${fulfillment.PK} ;;
    sql: timediff('hour',${transmitted_date_raw},${fulfillment.in_hand_raw}) ;;
  }


  measure: order_to_in_hand_hours {
    label: " Order to In Hand (hours)"
    view_label: "Fulfillment"
    group_label: "Time Between Benchmarks"
    description: "The average difference between the order date and transmitted date in hours"
    type: average
    value_format: "0.00"
    sql_distinct_key: ${fulfillment.PK} ;;
    sql: timediff('hour',${created_raw},${fulfillment.in_hand_raw}) ;;
  }

  measure: left_purple_to_in_hand_hours {
    label: " Left Purple to In Hand (hours)"
    view_label: "Fulfillment"
    group_label: "Time Between Benchmarks"
    description: "The average difference between the order date and transmitted date in hours"
    type: average
    value_format: "0.00"
    sql_distinct_key: ${fulfillment.PK} ;;
    sql: timediff('hour',${fulfillment.left_purple_raw},${fulfillment.in_hand_raw}) ;;
  }

  set: fulfill_details {
    fields: [order_id,item_id,created_date,fulfilled_date]
  }

  measure: mattress_sales {
    label: "Mattress Sales ($)"
    view_label: "Product"
    type: sum
    sql:  case when ${item.category_raw} = 'MATTRESS' then ${gross_amt} else 0 end ;;
  }

  measure: mattress_units {
    label: "Mattress Sales (Units)"
    view_label: "Product"
    type: sum
    sql:  case when ${item.category_raw} = 'MATTRESS' then ${total_units_raw} else 0 end ;;
  }

  measure: base_sales {
    label: "Base Sales ($)"
    view_label: "Product"
    type: sum
    sql:  case when ${item.category_raw} = 'BASE' then ${gross_amt} else 0 end ;;
  }

  measure: base_units {
    label: "Base Sales (Units)"
    view_label: "Product"
    type: sum
    sql:  case when ${item.category_raw} = 'BASE' then ${total_units_raw} else 0 end ;;
  }

  measure: bedding_sales {
    label: "Bedding Sales ($)"
    view_label: "Product"
    type: sum
    sql:  case when ${item.category_raw} = 'BEDDING' then ${gross_amt} else 0 end ;;
  }

  measure: bedding_units {
    label: "Bedding Sales (Units)"
    view_label: "Product"
    type: sum
    sql:  case when ${item.category_raw} = 'BEDDING' then ${total_units_raw} else 0 end ;;
  }

  measure: pet_sales {
    label: "Pet Sales ($)"
    view_label: "Product"
    type: sum
    sql:  case when ${item.category_raw} = 'PET' then ${gross_amt} else 0 end ;;
  }

  measure: pet_units {
    label: "Pet Sales (Units)"
    view_label: "Product"
    type: sum
    sql:  case when ${item.category_raw} = 'PET' then ${total_units_raw} else 0 end ;;
  }

#  measure: average_mattress_order_size {
#    label: "AMOV ($)"
#    description: "Average total mattress order amount, excluding tax"
#    type: average
#    sql_distinct_key: ${sales_order.order_system} ;;
#    value_format: "$#,##0.00"
#    sql: case when ${order_flag.mattress_flg} = 1 then ${sales_order.gross_amt} end ;; }

#  measure: average_accessory_order_size {
#    label: "NAMOV ($)"
#    description: "Average total accessory order amount, excluding tax"
#    type: sum
#    sql_distinct_key: ${sales_order.order_system} ;;
#    value_format: "$#,##0.00"
#    sql: case when ${order_flag.mattress_flg} = 0 then ${sales_order.gross_amt} end ;; }

}
