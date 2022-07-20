include: "/views/netsuite/NETSUITE.sales_order_line_base.view.lkml"
view: sales_order_line {
  extends: [sales_order_line_base]

## see data by is used for the interactive dashboards
  parameter: see_data_by {
    description: "This is a parameter filter that changes the value of See Data By dimension.  Source: looker.calculation"
    hidden: yes
    type: unquoted
    allowed_value: {
      label: "Day"
      value: "day"
    }
    allowed_value: {
      label: "Week"
      value: "week"
    }
    allowed_value: {
      label: "Month"
      value: "month"
    }
    allowed_value: {
      label: "Quarter"
      value: "quarter"
    }
    allowed_value: {
      label: "Product Model"
      value: "model"
    }
  }

  dimension: see_data {
    view_label: "Sales Order"
    label: "See Data By"
    description: "This is a dynamic dimension that changes when you change the See Data By filter.  Source: looker.calculation"
    hidden: yes
    sql:
    {% if see_data_by._parameter_value == 'day' %}
      ${created_date}
    {% elsif see_data_by._parameter_value == 'week' %}
      ${created_week}
    {% elsif see_data_by._parameter_value == 'month' %}
      ${created_month}
    {% elsif see_data_by._parameter_value == 'quarter' %}
      ${created_quarter}
    {% elsif see_data_by._parameter_value == 'model' %}
      ${item.model_raw}
    {% else %}
      ${created_date}
    {% endif %};;
  }

## see data by pop sol (period over period sales order line) is used for the interactive dashboards
  parameter: see_data_by_pop_sol {
    label: "See Data By"
    description: "This is a parameter filter that changes the value of See Data By dimension.  Source: looker.calculation"
    hidden: yes
    type: unquoted
    allowed_value: {
      label: "Day"
      value: "day"
    }
    allowed_value: {
      label: "Week"
      value: "week"
    }
    allowed_value: {
      label: "Month"
      value: "month"
    }
    allowed_value: {
      label: "Quarter"
      value: "quarter"
    }
    allowed_value: {
      label: "Product Model"
      value: "model"
    }
  }

  dimension: see_data_pop_sol {
    view_label: "Sales Order"
    label: "See Data By"
    description: "This is a dynamic dimension that changes when you change the See Data By filter.  Source: looker.calculation"
    hidden: yes
    sql:
    {% if see_data_by._parameter_value == 'day' %}
      ${date_in_period_date}
    {% elsif see_data_by._parameter_value == 'week' %}
      ${date_in_period_week}
    {% elsif see_data_by._parameter_value == 'month' %}
      ${date_in_period_month}
    {% elsif see_data_by._parameter_value == 'quarter' %}
      ${date_in_period_quarter}
    {% elsif see_data_by._parameter_value == 'model' %}
      ${item.model_raw}
    {% else %}
      ${date_in_period_date}
    {% endif %};;
  }

  dimension: see_data_pop_sol_order_created {
    view_label: "Sales Order"
    label: "See Data By Created"
    description: "This is a dynamic dimension that changes when you change the See Data By filter.  Source: looker.calculation"
    hidden: yes
    sql:
    {% if see_data_by._parameter_value == 'day' %}
      ${created_date}
    {% elsif see_data_by._parameter_value == 'week' %}
      ${created_week}
    {% elsif see_data_by._parameter_value == 'month' %}
      ${created_month}
    {% elsif see_data_by._parameter_value == 'quarter' %}
      ${created_quarter}
    {% elsif see_data_by._parameter_value == 'model' %}
      ${item.model_raw}
    {% else %}
      ${created_date}
    {% endif %};;
  }

  dimension: payment_method {
    hidden: yes
    view_label: "Sales Order"
    group_label: " Advanced"
    label: "Payment Method"
    description: "Blank is no special cirumstance.  Values include Affirm, Progressive, Paypal, etc. Source: netsuite.sales_order_line"
    type: string
    sql: sales_order.payment_method ;;
  }

  dimension: channel_ret {
    hidden: yes
    ##this is for joining the modeled return rate file only
    type: string
    sql:
      case when ${zendesk_sell.order_id} is not null then 'Inside sales'
        when ${sales_order.channel_id} = 1 then 'Web'
        when ${sales_order.channel_id} = 5 then 'Retail'
        else 'Other'
      end
    ;;
  }

  measure: asp_gross_amt {
    hidden: yes
    type: sum
    filters: [free_item: "No"]
    sql: ${TABLE}.gross_amt ;;
  }

  measure: asp_total_units {
    hidden: yes
    type: sum
    filters: [free_item: "No"]
    sql: ${TABLE}.ordered_qty ;;
  }

  measure: asp {
    hidden: no
    label: "ASP"
    description: "Average Sales Price, this measure is excluding free items ($0 orders). Source: looker.calculation"
    type: number
    value_format: "$#,##0"
    sql:case when ${asp_total_units} > 0 then ${asp_gross_amt}/${asp_total_units} else 0 end ;;
  }

  measure: avg_days_to_fulfill {
    group_label: "Average Days:"
    label: "to Fulfillment"
    description: "Average number of days between order and fulfillment. Source:looker.calculation"
    drill_fields: [fulfillment_details*]
    view_label: "Fulfillment"
    type:  average_distinct
    value_format: "#.0"
    sql_distinct_key: ${item_order}||'-'||${fulfillment.PK};;
    sql: datediff(day,${TABLE}.created,${fulfilled_raw}) ;;
  }

  measure: mf_fulfilled {
    view_label: "Fulfillment"
    label: "Mattress Firm SLA (numerator)"
    hidden: yes
    description: "Total units successfully fulfilled before the ship by date. Source: looker.calculation"
    drill_fields: [fulfillment_details*]
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
    description: "Total units not cancelled before the ship by date. Source: looker.calculation"
    drill_fields: [fulfillment_details*]
    filters: {
      field: sales_order.customer_id
      value: "2662" }
    type: sum
    sql: case when ${cancelled_order.cancelled_date} is null or (${cancelled_order.cancelled_date} >  ${sales_order.ship_by_date}) then ${ordered_qty} else 0 end ;;
  }

  measure: mf_on_time {
    hidden: yes
    view_label: "Fulfillment"
    group_label: "Fulfillment SLA (units)"
    label: "Mattress Firm Shipped on Time (% of units)"
    description: "Percent of units that  shipped out by the required ship-by date to arrive to Mattress Firm on time (mf fulfilled/mf units). Source:looker.calculation"
    drill_fields: [fulfillment_details*]
    value_format_name: percent_0
    type: number
    sql: ${mf_fulfilled}/nullif(${mf_units},0) ;;
  }

  measure: whlsl_fulfilled {
    view_label: "Fulfillment"
    label: "Wholesale SLA (old)"
    hidden: yes
    description: "Was the order shipped out by the required ship-by date to arrive on time. Source: looker.calculation"
    drill_fields: [fulfillment_details*]
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
              When upper(${carrier_raw}) not in ('XPO','MANNA','PILOT') THEN
              Case When sales_order.minimum_ship is null Then dateadd(d,4,${created_date})
               Else
                 Case
                     When sales_order.minimum_ship = ${created_date} THEN dateadd(d,3,sales_order.minimum_ship)
                      Else sales_order.minimum_ship
                  END
                  END
               Else dateadd(d,14,${created_date})
            END
          WHEN sales_order.channel_id = 2 THEN Case When sales_order.SHIP_BY is not null Then sales_order.SHIP_BY Else dateadd(d,4,${created_date}) END
          Else dateadd(d,4,${created_date})
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
          WHEN ${sales_order.channel_id} <> 2 and upper(${carrier_raw}) not in ('XPO','MANNA','PILOT','RYDER','NEHDS','SPEEDY DELIVERY','PURPLE HOME DELIVERY','FRAGILEPAK','SELECT EXPRESS','CRST') and ${sales_order.minimum_ship_date} > ${created_date}
            THEN ${sales_order.minimum_ship_date}
          -- fedex without min ship date is created + 4
          WHEN ${sales_order.channel_id} <> 2 and upper(${carrier_raw}) not in ('XPO','MANNA','PILOT','RYDER','NEHDS','SPEEDY DELIVERY','PURPLE HOME DELIVERY','FRAGILEPAK','SELECT EXPRESS','CRST')
            THEN dateadd(d,4,${created_date})
          --whiteglove is created + 14
          WHEN ${sales_order.channel_id} <> 2 and upper(${carrier_raw}) in ('XPO','MANNA','PILOT','RYDER','NEHDS','SPEEDY DELIVERY','PURPLE HOME DELIVERY','FRAGILEPAK','SELECT EXPRESS','CRST')
            THEN greatest(${sales_order.minimum_ship_date}, dateadd(d,14,${created_date}))
          --catch all is creatd +3
          Else dateadd(d,4,${created_date}) END ;;
  }

  dimension: White_Glove_Due_Date {
    view_label: "Fulfillment"
    hidden: yes
    type: date
    sql: case
          --white glove carriers have 14 days from date of transmission
          WHEN ${sales_order.channel_id} <> 2 and upper(${carrier_raw}) in ('XPO','MANNA','PILOT','RYDER','NEHDS','SPEEDY DELIVERY','PURPLE HOME DELIVERY','FRAGILEPAK','SELECT EXPRESS','CRST')
            THEN dateadd(d,14,${transmitted_date_date})
          --catch all is creatd +3
          Else dateadd(d,3,${transmitted_date_date}) END ;;
  }
  dimension: Due_Date_new {
    ##updated by Scott Clark on 7/6/2020 working on updating actual SLAs for Jane
    view_label: "Fulfillment"
    group_label: " Advanced"
    label: "SLA-based ship-by"
    description: "DO NOT USE FOR WHOLESALE. This is the ship-by date in order to meet the website specific SLA for that SKU on that order date. "
    hidden: yes
    type: date
    sql: case
          -- wholesale is ship by date (from sales order)
          WHEN ${sales_order.channel_id} = 2 and ${sales_order.ship_by_date} is not null
            THEN ${sales_order.ship_by_date}
          -- fedex is min ship date
          WHEN ${sales_order.channel_id} <> 2 THEN dateadd(d,coalesce(${v_sla_days.sla_days},5),${created_date})
          Else dateadd(d,4,${created_date}) END ;;
  }

  dimension: wg_sla_ship {
    ##updated by Scott Clark on 7/30/2021 working on updating actual SLAs for Jane
    view_label: "Fulfillment"
    group_label: "Website SLAs"
    label: "White-glove SLA ship-by"
    description: "DO NOT USE FOR WHOLESALE. This is the ship-by date in order to meet the website specific SLA for that SKU on that order date. "
    hidden: no
    type: date
    sql: case
          -- wholesale is ship by date (from sales order)
          WHEN ${sales_order.channel_id} = 2 and ${sales_order.ship_by_date} is not null
            THEN ${sales_order.ship_by_date}
          -- fedex is min ship date
          WHEN ${sales_order.channel_id} <> 2 THEN dateadd(d,coalesce(${sla.white_glove},14),${created_date})
          Else dateadd(d,14,${created_date}) END ;;
  }

  dimension: sla_ship {
    ##updated by Scott Clark on 7/30/2021 working on updating actual SLAs for Jane
    view_label: "Fulfillment"
    group_label: "Website SLAs"
    label: "Site SLA ship-by"
    description: "DO NOT USE FOR WHOLESALE. This is the ship-by date in order to meet the website specific SLA for that SKU on that order date. "
    hidden: no
    type: date
    sql: case
          -- wholesale is ship by date (from sales order)
          WHEN ${sales_order.channel_id} = 2 and ${sales_order.ship_by_date} is not null
            THEN ${sales_order.ship_by_date}
          -- fedex is min ship date
          WHEN ${sales_order.channel_id} <> 2 THEN dateadd(d,coalesce(${sla.sla},4),${created_date})
          Else dateadd(d,4,${created_date}) END ;;
  }

  dimension: due_date_dif_flag {
    hidden: yes
    type: yesno
    sql: ${Due_Date_old}=${Due_Date}  ;;
  }

  dimension_group: SLA_Target {
    ## Scott Clark 1/8/21 Swapping out week of year
    hidden:  yes
    label: "SLA Target"
    view_label: "Fulfillment"
    description: "Source: looker.calculation"
    type: time
    timeframes: [raw, date, day_of_week, day_of_month, week, month, month_name, quarter, quarter_of_year, year, week_of_year]
    convert_tz: no
    datatype: timestamp
    sql: to_timestamp_ntz(${Due_Date}) ;;
  }

  # dimension: SLA_Target_week_of_year {
  #   ## Scott Clark 1/8/21: Added to replace week_of_year for better comps. Remove final week in 2021.
  #   hidden:  yes
  #   type: number
  #   label: "Week of Year"
  #   view_label: "Fulfillment"
  #   group_label: "SLA Target Date"
  #   description: "2021 adjusted week of year number (SLA)"
  #   sql: case when ${SLA_Target_date::date} >= '2020-12-28' and ${SLA_Target_date::date} <= '2021-01-03' then 1
  #             when ${SLA_Target_year::number}=2021 then date_part(weekofyear,${SLA_Target_date::date}) + 1
  #             else date_part(weekofyear,${SLA_Target_date::date}) end ;;
  # }

  dimension: SLA_adj_year {
    ## Scott Clark 1/8/21: Added to replace year for clean comps. Remove final week in 2021.
    hidden:  yes
    type: number
    label: "z - 2021 adj year"
    view_label: "Fulfillment"
    group_label: "SLA Target Date"
    description: "Year adjusted to align y/y charts when using week_number. DO NOT USE OTHERWISE"
    sql:  case when ${SLA_Target_date::date} >= '2020-12-28' and ${SLA_Target_date::date} <= '2021-01-03' then 2021 else ${SLA_Target_year::number} end   ;;
  }

  dimension: SLA_Buckets {
    group_label: " Advanced"
    label: "Days Past SLA Target Buckets"
    view_label: "Fulfillment"
    description: "# days in realtion to Target date. Source: looker.calculation"
    type: tier
    style: integer
    tiers: [1,2,3,4,5,6,7,11,15,21]
    sql: datediff(d,${SLA_Target_date},current_date) ;;
  }

  dimension: sla_Before_today{
    hidden:  yes
    group_label: "SLA Target Date"
    view_label: "Fulfillment"
    label: "z - Is Before Today (mtd)"
    type: yesno
    sql: ${Due_Date}::date < current_date;;
  }

  dimension: sla_current_week_num{
    hidden:  yes
    group_label: "SLA Target Date"
    view_label: "Fulfillment"
    label: "z - Before Current Week"
    type: yesno
    sql: date_trunc(week, ${Due_Date}::date) < date_trunc(week, current_date) ;;
  }

  dimension: sla_prev_week{
    hidden:  yes
    group_label: "SLA Target Date"
    view_label: "Fulfillment"
    label: "z - Previous Week"
    type: yesno
    sql: date_trunc(week, ${Due_Date}::date) = dateadd(week, -1, date_trunc(week, current_date)) ;;
  }

  dimension: bundle {
    type: string
    hidden:  no
    view_label: "Sales Order"
    group_label: " Advanced"
    label: " Bundle"
    description: "Bundle filter"
    case: {
      when: {sql: ${order_flag.ultimate_cushion_flag} AND ${order_flag.back_cushion_flag} ;; label: "Ultimate + Back"}
      when: {sql: ${order_flag.duvet_flg} AND ${order_flag.softstretch_sheets_flag} ;; label: "Duvet + SoftStretch"}
      when: {sql: ${order_flag.royal_cushion_flag} AND ${order_flag.pet_bed_flg} ;; label: "Royal + Pet Bed"}
      when: {sql: ${order_flag.harmonytwobund_flag} ;; label: "2 Harmony"}
      when: {sql: (${sales_order_line.total_units_dem} >1 AND ${item.model_raw}='PILLOW 2.0') ;; label: "2 Purple Pillow"}
      else: "other" }
  }

  measure: sales_eligible_for_SLA{
    label: "zQty Eligible SLA"
    group_label: "Fulfillment SLA ($)"
    hidden:  no
    view_label: "Fulfillment"
    drill_fields: [fulfillment_details*]
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
    group_label: "Fulfillment SLA ($)"
    view_label: "Fulfillment"
    drill_fields: [fulfillment_details*]
    hidden:  no
    type: sum_distinct
    sql_distinct_key: ${pk_concat} ;;
    sql: Case
          when ${cancelled_order.cancelled_date} < ${fulfillment.left_purple_date} Then 0
          when ${fulfillment.left_purple_date} <= ${Due_Date} THEN ${gross_amt}
          when ${sales_order.channel_id} = 2 and ${fulfillment.left_purple_date} <= ${sales_order.ship_order_by_date} THEN ${gross_amt}
          Else 0
        END;;
  }

  measure: zSLA_Achievement_prct {
    view_label: "Fulfillment"
    group_label: "Fulfillment SLA ($)"
    label: "SLA $ Achievement %"
    description: "Source: looker.calculation"
    hidden: no
    value_format_name: percent_1
    type: number
    drill_fields: [fulfillment_details*]
    sql: Case when ${sales_eligible_for_SLA} = 0 then 0 Else ${sales_Fulfilled_in_SLA}/${sales_eligible_for_SLA} End ;;
  }

  measure: purple_sales_eligible_for_SLA{
    label: "Purple Qty Eligible SLA"
    group_label: "Fulfillment SLA ($)"
    hidden:  no
    view_label: "Fulfillment"
    drill_fields: [fulfillment_details*]
    type: sum_distinct
    sql_distinct_key: ${pk_concat} ;;
    sql: CASE
            WHEN ${cancelled_order.cancelled_date} is null THEN ${TABLE}.gross_amt
            WHEN ${cancelled_order.cancelled_date} > ${SLA_Target_date} THEN ${TABLE}.gross_amt
            WHEN ${cancelled_order.cancelled_date} >= ${fulfillment.left_purple_date} THEN ${TABLE}.gross_amt
            ELSE 0
          END;;
    filters: [customer_table.companyname: "-Mattress Firm,-Mattress Firm Promos,-Mattress Firm Warehouse", sales_order.channel: "DTC,Owned Retail", carrier: "-XPO,-Pilot", item.finished_good_flg: "Yes"]
  }

  measure: purple_sales_Fulfilled_in_SLA{
    label: "Purple Qty Fulfilled in SLA"
    group_label: "Fulfillment SLA ($)"
    view_label: "Fulfillment"
    drill_fields: [fulfillment_details*]
    hidden:  no
    type: sum_distinct
    sql_distinct_key: ${pk_concat} ;;
    sql: Case
          when ${cancelled_order.cancelled_date} < ${fulfillment.left_purple_date} Then 0
          when ${fulfillment.left_purple_date} <= ${Due_Date} THEN ${gross_amt}
          when ${sales_order.channel_id} = 2 and ${fulfillment.left_purple_date} <= ${sales_order.ship_order_by_date} THEN ${gross_amt}
          Else 0
        END;;
    filters: [customer_table.companyname: "-Mattress Firm,-Mattress Firm Promos,-Mattress Firm Warehouse", sales_order.channel: "DTC,Owned Retail", carrier: "-XPO,-Pilot", item.finished_good_flg: "Yes"]
  }

  measure: purple_zSLA_Achievement_prct {
    view_label: "Fulfillment"
    group_label: "Fulfillment SLA ($)"
    label: "Purple SLA $ Achievement %"
    description: "Source: looker.calculation"
    hidden: no
    value_format_name: percent_1
    type: number
    drill_fields: [fulfillment_details*]
    sql: Case when ${purple_sales_eligible_for_SLA} = 0 then 0 Else ${purple_sales_Fulfilled_in_SLA}/${purple_sales_eligible_for_SLA} End ;;
  }

  measure: white_glove_sales_eligible_for_SLA{
    label: "White Glove Qty Eligible SLA ($)"
    group_label: "Fulfillment SLA ($)"
    hidden:  no
    view_label: "Fulfillment"
    drill_fields: [fulfillment_details*]
    type: sum_distinct
    sql_distinct_key: ${pk_concat} ;;
    sql: CASE
            WHEN ${cancelled_order.cancelled_date} is null THEN ${TABLE}.gross_amt
            WHEN ${cancelled_order.cancelled_date} > ${SLA_Target_date} THEN ${TABLE}.gross_amt
            WHEN ${cancelled_order.cancelled_date} >= ${fulfillment.left_purple_date} THEN ${TABLE}.gross_amt
            ELSE 0
          END;;
    filters: [customer_table.companyname: "-Mattress Firm,-Mattress Firm Promos,-Mattress Firm Warehouse", sales_order.channel: "DTC,Owned Retail", carrier_raw: "XPO,Pilot,NEHDS,Ryder,Speedy Delivery, FragilePak, Purple Home Delivery, Select Express,CRST", item.Classification_Groups: "Kit, Finished Good"]
  }

  measure: white_glove_sales_Fulfilled_in_SLA{
    label: "White Glove ($) Fulfilled in SLA"
    group_label: "Fulfillment SLA ($)"
    view_label: "Fulfillment"
    drill_fields: [fulfillment_details*]
    hidden:  no
    type: sum_distinct
    sql_distinct_key: ${pk_concat} ;;
    sql: Case
          when ${cancelled_order.cancelled_date} < ${fulfillment.left_purple_date} Then 0
          when ${fulfillment.left_purple_date} <= ${Due_Date} THEN ${gross_amt}
          when ${sales_order.channel_id} = 2 and ${fulfillment.left_purple_date} <= ${sales_order.ship_order_by_date} THEN ${gross_amt}
          Else 0
        END;;
    filters: [customer_table.companyname: "-Mattress Firm,-Mattress Firm Promos,-Mattress Firm Warehouse", sales_order.channel: "DTC,Owned Retail", carrier_raw: "XPO,Pilot,NEHDS,Ryder,Speedy Delivery,FragilePak,Purple Home Delivery,Select Express,CRST", item.Classification_Groups: "Kit, Finished Good"]
  }

  measure: white_glove_zSLA_Achievement_prct {
    view_label: "Fulfillment"
    group_label: "Fulfillment SLA ($)"
    label: "White Glove SLA $ Achievement %"
    description: "Source: looker.calculation"
    hidden: no
    value_format_name: percent_1
    type: number
    drill_fields: [fulfillment_details*]
    sql: Case when ${white_glove_sales_eligible_for_SLA} = 0 then 0 Else ${white_glove_sales_Fulfilled_in_SLA}/${white_glove_sales_eligible_for_SLA} End ;;
  }

  measure: Mattress_Firm_sales_eligible_for_SLA{
    label: "Mattress Firm Qty Eligible SLA"
    group_label: "Fulfillment SLA ($)"
    hidden:  no
    view_label: "Fulfillment"
    drill_fields: [fulfillment_details*]
    type: sum_distinct
    sql_distinct_key: ${pk_concat} ;;
    sql: CASE
            WHEN ${cancelled_order.cancelled_date} is null THEN ${TABLE}.gross_amt
            WHEN ${cancelled_order.cancelled_date} > ${SLA_Target_date} THEN ${TABLE}.gross_amt
            WHEN ${cancelled_order.cancelled_date} >= ${fulfillment.left_purple_date} THEN ${TABLE}.gross_amt
            ELSE 0
          END;;
    filters: [customer_table.companyname: "Mattress Firm,Mattress Firm Promos,Mattress Firm Warehouse", sales_order.channel: "Wholesale"]
  }

  measure: Mattress_Firm_sales_Fulfilled_in_SLA{
    label: "Mattress Firm Qty Fulfilled in SLA"
    group_label: "Fulfillment SLA ($)"
    view_label: "Fulfillment"
    drill_fields: [fulfillment_details*]
    hidden:  no
    type: sum_distinct
    sql_distinct_key: ${pk_concat} ;;
    sql: Case
          when ${cancelled_order.cancelled_date} < ${fulfillment.left_purple_date} Then 0
          when ${fulfillment.left_purple_date} <= ${Due_Date} THEN ${gross_amt}
          when ${sales_order.channel_id} = 2 and ${fulfillment.left_purple_date} <= ${sales_order.ship_order_by_date} THEN ${gross_amt}
          Else 0
        END;;
    filters: [customer_table.companyname: "Mattress Firm,Mattress Firm Promos,Mattress Firm Warehouse", sales_order.channel: "Wholesale"]
  }

  measure: Mattress_Firm_zSLA_Achievement_prct {
    view_label: "Fulfillment"
    group_label: "Fulfillment SLA ($)"
    label: "Mattress Firm SLA $ Achievement %"
    description: "Source: looker.calculation"
    hidden: no
    value_format_name: percent_1
    type: number
    drill_fields: [fulfillment_details*]
    sql: Case when ${Mattress_Firm_sales_eligible_for_SLA} = 0 then 0 Else ${Mattress_Firm_sales_Fulfilled_in_SLA}/${Mattress_Firm_sales_eligible_for_SLA} End ;;
  }

  measure: other_sales_eligible_for_SLA{
    label: "Other Qty Eligible SLA"
    group_label: "Fulfillment SLA ($)"
    hidden:  no
    view_label: "Fulfillment"
    drill_fields: [fulfillment_details*]
    type: sum_distinct
    sql_distinct_key: ${pk_concat} ;;
    sql: CASE
            WHEN ${cancelled_order.cancelled_date} is null THEN ${TABLE}.gross_amt
            WHEN ${cancelled_order.cancelled_date} > ${SLA_Target_date} THEN ${TABLE}.gross_amt
            WHEN ${cancelled_order.cancelled_date} >= ${fulfillment.left_purple_date} THEN ${TABLE}.gross_amt
            ELSE 0
          END;;
    filters: [customer_table.companyname: "-Mattress Firm,-Mattress Firm Promos,-Mattress Firm Warehouse", sales_order.channel: "Wholesale"]
  }

  measure: other_sales_Fulfilled_in_SLA{
    label: "Other Qty Fulfilled in SLA"
    group_label: "Fulfillment SLA ($)"
    view_label: "Fulfillment"
    drill_fields: [fulfillment_details*]
    hidden:  no
    type: sum_distinct
    sql_distinct_key: ${pk_concat} ;;
    sql: Case
          when ${cancelled_order.cancelled_date} < ${fulfillment.left_purple_date} Then 0
          when ${fulfillment.left_purple_date} <= ${Due_Date} THEN ${gross_amt}
          when ${sales_order.channel_id} = 2 and ${fulfillment.left_purple_date} <= ${sales_order.ship_order_by_date} THEN ${gross_amt}
          Else 0
        END;;
    filters: [customer_table.companyname: "-Mattress Firm,-Mattress Firm Promos,-Mattress Firm Warehouse", sales_order.channel: "Wholesale"]
  }

  measure: other_zSLA_Achievement_prct {
    view_label: "Fulfillment"
    group_label: "Fulfillment SLA ($)"
    label: "Other SLA $ Achievement %"
    description: "Source: looker.calculation"
    hidden: no
    value_format_name: percent_1
    type: number
    drill_fields: [fulfillment_details*]
    sql: Case when ${other_sales_eligible_for_SLA} = 0 then 0 Else ${other_sales_Fulfilled_in_SLA}/${other_sales_eligible_for_SLA} End ;;
  }

  dimension: pk_concat_ful_sales_order {
    hidden: yes
    type: string
    sql:  NVL(${fulfillment.PK},'_')||'_'||NVL(${item_order},'_');;
  }

#Jared added cancelled date to fix issues where order had to be cancelled twice and PK issues arose in SLA % exec dash
  dimension: pk_concat {
    hidden: yes
    type: string
    sql:  NVL(${fulfillment.PK},'_')||'_'||NVL(${cancelled_order.item_order},'_')||NVL(${cancelled_order.cancelled_date},'_')||'_'||NVL(${item_order},'_');;
  }

  measure: Qty_eligible_for_SLA{
    label: "Qty Eligible SLA"
    group_label: "Fulfillment SLA (units)"
    view_label: "Fulfillment"
    description: "Source: looker.calculation"
    drill_fields: [fulfillment_details*]
    type: sum_distinct
    sql_distinct_key: NVL(${cancelled_order.cancelled_date},'_')||NVL(${sales_order.order_system},'0')||NVL(${sales_order_line.item_order},'0')|| NVL(${fulfillment.PK},'_') ;;
    sql: Case
            when ${cancelled_order.cancelled_date} is null and ${fulfilled_date} is not null THEN ${fulfilled_count_dim}
            when ${cancelled_order.cancelled_date} is null and ${fulfilled_date} is null THEN ${ordered_qty}
            When ${cancelled_order.cancelled_date} < ${SLA_Target_date} THEN 0
            WHEN ${cancelled_order.cancelled_date} > ${SLA_Target_date} THEN ${ordered_qty}
            WHEN ${cancelled_order.cancelled_date} >= ${fulfillment.left_purple_date} THEN ${ordered_qty}
            Else 0
            END ;;
  }
#change to qty shipped in SLA/on-time?
  measure: Qty_Fulfilled_in_SLA{
    label: "Qty Fulfilled in SLA"
    group_label: "Fulfillment SLA (units)"
    view_label: "Fulfillment"
    description: "Quantity that shipped on-time. Source: looker.calculation"
    drill_fields: [fulfillment_details*]
    type: sum_distinct
    sql_distinct_key: ${pk_concat} ;;
    sql: Case
        when ${cancelled_order.cancelled_date} < ${fulfilled_date} Then 0
        when ${fulfilled_date} <= ${Due_Date} THEN ${fulfilled_count_dim}
        when ${sales_order.channel_id} = 2 and ${fulfillment.left_purple_date} <= ${sales_order.ship_order_by_date} THEN ${fulfilled_count_dim}
        else 0
      END ;;
  }

#Added by Jared Dyer to prep for updating qty fulfilled and eligble for SLA Feb 2, 2022
  dimension: fulfilled_count_dim {
    group_label: " Advanced"
    label: "Units Fulfilled Test"
    description: "Count of items fulfilled. Source:netsuite.fulfillment"
    drill_fields: [sales_order_line.fulfillment_details*]
    sql: case when ${sales_order.transaction_type} = 'Cash Sale' or ${sales_order.source} in ('Amazon-FBA-US','Amazon-FBA-CA') then ${sales_order_line.total_units_raw}
      when nvl(${fulfillment.bundle_quantity_dim},0) > 0 then ${fulfillment.bundle_quantity_dim}
      else ${fulfillment.fulfillment_record_quantity_dim} END ;;}


  dimension: SLA_fulfilled {
    label: "     * Is Fulfilled in SLA"
    description: "Was item fulfilled in SLA window. Source: looker.calculation"
    view_label: "Fulfillment"
    type: yesno
    sql: nvl(${cancelled_order.cancelled_date},'2099-01-01') >= ${fulfilled_date} AND ${fulfilled_date} <= ${Due_Date} ;;
  }

  measure: SLA_Achievement_prct {
    view_label: "Fulfillment"
    label: "SLA Achievement %"
    group_label: "Fulfillment SLA (units)"
    description: "Source: looker.calculation"
    hidden: no
    value_format_name: percent_1
    type: number
    drill_fields: [fulfillment_details*]
    sql: Case when ${Qty_eligible_for_SLA} = 0 then 0 Else ${Qty_Fulfilled_in_SLA}/${Qty_eligible_for_SLA} End ;;
  }

  measure:Purple_Qty_eligible_for_SLA{
    label: "Purple Qty Eligible SLA"
    group_label: "Fulfillment SLA (units)"
    view_label: "Fulfillment"
    description: "Source: looker.calculation"
    drill_fields: [fulfillment_details*]
    type: sum_distinct
    sql_distinct_key: NVL(${cancelled_order.cancelled_date},'_')||NVL(${sales_order.order_system},'0')||NVL(${sales_order_line.item_order},'0')|| NVL(${fulfillment.PK},'_') ;;
    sql: Case
            when ${cancelled_order.cancelled_date} is null and ${fulfilled_date} is not null THEN ${fulfilled_count_dim}
            when ${cancelled_order.cancelled_date} is null and ${fulfilled_date} is null THEN ${ordered_qty}
            When ${cancelled_order.cancelled_date} < ${SLA_Target_date} THEN 0
            WHEN ${cancelled_order.cancelled_date} > ${SLA_Target_date} THEN ${ordered_qty}
            WHEN ${cancelled_order.cancelled_date} >= ${fulfillment.left_purple_date} THEN ${ordered_qty}
            Else 0
            END ;;
    filters: [customer_table.companyname: "-Mattress Firm,-Mattress Firm Promos,-Mattress Firm Warehouse", sales_order.channel: "DTC,Owned Retail", carrier: "-XPO,-Pilot", item.finished_good_flg: "Yes"]
  }

  measure: Purple_Qty_Fulfilled_in_SLA{
    label: "Purple Qty Fulfilled in SLA"
    group_label: "Fulfillment SLA (units)"
    view_label: "Fulfillment"
    description: "Source: looker.calculation"
    drill_fields: [fulfillment_details*]
    type: sum_distinct
    sql_distinct_key: ${pk_concat} ;;
    sql: Case
        when ${cancelled_order.cancelled_date} < ${fulfilled_date} Then 0
        when ${fulfilled_date} <= ${Due_Date} THEN ${fulfilled_count_dim}
        when ${sales_order.channel_id} = 2 and ${fulfillment.left_purple_date} <= ${sales_order.ship_order_by_date} THEN ${fulfilled_count_dim}
        else 0
      END ;;
    filters: [customer_table.companyname: "-Mattress Firm,-Mattress Firm Promos,-Mattress Firm Warehouse", sales_order.channel: "DTC,Owned Retail", carrier: "-XPO,-Pilot", item.finished_good_flg: "Yes"]
  }

  measure: Purple_SLA_Achievement_prct {
    view_label: "Fulfillment"
    label: "Purple SLA Achievement %"
    group_label: "Fulfillment SLA (units)"
    description: "Source: looker.calculation"
    hidden: no
    value_format_name: percent_1
    type: number
    drill_fields: [fulfillment_details*]
    sql: Case when ${Purple_Qty_eligible_for_SLA} = 0 then 0 Else ${Purple_Qty_Fulfilled_in_SLA}/${Purple_Qty_eligible_for_SLA} End ;;
  }

  measure:White_Glove_Qty_eligible_for_SLA{
    label: "White Glove Qty Eligible SLA"
    group_label: "Fulfillment SLA (units)"
    view_label: "Fulfillment"
    description: "Source: looker.calculation"
    drill_fields: [fulfillment_details*]
    type: sum_distinct
    sql_distinct_key: NVL(${cancelled_order.cancelled_date},'_')||NVL(${sales_order.order_system},'0')||NVL(${sales_order_line.item_order},'0')|| NVL(${fulfillment.PK},'_') ;;
    sql: Case
            when ${cancelled_order.cancelled_date} is null and ${fulfilled_date} is not null THEN ${fulfilled_count_dim}
            when ${cancelled_order.cancelled_date} is null and ${fulfilled_date} is null THEN ${ordered_qty}
            When ${cancelled_order.cancelled_date} < ${SLA_Target_date} THEN 0
            WHEN ${cancelled_order.cancelled_date} > ${SLA_Target_date} THEN ${ordered_qty}
            WHEN ${cancelled_order.cancelled_date} >= ${fulfillment.left_purple_date} THEN ${ordered_qty}
            Else 0
            END ;;
    filters: [customer_table.companyname: "-Mattress Firm,-Mattress Firm Promos,-Mattress Firm Warehouse", sales_order.channel: "DTC,Owned Retail", carrier_raw: "XPO,Pilot,NEHDS,Ryder,Speedy Delivery,FragilePak,Purple Home Delivery,Select Express,CRST", item.Classification_Groups: "Kit, Finished Good"]
  }

  measure:White_Glove_Qty_eligible_for_Carrier_SLA{
    label: "White Glove Qty Eligible Carrier SLA"
    group_label: "Fulfillment SLA (units)"
    view_label: "Fulfillment"
    description: "What was eligible to be fulfilled in SLA from the time the order was transmitted - Source: looker.calculation"
    drill_fields: [fulfillment_details*]
    type: sum_distinct
    sql_distinct_key: NVL(${cancelled_order.cancelled_date},'_')||NVL(${sales_order.order_system},'0')||NVL(${sales_order_line.item_order},'0')|| NVL(${fulfillment.PK},'_') ;;
    sql: Case
            when ${cancelled_order.cancelled_date} is null and ${fulfilled_date} is not null THEN ${fulfilled_count_dim}
            when ${cancelled_order.cancelled_date} is null and ${fulfilled_date} is null THEN ${ordered_qty}
            when ${transmitted_date_date} is null THEN 0
            When ${cancelled_order.cancelled_date} < ${White_Glove_Due_Date} THEN 0
            WHEN ${cancelled_order.cancelled_date} > ${White_Glove_Due_Date} THEN ${ordered_qty}
            WHEN ${cancelled_order.cancelled_date} >= ${fulfillment.left_purple_date} THEN ${ordered_qty}
            Else 0
            END ;;
    filters: [customer_table.companyname: "-Mattress Firm,-Mattress Firm Promos,-Mattress Firm Warehouse", sales_order.channel: "DTC,Owned Retail", carrier_raw: "XPO,Pilot,NEHDS,Ryder,Speedy Delivery,FragilePak,Purple Home Delivery,Select Express,CRST", item.Classification_Groups: "Kit, Finished Good"]
  }

  measure: White_Glove_Qty_Fulfilled_in_SLA{
    label: "White Glove Fulfilled in SLA"
    group_label: "Fulfillment SLA (units)"
    view_label: "Fulfillment"
    description: "Source: looker.calculation"
    drill_fields: [fulfillment_details*]
    type: sum_distinct
    sql_distinct_key: ${pk_concat} ;;
    sql: Case
        when ${cancelled_order.cancelled_date} < ${fulfillment.left_purple_date} Then 0
        when ${fulfilled_date} <= ${Due_Date} THEN ${fulfilled_count_dim}
        when ${sales_order.channel_id} = 2 and ${fulfillment.left_purple_date} <= ${sales_order.ship_order_by_date} THEN ${fulfilled_count_dim}
        else 0
      END ;;
    filters: [customer_table.companyname: "-Mattress Firm,-Mattress Firm Promos,-Mattress Firm Warehouse", sales_order.channel: "DTC,Owned Retail", carrier_raw: "XPO,Pilot,NEHDS,Ryder,Speedy Delivery,FragilePak,Purple Home Delivery,Select Express,CRST", item.Classification_Groups: "Kit, Finished Good"]
  }

 measure: White_Glove_Qty_Fulfilled_in_Carrier_SLA{
    label: "White Glove Fulfilled in Carrier SLA"
    group_label: "Fulfillment SLA (units)"
    view_label: "Fulfillment"
    description: "What was fulfilled in the CARRIER only SLA (ignoring time to transmit) - Source: looker.calculation"
    drill_fields: [fulfillment_details*]
    type: sum_distinct
    sql_distinct_key: ${pk_concat} ;;
    sql: Case
        when ${cancelled_order.cancelled_date} < ${fulfillment.left_purple_date} Then 0
        when ${fulfilled_date} <= ${White_Glove_Due_Date} THEN ${fulfilled_count_dim}
        when ${sales_order.channel_id} = 2 and ${fulfillment.left_purple_date} <= ${sales_order.ship_order_by_date} THEN ${fulfilled_count_dim}
        Else 0
      END ;;
    filters: [customer_table.companyname: "-Mattress Firm,-Mattress Firm Promos,-Mattress Firm Warehouse", sales_order.channel: "DTC,Owned Retail", carrier_raw: "XPO,Pilot,NEHDS,Ryder,Speedy Delivery,FragilePak,Purple Home Delivery,Select Express,CRST", item.Classification_Groups: "Kit, Finished Good"]
  }

  measure: White_Glove_SLA_Achievement_prct {
    view_label: "Fulfillment"
    label: "White Glove SLA Achievement %"
    group_label: "Fulfillment SLA (units)"
    description: "Source: looker.calculation"
    hidden: no
    value_format_name: percent_1
    type: number
    drill_fields: [fulfillment_details*]
    sql: Case when ${White_Glove_Qty_eligible_for_SLA} = 0 then 0 Else ${White_Glove_Qty_Fulfilled_in_SLA}/${White_Glove_Qty_eligible_for_SLA} End ;;
  }
  measure: Carrier_White_Glove_SLA_Achievement_prct {
    view_label: "Fulfillment"
    label: "Carrier ONLY White Glove SLA Achievement %"
    group_label: "Carrier Fulfillment SLA (units)"
    description: "Measuring the carrier on only from the time they had posession of the order - Source: looker.calculation"
    hidden: no
    value_format_name: percent_1
    type: number
    drill_fields: [fulfillment_details*]
    sql: Case when  --measuring the carrier on only from the time they had posession of the order
    ${White_Glove_Qty_eligible_for_Carrier_SLA} = 0 THEN 0 ELSE ${White_Glove_Qty_Fulfilled_in_Carrier_SLA}/${White_Glove_Qty_eligible_for_Carrier_SLA} End ;;

  }
  measure:Mattress_Firm_Qty_eligible_for_SLA{
    label: "Mattress Firm Qty Eligible SLA"
    group_label: "Fulfillment SLA (units)"
    view_label: "Fulfillment"
    description: "Source: looker.calculation"
    drill_fields: [fulfillment_details*]
    type: sum_distinct
    sql_distinct_key: NVL(${cancelled_order.cancelled_date},'_')||NVL(${sales_order.order_system},'0')||NVL(${sales_order_line.item_order},'0')|| NVL(${fulfillment.PK},'_') ;;
    sql: Case
            when ${cancelled_order.cancelled_date} is null and ${fulfilled_date} is not null THEN ${fulfilled_count_dim}
            when ${cancelled_order.cancelled_date} is null and ${fulfilled_date} is null THEN ${ordered_qty}
            When ${cancelled_order.cancelled_date} < ${SLA_Target_date} THEN 0
            WHEN ${cancelled_order.cancelled_date} > ${SLA_Target_date} THEN ${ordered_qty}
            WHEN ${cancelled_order.cancelled_date} >= ${fulfillment.left_purple_date} THEN ${ordered_qty}
            Else 0
            END ;;
    filters: [customer_table.companyname: "Mattress Firm,Mattress Firm Promos,Mattress Firm Warehouse", sales_order.channel: "Wholesale"]
  }

  measure: Mattress_Firm_Qty_Fulfilled_in_SLA{
    label: "Mattress Firm Fulfilled in SLA"
    group_label: "Fulfillment SLA (units)"
    view_label: "Fulfillment"
    description: "Source: looker.calculation"
    drill_fields: [fulfillment_details*]
    type: sum_distinct
    sql_distinct_key: ${pk_concat} ;;
    sql: Case
        when ${cancelled_order.cancelled_date} < ${fulfilled_date} Then 0
        when ${fulfilled_date} <= ${Due_Date} THEN ${fulfilled_count_dim}
        when ${sales_order.channel_id} = 2 and ${fulfillment.left_purple_date} <= ${sales_order.ship_order_by_date} THEN ${fulfilled_count_dim}
        else 0
      END ;;
    filters: [customer_table.companyname: "Mattress Firm,Mattress Firm Promos,Mattress Firm Warehouse", sales_order.channel: "Wholesale"]
  }

  measure: Mattress_Firm_SLA_Achievement_prct {
    view_label: "Fulfillment"
    label: "Mattress Firm SLA Achievement %"
    group_label: "Fulfillment SLA (units)"
    description: "Source: looker.calculation"
    hidden: no
    value_format_name: percent_1
    type: number
    drill_fields: [fulfillment_details*]
    sql: Case when ${Mattress_Firm_Qty_eligible_for_SLA} = 0 then 0 Else ${Mattress_Firm_Qty_Fulfilled_in_SLA}/${Mattress_Firm_Qty_eligible_for_SLA} End ;;
  }

  measure:Other_Qty_eligible_for_SLA{
    label: "Other Qty Eligible SLA"
    group_label: "Fulfillment SLA (units)"
    view_label: "Fulfillment"
    description: "Source: looker.calculation"
    hidden: yes
    drill_fields: [fulfillment_details*]
    type: sum_distinct
    sql_distinct_key: NVL(${cancelled_order.cancelled_date},'_')||NVL(${sales_order.order_system},'0')||NVL(${sales_order_line.item_order},'0')|| NVL(${fulfillment.PK},'_') ;;
    sql: Case
            when ${cancelled_order.cancelled_date} is null and ${fulfilled_date} is not null THEN ${fulfilled_count_dim}
            when ${cancelled_order.cancelled_date} is null and ${fulfilled_date} is null THEN ${ordered_qty}
            When ${cancelled_order.cancelled_date} < ${SLA_Target_date} THEN 0
            WHEN ${cancelled_order.cancelled_date} > ${SLA_Target_date} THEN ${ordered_qty}
            WHEN ${cancelled_order.cancelled_date} >= ${fulfillment.left_purple_date} THEN ${ordered_qty}
            Else 0
            END ;;
    filters: [customer_table.companyname: "-Mattress Firm,-Mattress Firm Promos,-Mattress Firm Warehouse", sales_order.channel: "Wholesale"]
  }

  measure: Other_Qty_Fulfilled_in_SLA{
    label: "Other Fulfilled in SLA"
    group_label: "Fulfillment SLA (units)"
    view_label: "Fulfillment"
    description: "Source: looker.calculation"
    drill_fields: [fulfillment_details*]
    hidden: yes
    type: sum_distinct
    sql_distinct_key: ${pk_concat} ;;
    sql: Case
        when ${cancelled_order.cancelled_date} < ${fulfilled_date} Then 0
        when ${fulfilled_date} <= ${Due_Date} THEN ${fulfilled_count_dim}
        when ${sales_order.channel_id} = 2 and ${fulfillment.left_purple_date} <= ${sales_order.ship_order_by_date} THEN ${fulfilled_count_dim}
        else 0
      END ;;
    filters: [customer_table.companyname: "-Mattress Firm,-Mattress Firm Promos,-Mattress Firm Warehouse", sales_order.channel: "Wholesale"]
  }

  measure: Other_SLA_Achievement_prct {
    view_label: "Fulfillment"
    label: "Other SLA Achievement %"
    group_label: "Fulfillment SLA (units)"
    description: "Source: looker.calculation"
    hidden: yes
    value_format_name: percent_1
    type: number
    drill_fields: [fulfillment_details*]
    sql: Case when ${Other_Qty_eligible_for_SLA} = 0 then 0 Else ${Other_Qty_Fulfilled_in_SLA}/${Other_Qty_eligible_for_SLA} End ;;
  }

  dimension: picked_packed_sla {
    label: "Picked/Packed is Fulfilled in SLA"
    hidden: yes
    description: "Was item fulfilled in SLA window for Left Purple Date to Minimun Ship by Date. Source: looker.calculation"
    type: yesno
    sql:  ${fulfillment.left_purple_date} <= ${sales_order_line.min_ship_date_date} or (${fulfillment.left_purple_date} is null and ${sales_order_line.min_ship_date_date} < current_date) ;;
  }

  measure: whlsl_units {
    view_label: "Fulfillment"
    label: "Wholesale SLA (units)"
    hidden: yes
    description: "How many items are there on the order to be shipped? Source: looker.calculation"
    drill_fields: [fulfillment_details*]
    type: sum
    sql: case when ${cancelled_order.cancelled_date} is null or (${cancelled_order.cancelled_date} >  ${sales_order.ship_by_date}) then ${ordered_qty} else 0 end ;;
  }

  measure: whlsl_on_time {
    hidden: yes
    view_label: "Fulfillment"
    group_label: "Fulfillment SLA (units)"
    label: "Wholesale Shipped on Time (% of units)"
    description: "Percent of units shipped out by the required ship-by date to arrive on time (Wholesale fulfilled/Wholesale units). Source:looker.calculation"
    drill_fields: [fulfillment_details*]
    value_format_name: percent_0
    type: number
    sql: ${whlsl_fulfilled}/nullif(${whlsl_units},0) ;;
  }

  measure: amazon_ca_sales {
    label: "Amazon-CA Gross Amount ($0.k)"
    description: "used to generate the sales by channel report. Source: looker.calculation"
    drill_fields: [sales_order_details*]
    hidden: yes
    value_format: "$#,##0,\" K\""
    type: sum
    sql: case when ${sales_order.channel_source} = 'AMAZON-CA' then ${TABLE}.gross_amt else 0 end ;;
  }

  measure: amazon_us_sales {
    label: "Amazon-US Gross Amount ($0.k)"
    description: "used to generate the sales by channel report. Source: looker.calculation"
    drill_fields: [sales_order_details*]
    hidden: yes
    value_format: "$#,##0,\" K\""
    type: sum
    sql: case when ${sales_order.channel_source} = 'AMAZON-US' then ${TABLE}.gross_amt else 0 end ;;
  }

  measure: shopify_ca_sales {
    label: "Shopify-CA Gross Amount ($0.k)"
    description: "used to generate the sales by channel report. Source: looker.calculation"
    drill_fields: [sales_order_details*]
    hidden: yes
    value_format: "$#,##0,\" K\""
    type: sum
    sql: case when ${sales_order.channel_source} = 'SHOPIFY-CA' then ${TABLE}.gross_amt else 0 end ;;
  }

  measure: shopify_us_sales {
    label: "Shopify-US GrossAmount ($0.k)"
    description: "US Shopify gross sales as reported in Netsuite. Source: looker.calculation"
    drill_fields: [sales_order_details*]
    hidden: yes
    value_format: "$#,##0,\" K\""
    type: sum
    sql: case when ${sales_order.channel_source} = 'SHOPIFY-US' then ${TABLE}.gross_amt else 0 end ;;
  }

  measure: unfulfilled_orders {
    group_label: "Gross Sales Unfulfilled"
    label: "Unfulfilled Orders ($)"
    view_label: "Fulfillment"
    description: "Orders placed that have not been fulfilled. Source: looker.calculation"
    value_format: "$#,##0"
    type: number
    #sql_distinct_key: ${pk_concat_ful_sales_order};;
    drill_fields: [fulfillment_details*]
    sql: (${total_gross_Amt}/nullif(${total_units},0))*(${total_units}-${fulfillment.count}) ;;
  }

  measure: unfulfilled_orders_units {
    group_label: "Gross Sales Unfulfilled"
    view_label: "Fulfillment"
    label: "Unfulfilled Orders (units)"
    description: "Orders placed that have not been fulfilled. Source:looker.calculation"
    type: number
    #sql_distinct_key: ${pk_concat_ful_sales_order};;
    drill_fields: [fulfillment_details*]
    sql: case when ${total_units} > ${fulfillment.count} then ${total_units}-${fulfillment.count} else 0 end;;
  }

  measure: fulfilled_orders {
    group_label: "Gross Sales Fulfilled"
    view_label: "Fulfillment"
    label: "Fulfilled Orders ($)"
    description: "Orders placed that have been fulfilled. Source:looker.calculation"
    value_format: "$#,##0"
    type: number
    #sql_distinct_key: ${pk_concat_ful_sales_order};;
    drill_fields: [fulfillment_details*]
    sql: (${total_gross_Amt}/nullif(${total_units},0))*(${fulfillment.count}) ;;
  }

  measure: fulfilled_orders_units {
    group_label: "Gross Sales Fulfilled"
    view_label: "Fulfillment"
    label: "Fulfilled Orders (units)"
    description: "Orders placed that have been fulfilled. Source: netsuite.sales_order_line"
    type: number
    #sql_distinct_key: ${pk_concat_ful_sales_order};;
    drill_fields: [fulfillment_details*]
    sql: ${fulfillment.count} ;;
  }

  measure: fulfilled_in_SLA {
    view_label: "Fulfillment"
    label: "West Fulfillment SLA"
    hidden: yes
    description: "Was the order fulfilled from Purple West within 3 days of order (as per website)? Source: looker.calculation"
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
    description: "Was this line item available to fulfill (not cancelled) within the SLA window? Source: looker.calculation"
    view_label: "Fulfillment"
    drill_fields: [fulfillment_details*]
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
    sql: case when ${cancelled_order.cancelled_date} is null or to_Date(${cancelled_order.cancelled_date}) > to_date(dateadd(d,4,${created_date})) then ${ordered_qty} else 0 end ;;
  }

  measure: SLA_achieved{
    label: "West SLA Achievement (% in 3 days)"
    hidden: yes
    description: "Percent of line items fulfilled by Purple West within 3 days of order. Source: looker.calculation"
    view_label: "Fulfillment"
    group_label: "Fulfillment SLA"
    type: number
    drill_fields: [fulfillment_details*]
    value_format_name: percent_1
    sql: case when datediff(day,${created_date},current_date) < 4 then null else ${fulfilled_in_SLA}/nullif(${SLA_eligible},0) end ;;
  }

  measure: manna_fulfilled_in_SLA {
    view_label: "Fulfillment"
    label: "Pilot Fulfillment SLA"
    hidden: yes
    description: "Was this item fulfilled from Manna within 14 days of order (as per website)? Source: looker.calculation"
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
    description: "Was this Manna line item available to fulfill (not cancelled) within the SLA window? Source: looker.calculation"
    view_label: "Fulfillment"
    drill_fields: [fulfillment_details*]
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
    description: "Was this item fulfilled from Manna within 14 days of order (as per website)? Source: looker.calculation"
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
    description: "Was this Manna line item available to fulfill (not cancelled) within the SLA window? Source: looker.calculation"
    view_label: "Fulfillment"
    drill_fields: [fulfillment_details*]
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
    hidden: yes
    label: "Pilot SLA Achievement (% in 14 days)"
    view_label: "Fulfillment"
    group_label: "Fulfillment SLA (units)"
    description: "Percent of line items fulfilled by Manna within 14 days of order. Source: looker.calculation"
    type: number
    drill_fields: [fulfillment_details*]
    value_format_name: percent_1
    sql:${manna_fulfilled_in_SLA_14days}/nullif(${manna_SLA_eligible_14days},0) ;;
  }

  measure: XPO_fulfilled_in_SLA {
    view_label: "Fulfillment"
    label: "XPO Fulfillment SLA"
    hidden: yes
    description: "Was this item fulfilled from Manna within 14 days of order (as per website)? Source: looker.calculation"
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
    description: "Was this Manna line item available to fulfill (not cancelled) within the SLA window? Source: looker.calculation"
    view_label: "Fulfillment"
    drill_fields: [fulfillment_details*]
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
    hidden: yes
    label: "XPO SLA Achievement (% in 14 days)"
    view_label: "Fulfillment"
    group_label: "Fulfillment SLA (units)"
    description: "Percent of line items fulfilled by Manna within 1 days of order. Source: looker.calculation"
    drill_fields: [fulfillment_details*]
    type: number
    value_format_name: percent_1
    sql: case when datediff(day,${created_date},current_date) > 14 then ${XPO_fulfilled_in_SLA}/nullif(${XPO_SLA_eligible},0) else null end ;;
  }

  measure: total_standard_cost {
    #hidden: yes
    label: "Total Standard Cost"
    description: "Total Cost (cost per unit * number of units). Source:netsuite.sales_order_line"
    group_label: "Product"
    drill_fields: [sales_order_details*]
    type:  sum
    value_format: "$#,##0.00"
    sql:  ${TABLE}.ordered_qty * ${standard_cost.standard_cost} ;;
  }

  dimension: unit_standard_cost {
    group_label: " Advanced"
    label: "Unit Standard Cost"
    description: "Source:netsuite.item_standard_cost"
    type:  number
    value_format: "$#,##0.00"
    sql: ${standard_cost.standard_cost} ;;
  }

  dimension: has_standard_cost {
    label: "    * Has Standard Cost"
    type: yesno
    description: "Data exists for what it costs Purple to make the product. Source:netsuite.sales_order_line"
    sql: ${standard_cost.standard_cost} is not null ;;
  }

  dimension: days_to_cancel {
    view_label: "Cancellations"
    label: "# days from order"
    description: "Number of days after initial order was placed that the order was cancelled. 0 means the order was cancelled on the day it was placed.
      Source: looker.calculation"
    type: tier
    style: integer
    hidden:  yes
    tiers: [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28]
    sql: datediff(d,${created_date},${cancelled_order.cancelled_date}) ;;
  }

  dimension_group: fulfilled {
    ## Scott Clark 1/8/21: Removed day_of_year for 2021 Y/Y adjustment. Add back final week of 2021
    view_label: "Fulfillment"
    label: "    Fulfilled"
    description:  "Date item within order shipped for Fed-ex orders, date customer receives delivery from Manna or date order is on truck for wholesale.
      Source: looker.calculation"
    type: time
    timeframes: [raw,hour,date, day_of_week,day_of_week_index, day_of_month, day_of_year, week, month, month_name, month_num, quarter, quarter_of_year, year, week_of_year]
    convert_tz: no
    #datatype: date
    sql: case when ${sales_order.transaction_type} = 'Cash Sale' or ${sales_order.source} = 'Amazon-FBA-US'  then ${sales_order.created} else ${fulfillment.fulfilled_F_raw} end ;;
  }

  dimension: ff_dayofquarterindex {   #returns day of quarter index int 1-92
    type: number
    view_label: "Fulfillment"
    description: "Returns a date's number position in its quarter. Ex. Jan 1 = 1; Feb 1 = 32."
    group_label: "Fulfilled Date"
    label: "Day of Quarter"
    hidden: yes
    sql: DATEDIFF('day',date_trunc('quarter',${fulfilled_date::date}),${fulfilled_date::date}) + 1 ;;
  }

  # dimension: fulfilled_week_of_year {
  #   ## Scott Clark 1/8/21: Added to replace week_of_year for better comps. Remove final week in 2021.
  #   type: number
  #   label: "Week of Year"
  #   view_label: "Fulfillment"
  #   group_label: "    Fulfilled Date"
  #   description: "2021 adjusted week of year number for fulfilled date"
  #   sql: case when ${fulfilled_date::date} >= '2020-12-28' and ${fulfilled_date::date} <= '2021-01-03' then 1
  #             when ${fulfilled_year::number}=2021 then date_part(weekofyear,${fulfilled_date::date}) + 1
  #             else date_part(weekofyear,${fulfilled_date::date}) end ;;
  # }

  dimension: fulf_adj_year {
    ## Scott Clark 1/8/21: Added to replace year for clean comps. Remove final week in 2021.
    type:  number
    label: "z - 2021 adj year"
    view_label: "Fulfillment"
    group_label: "    Fulfilled Date"
    description: "Year adjusted to align y/y charts when using week_number. DO NOT USE OTHERWISE"
    sql:  case when ${fulfilled_date::date} >= '2020-12-28' and ${fulfilled_date::date} <= '2021-01-03' then 2021 else ${fulfilled_year} end   ;;
  }

  dimension: sla_numerator_d {
    label: "SLA Numerator"
    hidden: yes
    view_label: "Fulfillment"
    group_label: "    SLA Percentage"
    type: yesno
    sql: ${fulfilled_date} < ${SLA_Target_date} ;;
  }
  dimension: due_last_7 {
    label: "Due Last 7"
    view_label: "Fulfillment"
    group_label: "    SLA Percentage"
    type: yesno
    sql: ${SLA_Target_date} >= dateadd(d,-9,current_date) and ${SLA_Target_date} <= dateadd(d,-2,current_date) ;;
  }
  measure: sla_numerator {
    type: number
    hidden: yes
    label: "SLA Numerator"
    view_label: "Fulfillment"
    group_label: "    SLA Percentage"
    sql: case when ${sla_numerator_d} = 'Yes' then ${fulfilled_orders_units} else 0 end ;;
  }
  measure: sla_denominator {
    type: number
    hidden: yes
    label: "SLA Denominator"
    view_label: "Fulfillment"
    group_label: "    SLA Percentage"
    sql: case when  ${sla_numerator_d} = 'Yes' and ${due_last_7} = 'Yes' then ${total_units}
      when ${sla_numerator_d} = 'Yes' and ${due_last_7} = 'No' then ${fulfillment.count}
      when ${sla_numerator_d} = 'No' and ${due_last_7} = 'Yes' then ${total_units}
      else 0
      end ;;
  }
  measure: sla_% {
   type: number
   label: "SLA %"
   hidden: yes
   view_label: "Fulfillment"
   group_label: "    SLA Percentage"
  sql: ${sla_numerator}/${sla_denominator}  ;;
  }


  measure: last_updated_date_fulfilled {
    view_label: "Fulfillment"
    group_label: " Advanced"
    label: "Last Updated Fulfilled."
    description: "Source: looker.calculation"
    type: date
    sql: MAX(${fulfilled_date}) ;;
    convert_tz: no
  }

  dimension: is_fulfilled {
    view_label: "Fulfillment"
    label: "     * Is Fulfilled"
    description:  "Has order been fulfilled? Source:netsuite.sales_order_line"
    type: yesno
    sql: ${fulfilled_date} is not null;;
  }

  dimension: fulfilled_status {
    view_label: "Fulfillment"
    #hidden: yes
    group_label: " Advanced"
    label: "Status"
    description: "Fulfillment status - On Time, Late, Open, Late (open). Source:looker.calculation"
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
    group_label: " Advanced"
    view_label: "Fulfillment"
    label: "  * Is Wholesale and Packed"
    description: "Source: looker.calculation"
    type: yesno
    #hidden: yes
    sql: ${sales_order.channel_id} = 2 and ${is_packed} ;;
  }

  dimension: xpo_pilot_packed {
    group_label: " Advanced"
    view_label: "Fulfillment"
    label: "  * Is Pilot or XPO and Packed"
    description: "Source: looker.calculation"
    type: yesno
    #hidden: yes
    sql: ${fulfillment.carrier} in ('XPO','Pilot') and ${is_packed} ;;
  }

  measure: days_to_cancel_measure {
    view_label: "Cancellations"
    label: "      Avg days from order to cancellation"
    description: "Number of days after initial order was placed that the order was cancelled. 0 means the order was cancelled on the day it was placed.
      Source: looker.calculation"
    type: average
    sql: datediff(d,${created_date},${cancelled_order.cancelled_date}) ;;
  }

  dimension: MTD_fulfilled_flg{
    group_label: "    Fulfilled Date"
    label: "z - Month to Date (current year)"
    #hidden:  yes
    view_label: "Fulfillment"
    description: "This field is for formatting on (week/month/quarter/year) to date reports. Source: looker.calculation"
    type: yesno
    sql: ${fulfilled_raw}::date <= current_date and month(${fulfilled_raw}::date) = month(dateadd(day,-1,current_date)) and year(${fulfilled_raw}::date) = year(current_date) ;;
  }

  dimension: ff_Before_today{
    group_label: "    Fulfilled Date"
    view_label: "Fulfillment"
    label: "z - Is Before Today (mtd)"
    description: "This field is for formatting on (week/month/quarter/year) to date reports. Source: looker.calculation"
    type: yesno
    sql: ${fulfilled_raw}::date < current_date;;
  }

  dimension: ff_current_week_num{
    group_label: "    Fulfilled Date"
    view_label: "Fulfillment"
    label: "z - Before Current Week"
    description: "Yes/No for if the date is in the last 30 days. Source: looker.calculation"
    type: yesno
    sql: date_trunc(week, ${fulfilled_raw}::date) < date_trunc(week, current_date) ;;
  }

  dimension: ff_prev_week{
    group_label: "    Fulfilled Date"
    view_label: "Fulfillment"
    label: "z - Previous Week"
    description: "Yes/No for if the date is in the last 30 days. Source: looker.calculation"
    type: yesno
    sql:  date_trunc(week, ${fulfilled_raw}::date) = dateadd(week, -1, date_trunc(week, current_date)) ;;
  }

  dimension: week_bucket_ff_old{
    group_label: "    Fulfilled Date"
    view_label: "Fulfillment"
    hidden: yes
    label: "z - Week Bucket"
    description: "Grouping by week, for comparing last week, to the week before, to last year. Source: looker.calculation"
    type: string
    sql:  CASE WHEN date_trunc(week, ${fulfilled_raw}::date) = date_trunc(week, current_date) THEN 'Current Week'
            WHEN date_trunc(week, ${fulfilled_raw}::date) = dateadd(week, -1, date_trunc(week, current_date)) THEN 'Last Week'
            WHEN date_trunc(week, ${fulfilled_raw}::date) = dateadd(week, -2, date_trunc(week, current_date)) THEN 'Two Weeks Ago'
            WHEN date_trunc(week, ${fulfilled_raw}::date) = date_trunc(week, dateadd(week, 1, dateadd(year, -1, current_date))) THEN 'Current Week LY'
            WHEN date_trunc(week, ${fulfilled_raw}::date) = date_trunc(week, dateadd(week, 0, dateadd(year, -1, current_date))) THEN 'Last Week LY'
            WHEN date_trunc(week, ${fulfilled_raw}::date) = date_trunc(week, dateadd(week, -1, dateadd(year, -1, current_date))) THEN 'Two Weeks Ago LY'
            ELSE 'Other' END ;;}

  dimension: week_bucket_ff{
    group_label: "    Fulfilled Date"
    view_label: "Fulfillment"
    label: "z - Week Bucket"
    description: "Grouping by week, for comparing last week, to the week before, to last year. Source: looker.calculation"
    type: string
    sql:  CASE WHEN ${fulfilled_week_of_year} = date_part (weekofyear,current_date) + 1 AND ${fulfilled_year} = date_part (year,current_date) THEN 'Current Week'
            WHEN ${fulfilled_week_of_year} = date_part (weekofyear,current_date) AND ${fulfilled_year} = date_part (year,current_date) THEN 'Last Week'
            WHEN ${fulfilled_week_of_year} = date_part (weekofyear,current_date) -1 AND ${fulfilled_year} = date_part (year,current_date) THEN 'Two Weeks Ago'
            WHEN ${fulfilled_week_of_year} = date_part (weekofyear,current_date) +1 AND ${fulfilled_year} = date_part (year,current_date) -1 THEN 'Current Week LY'
            WHEN ${fulfilled_week_of_year} = date_part (weekofyear,current_date) AND ${fulfilled_year} = date_part (year,current_date) -1 THEN 'Last Week LY'
            WHEN ${fulfilled_week_of_year} = date_part (weekofyear,current_date) -1 AND ${fulfilled_year} = date_part (year,current_date) -1 THEN 'Two Weeks Ago LY'
           ELSE 'Other' END ;;}

  measure: return_rate_units {
    group_label: "Return Rates"
    label: "Return Rate (% of units)"
    description: "Units returned/Units fulfilled. Source: looker.calculation"
    view_label: "Returns"
    type: number
    sql: ${return_order_line.units_returned} / nullif(${total_units},0) ;;
    value_format_name: "percent_1"
  }

  measure: return_rate_units_exch {
    group_label: "Return Rates"
    label: "Return Rate w/o Exchanges (% of units)"
    description: "(Units returned - Units Exchanged) / Units fulfilled. Source:looker.calculation"
    view_label: "Returns"
    type: number
    sql: (${return_order_line.units_returned}-${exchange_order_line.count}) / nullif(${total_units},0) ;;
    value_format_name: "percent_1"
  }

  measure: return_rate_dollars {
    group_label: "Return Rates"
    label: "Return Rate (% of $)"
    description: "Total $ returned / Total $ fulfilled. Source: looker.calculation"
    view_label: "Returns"
    type: number
    sql: ${return_order_line.total_gross_amt} / nullif(${total_gross_Amt},0) ;;
    value_format_name: "percent_1"
  }

  dimension_group: min_ship_date {
    label: "Minimum Ship by"
    description: "Merging Minimum Ship By and Ship By fields from netsuite into a single values.  Min then Ship by. Source:looker.calculation"
    view_label: "Fulfillment"
    drill_fields: [sales_order_line.fulfillment_details]
    type: time
    timeframes: [raw, date, day_of_week, day_of_month, week, week_of_year, month, month_name, quarter, quarter_of_year, year]
    sql: coalesce(${sales_order.ship_by_date},${sales_order.minimum_ship_date}::date) ;;
  }

  dimension_group: transmitted_date {
    label: "Transmitted"
    view_label: "Fulfillment"
    description: "Looking at the trasmitted date that matches the carrier from sales order line. Source:looker.calculation"
    type: time
    timeframes: [raw, date, hour_of_day, day_of_week, day_of_month, week, week_of_year, month, month_name, quarter, quarter_of_year, year]
    sql: case when ${carrier_raw} = 'Pilot' then ${v_transmission_dates.TRANSMITTED_TO_PILOT_raw}
      when ${carrier_raw} = 'Mainfreight' then ${v_transmission_dates.TRANSMITTED_TO_MAINFREIGHT_raw}
      when ${carrier_raw} = 'Carry Out' then ${created_raw}
      when ${carrier_raw} = 'Ryder' then ${N_3PL_TRANSMITTED_date}
      when ${carrier_raw} = 'NEHDS' then ${N_3PL_TRANSMITTED_date}
      when ${carrier_raw} = 'Purple Home Delivery' then ${N_3PL_TRANSMITTED_date}
      when ${carrier_raw} = 'Speedy Delivery' then ${N_3PL_TRANSMITTED_date}
      when ${carrier_raw} = 'FragilePak' then ${N_3PL_TRANSMITTED_date}
      when ${carrier_raw} = 'Select Express' then ${N_3PL_TRANSMITTED_date}
      when ${carrier_raw} = 'CRST' then ${N_3PL_TRANSMITTED_date}
      else ${v_transmission_dates.download_to_warehouse_edge_raw} end;;
  }

  measure: order_to_trasnmitted_days {
    label: "Order to Transmitted (days)"
    view_label: "Fulfillment"
    group_label: "Time Between Benchmarks"
    description: "The average difference between the order date and transmitted date. Source: looker.calculation"
    drill_fields: [sales_order_line.fulfillment_details]
    type: average
    value_format: "0.0"
    sql: datediff('day',${created_raw}::date,${transmitted_date_raw}::date) ;;
  }

  measure: order_to_ship_by_days {
    label: "Order to Ship By (days)"
    view_label: "Fulfillment"
    group_label: "Time Between Benchmarks"
    description: "The average difference between the order date and scheduled ship by date. Source: looker.calculation"
    drill_fields: [sales_order_line.fulfillment_details]
    type: average
    value_format: "0.0"
    sql: datediff('day',${created_raw}::date,${min_ship_date_raw}::date) ;;
  }

  measure: ship_by_to_left_purple_days {
    label: "Ship-by to Left Purple (days)"
    view_label: "Fulfillment"
    group_label: "Time Between Benchmarks"
    description: "The average difference between the scheduled ship-by date and left purple date. Source: looker.calculation"
    drill_fields: [sales_order_line.fulfillment_details]
    type: average
    value_format: "0.0"
    sql_distinct_key: ${fulfillment.PK} ;;
    sql: datediff('day',${min_ship_date_raw}::date,${fulfillment.left_purple_raw}::date) ;;
  }

  measure: order_to_left_purple_days {
    label: "Order to Left Purple (days)"
    view_label: "Fulfillment"
    group_label: "Time Between Benchmarks"
    description: "The average difference between the order date and left purple date. Source: looker.calculation"
    drill_fields: [sales_order_line.fulfillment_details]
    type: average
    value_format: "0.0"
    sql_distinct_key: ${fulfillment.PK} ;;
    sql: datediff('day',${created_raw}::date,${fulfillment.left_purple_raw}::date) ;;
  }

  measure: transmitted_to_left_purple_days {
    label: "Transmitted to Left Purple (days)"
    view_label: "Fulfillment"
    group_label: "Time Between Benchmarks"
    description: "The average difference between the transmitted date and left purple date. Source: looker.calculation"
    drill_fields: [sales_order_line.fulfillment_details]
    type: average
    value_format: "0.0"
    sql_distinct_key: ${fulfillment.PK} ;;
    sql: datediff('day',${transmitted_date_raw}::date,${fulfillment.left_purple_raw}::date) ;;
  }

  measure: transmitted_to_in_hand_days {
    label: "Transmitted to In Hand (days)"
    view_label: "Fulfillment"
    group_label: "Time Between Benchmarks"
    description: "The average difference between the transmitted date and in hand date. Source: looker.calculation"
    drill_fields: [sales_order_line.fulfillment_details]
    type: average
    value_format: "0.0"
    sql_distinct_key: ${fulfillment.PK} ;;
    sql: datediff('day',${transmitted_date_raw}::date,${fulfillment.in_hand_raw}::date) ;;
  }

  measure: order_to_in_hand_days {
    label: "Order to In Hand (days)"
    view_label: "Fulfillment"
    group_label: "Time Between Benchmarks"
    description: "The average difference between the order date and in hand date. Source: looker.calculation"
    drill_fields: [sales_order_line.fulfillment_details]
    type: average
    value_format: "0.0"
    sql_distinct_key: ${fulfillment.PK} ;;
    sql: datediff('day',${created_raw}::date,${fulfillment.in_hand_raw}::date) ;;
  }

  measure: left_purple_to_in_hand_days {
    label: "Left Purple to In Hand (days)"
    view_label: "Fulfillment"
    group_label: "Time Between Benchmarks"
    description: "The average difference between the left purple date and in hand date. Source: looker.calculation"
    drill_fields: [sales_order_line.fulfillment_details]
    type: average
    value_format: "0.0"
    sql_distinct_key: ${fulfillment.PK} ;;
    sql: datediff('day',${fulfillment.left_purple_raw}::date,${fulfillment.in_hand_raw}::date) ;;
  }

  measure: order_to_transmitted_hours {
    hidden: yes
    label: " Order to Transmitted (hours)"
    view_label: "Fulfillment"
    group_label: "Time Between Benchmarks"
    description: "The average difference between the order date and transmitted date in hours. Source: looker.calculation"
    drill_fields: [sales_order_line.fulfillment_details]
    type: average
    value_format: "0.0"
    sql: timediff('hour',${created_raw},${transmitted_date_raw}) ;;
  }

  measure: order_to_left_purple_hours {
    hidden: yes
    label: " Order to Left Purple (hours)"
    view_label: "Fulfillment"
    group_label: "Time Between Benchmarks"
    description: "The average difference between the order date and transmitted date in hours. Source: looker.calculation"
    drill_fields: [sales_order_line.fulfillment_details]
    type: average
    value_format: "0.0"
    sql_distinct_key: ${fulfillment.PK} ;;
    sql: timediff('hour',${created_raw},${fulfillment.left_purple_raw}) ;;
  }

  measure: transmitted_to_left_purple_hours {
    hidden: yes
    label: " Transmitted to Left Purple (hours)"
    view_label: "Fulfillment"
    group_label: "Time Between Benchmarks"
    description: "The average difference between the order date and transmitted date in hours. Source: looker.calculation"
    drill_fields: [sales_order_line.fulfillment_details]
    type: average
    value_format: "0.00"
    sql_distinct_key: ${fulfillment.PK} ;;
    sql: timediff('hour',${transmitted_date_raw},${fulfillment.left_purple_raw}) ;;
  }

  measure: transmitted_to_in_hand_hours {
    hidden: yes
    label: " Transmitted to In Hand (hours)"
    view_label: "Fulfillment"
    group_label: "Time Between Benchmarks"
    description: "The average difference between the order date and transmitted date in hours. Source: looker.calculation"
    drill_fields: [sales_order_line.fulfillment_details]
    type: average
    value_format: "0.00"
    sql_distinct_key: ${fulfillment.PK} ;;
    sql: timediff('hour',${transmitted_date_raw},${fulfillment.in_hand_raw}) ;;
  }

  measure: order_to_in_hand_hours {
    hidden: yes
    label: " Order to In Hand (hours)"
    view_label: "Fulfillment"
    group_label: "Time Between Benchmarks"
    description: "The average difference between the order date and transmitted date in hours. Source: looker.calculation"
    drill_fields: [sales_order_line.fulfillment_details]
    type: average
    value_format: "0.00"
    sql_distinct_key: ${fulfillment.PK} ;;
    sql: timediff('hour',${created_raw},${fulfillment.in_hand_raw}) ;;
  }

  measure: left_purple_to_in_hand_hours {
    hidden: yes
    label: " Left Purple to In Hand (hours)"
    view_label: "Fulfillment"
    group_label: "Time Between Benchmarks"
    description: "The average difference between the order date and transmitted date in hours. Source: looker.calculation"
    drill_fields: [sales_order_line.fulfillment_details]
    type: average
    value_format: "0.00"
    sql_distinct_key: ${fulfillment.PK} ;;
    sql: timediff('hour',${fulfillment.left_purple_raw},${fulfillment.in_hand_raw}) ;;
  }

  measure: mattress_sales {
    label: "Mattress Sales ($)"
    view_label: "Product"
    value_format: "$#,##0"
    group_label: "Products Sold ($/Units)"
    description: "Total amount of mattresses sold ($). Source: looker.calculation"
    drill_fields: [sales_order_details*]
    type: sum
    sql:  case when ${item.category_raw} = 'MATTRESS'
    -- Adding split kings here
    or ${item_id} in ('9815','9824','9786','9792','9818','9803','4412','4413','4409','4410','4411','3573')
    then ${gross_amt} else 0 end ;;
  }

  measure: mattress_units {
    label: "Mattress Sales (Units)"
    view_label: "Product"
    group_label: "Products Sold ($/Units)"
    description: "Total amount of mattresses sold (units). Source:looker.calculation"
    drill_fields: [sales_order_details*]
    type: sum
    sql:  case when ${item.category_raw} = 'MATTRESS'
    -- Adding split kings here
    or ${item_id} in ('9815','9824','9786','9792','9818','9803','4412','4413','4409','4410','4411','3573')
    then ${total_units_raw} else 0 end ;;
  }

  measure: base_sales {
    label: "Base Sales ($)"
    view_label: "Product"
    group_label: "Products Sold ($/Units)"
    value_format: "$#,##0"
    description: "Total amount of bases sold ($). Source: looker.calculation"
    drill_fields: [sales_order_details*]
    type: sum
    sql:  case when ${item.category_raw} = 'BASE' then ${gross_amt} else 0 end ;;
  }

  measure: base_units {
    label: "Base Sales (Units)"
    view_label: "Product"
    group_label: "Products Sold ($/Units)"
    description: "Total amount of bases sold (units). Source: looker.calculation"
    drill_fields: [sales_order_details*]
    type: sum
    sql:  case when ${item.category_raw} = 'BASE' then ${total_units_raw} else 0 end ;;
  }

  measure: bedding_sales {
    label: "Bedding Sales ($)"
    view_label: "Product"
    group_label: "Products Sold ($/Units)"
    value_format: "$#,##0"
    description: "Total amount of bedding items sold ($). Source:looker.calculation"
    drill_fields: [sales_order_details*]
    type: sum
    sql:  case when ${item.category_raw} = 'BEDDING' then ${gross_amt} else 0 end ;;
  }

  measure: bedding_units {
    label: "Bedding Sales (Units)"
    view_label: "Product"
    group_label: "Products Sold ($/Units)"
    description: "Total amount of bedding items sold (units). Source: looker.calculation"
    drill_fields: [sales_order_details*]
    type: sum
    sql:  case when ${item.category_raw} = 'BEDDING' then ${total_units_raw} else 0 end ;;
  }

  measure: pet_sales {
    label: "Pet Sales ($)"
    view_label: "Product"
    group_label: "Products Sold ($/Units)"
    value_format: "$#,##0"
    description: "Total amount of pet beds sold ($). Source: looker.calculation"
    drill_fields: [sales_order_details*]
    type: sum
    sql:  case when ${item.category_raw} = 'PET' then ${gross_amt} else 0 end ;;
  }

  measure: ppe_units {
    label: "PPE Sales (Units)"
    view_label: "Product"
    group_label: "Products Sold ($/Units)"
    description: "Total amount of PPE sold (units). Source: looker.calculation"
    drill_fields: [sales_order_details*]
    type: sum
    sql:  case when ${item.category_raw} = 'PPE' then ${total_units_raw} else 0 end ;;
  }

  measure: ppe_sales {
    label: "PPE Sales ($)"
    view_label: "Product"
    group_label: "Products Sold ($/Units)"
    value_format: "$#,##0"
    description: "Total amount of PPE sold ($). Source: looker.calculation"
    drill_fields: [sales_order_details*]
    type: sum
    sql:  case when ${item.category_raw} = 'PPE' then ${gross_amt} else 0 end ;;
  }

  measure: pet_units {
    label: "Pet Sales (Units)"
    view_label: "Product"
    group_label: "Products Sold ($/Units)"
    description: "Total amount of pet beds sold (units). Source: looker.calculation"
    drill_fields: [sales_order_details*]
    type: sum
    sql:  case when ${item.category_raw} = 'PET' then ${total_units_raw} else 0 end ;;
  }

  dimension: order_to_transmitted_sla {
    label: "Order to Transmitted SLA (yes/no)"
    view_label: "Fulfillment"
    hidden: yes
    description: "Was the order to transmitted time within SLA. Source: looker.calculation"
    type: string
    sql: ${transmitted_date_raw} <
      case when dayname(${transmitted_date_raw}) = 'Sunday' then dateadd('day', 1, ${transmitted_date_raw})
          when dayname(${transmitted_date_raw}) = 'Saturday' then dateadd('day', 2, ${transmitted_date_raw})
          when dayname(${transmitted_date_raw}) = 'Friday' and hour(${transmitted_date_raw}) > 14 then dateadd('day', 3, ${transmitted_date_raw})
          when hour(${transmitted_date_raw}) > 14  then dateadd('day', 1, ${transmitted_date_raw})
          else ${transmitted_date_raw} end ;;
  }

  measure: order_to_transmitted_in_sla {
    label: "Order to Transmitted in SLA (units)"
    view_label: "Fulfillment"
    drill_fields: [sales_order_line.fulfillment_details]
    hidden: yes
    type: sum
    sql: case when ${order_to_transmitted_sla} = 'yes' then ${ordered_qty} end ;;
  }

  measure: order_to_transmitted_not_in_sla {
    label: "Order to Transmitted not in SLA (units)"
    view_label: "Fulfillment"
    drill_fields: [sales_order_line.fulfillment_details]
    hidden: yes
    type: sum
    sql: case when ${order_to_transmitted_sla} = 'no' then ${ordered_qty} end ;;
  }

  measure: order_to_transmitted_sla_prct {
    view_label: "Fulfillment"
    group_label: "SLA Benchmarks %"
    label: "Order to Transmitted SLA %"
    description: "Source: looker.calculation"
    drill_fields: [sales_order_line.fulfillment_details]
    value_format_name: percent_1
    type: number
    sql: ${order_to_transmitted_in_sla}/(${order_to_transmitted_in_sla}+${order_to_transmitted_not_in_sla}) ;;
  }

  dimension: order_to_left_purple_sla {
    label: "Order to Left Purple SLA (yes/no)"
    view_label: "Fulfillment"
    hidden: yes
    description: "Was the order to left purple time within SLA. Source: looker.calculation"
    drill_fields: [sales_order_line.fulfillment_details]
    type: yesno
    sql:
    -- no left purple date
    case when ${fulfillment.left_purple_raw} is null then 'no'
        when  ${fulfillment.left_purple_raw} <
            dateadd('day'
            --dynamic hours based on carrier
            , case when ${carrier_raw} in ('XPO', 'Pilot') then 1 else 1 end
            --using min ship by if it has one
            , ${created_raw}
            )
        then 'yes'
        else 'no'
    end ;;
  }

  measure: order_to_left_purple_in_sla {
    label: "Order to Left Purple in SLA (units)"
    view_label: "Fulfillment"
    description: "Source: looker.calculation"
    drill_fields: [sales_order_line.fulfillment_details]
    hidden: yes
    type: sum
    sql: case when ${order_to_left_purple_sla} = 'yes' then ${ordered_qty} end ;;
  }

  measure: order_to_left_purple_not_in_sla {
    label: "Order to Left Purple not in SLA (units)"
    view_label: "Fulfillment"
    description: "Source: looker.calculation"
    drill_fields: [sales_order_line.fulfillment_details]
    hidden: yes
    type: sum
    sql: case when ${order_to_left_purple_sla} = 'no' then ${ordered_qty} end ;;
  }

  measure: order_to_left_purple_sla_prct {
    view_label: "Fulfillment"
    group_label: "SLA Benchmarks %"
    label: "Order to Left Purple SLA %"
    description: "Source: looker calculation"
    drill_fields: [sales_order_line.fulfillment_details]
    value_format_name: percent_1
    type: number
    sql: ${order_to_transmitted_in_sla}/(${order_to_transmitted_in_sla}+${order_to_transmitted_not_in_sla}) ;;
  }

  dimension: transmitted_to_left_purple_sla {
    label: "Transmitted to Left Purple SLA (yes/no)"
    view_label: "Fulfillment"
    hidden: yes
    description: "Was the transmitted to left purple time within SLA. Source: looker.calculation"
    type: yesno
    sql:
    -- no left purple date
    case when ${fulfillment.left_purple_raw} is null then 'no'
        when  ${fulfillment.left_purple_raw} <
            dateadd('day'
            --dynamic hours based on carrier
            , case when ${carrier_raw} in ('XPO', 'Pilot') then 1 else 1 end
            --using min ship by if it has one
            , NVL(${transmitted_date_raw},${created_raw})
            )
        then 'yes'
        else 'no'
    end ;;
  }

  measure: transmitted_to_left_purple_in_sla {
    label: "Transmitted to Left Purple in SLA (units)"
    view_label: "Fulfillment"
    description: "Source: looker.calculation"
    drill_fields: [sales_order_line.fulfillment_details]
    hidden: yes
    type: sum
    sql: case when ${transmitted_to_left_purple_sla} = 'yes' then ${ordered_qty} end ;;
  }

  measure: transmitted_to_left_purple_not_in_sla {
    label: "Transmitted to Left Purple not in SLA (units)"
    view_label: "Fulfillment"
    description: "Source: looker.calculation"
    drill_fields: [sales_order_line.fulfillment_details]
    hidden: yes
    type: sum
    sql: case when ${transmitted_to_left_purple_sla} = 'no' then ${ordered_qty} end ;;
  }

  measure: transmitted_to_left_purple_sla_prct {
    view_label: "Fulfillment"
    group_label: "SLA Benchmarks %"
    label: "Transmitted to Left Purple SLA %"
    description: "Source: looker.calculation"
    drill_fields: [sales_order_line.fulfillment_details]
    value_format_name: percent_1
    type: number
    sql: ${transmitted_to_left_purple_in_sla}/(${transmitted_to_left_purple_in_sla}+${transmitted_to_left_purple_not_in_sla}) ;;
  }

  dimension: order_to_in_hand_sla {
    label: "Order to In Hand SLA (yes/no)"
    view_label: "Fulfillment"
    hidden: yes
    description: "Was the order to in hand time within SLA. Source: looker.calculation"
    type: yesno
    sql:
    -- no left purple date
    case when ${fulfillment.in_hand_raw} is null then 'no'
        when  ${fulfillment.in_hand_raw} <
            dateadd('day'
            --dynamic hours based on carrier
            , case when ${carrier_raw} in ('XPO', 'Pilot') then 7 else 3 end
            --using min ship by if it has one
            , ${created_raw}
            )
        then 'yes'
        else 'no'
    end ;;
  }

  measure: order_to_in_hand_in_sla {
    label: "Order to In Hand in SLA (units)"
    view_label: "Fulfillment"
    description: "Source: looker.calculation"
    drill_fields: [sales_order_line.fulfillment_details]
    hidden: yes
    type: sum
    sql: case when ${order_to_in_hand_sla} = 'yes' then ${ordered_qty} end ;;
  }

  measure: order_to_in_hand_not_in_sla {
    label: "Order to In Hand not in SLA (units)"
    view_label: "Fulfillment"
    description: "Source: looker.calculation"
    drill_fields: [sales_order_line.fulfillment_details]
    hidden: yes
    type: sum
    sql: case when ${order_to_in_hand_sla} = 'no' then ${ordered_qty} end ;;
  }

  measure: order_to_in_hand_sla_prct {
    view_label: "Fulfillment"
    group_label: "SLA Benchmarks %"
    label: "Order to In Hand SLA %"
    description: "Source: looker.calculation"
    drill_fields: [sales_order_line.fulfillment_details]
    value_format_name: percent_1
    type: number
    sql: ${order_to_in_hand_in_sla}/(${order_to_in_hand_in_sla}+${order_to_in_hand_not_in_sla}) ;;
  }

  dimension: left_purple_to_in_hand_sla {
    label: "Left Purple to In Hand SLA (yes/no)"
    view_label: "Fulfillment"
    hidden: yes
    description: "Was the left purple to in hand time within SLA. Source: looker.calculation"
    type: yesno
    sql:
    -- no left purple date
    case when ${fulfillment.in_hand_raw} is null then 'no'
        when  ${fulfillment.in_hand_raw} <
            dateadd('day'
            --dynamic hours based on carrier
            , case when ${carrier_raw} in ('XPO', 'Pilot') then 6 else 2 end
            --using min ship by if it has one
            , NVL(${fulfillment.left_purple_raw},${created_raw})
            )
        then 'yes'
        else 'no'
    end ;;
  }

  measure: left_purple_to_in_hand_in_sla {
    label: "Left Purple to In Hand in SLA (units)"
    view_label: "Fulfillment"
    description: "Source: looker.calculation"
    drill_fields: [sales_order_line.fulfillment_details]
    hidden: yes
    type: sum
    sql: case when ${left_purple_to_in_hand_sla} = 'yes' then ${ordered_qty} end ;;
  }

  measure: left_purple_to_in_hand_not_in_sla {
    label: "Left Purple to In Hand not in SLA (units)"
    view_label: "Fulfillment"
    description: "Source: looker.calculation"
    drill_fields: [sales_order_line.fulfillment_details]
    hidden: yes
    type: sum
    sql: case when ${left_purple_to_in_hand_sla} = 'no' then ${ordered_qty} end ;;
  }

  measure: left_purple_to_in_hand_sla_prct {
    view_label: "Fulfillment"
    group_label: "SLA Benchmarks %"
    label: "Left Purple to In Hand SLA %."
    description: "Source: looker.calculation"
    drill_fields: [sales_order_line.fulfillment_details]
    value_format_name: percent_1
    type: number
    sql: ${left_purple_to_in_hand_in_sla}/(${left_purple_to_in_hand_in_sla}+${left_purple_to_in_hand_not_in_sla}) ;;
  }

  measure: upt {
    label: "UPT"
    view_label: "Sales Order"
    description: "Units per transaction. Source:looker.calculation"
    type: number
    value_format: "#,##0.00"
    sql: coalesce (${total_units}/nullif(count (distinct ${sales_order.order_id}),0),0) ;;
  }

  dimension: sub_channel {
    label: "DTC Sub-Category"
    group_label: " Advanced"
    view_label: "Sales Order"
    description: "Source: looker.calculation"
    type: string
    sql: case when ${zendesk_sell.inside_sales_order} or ${agent_name.name} is not null or ${sales_order.source} = 'Direct Entry' then 'Inside Sales'
      when ${sales_order.source} in ('Amazon-FBM-US','Amazon-FBA','Amazon-FBA-US','Amazon-FBA-CA','eBay') then 'Merchant'
      when ${sales_order.channel} = 'DTC' then 'Website'
      else 'Other' end;;
  }

  dimension: order_age_bucket3 {
    view_label: "Fulfillment"
    group_label: " Advanced"
    label: "Order Age (bucket 3)"
    hidden: yes
    description: "Number of days between sales order creation and the date order was fulfilled (1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21)
    Source: netsuite.sales_order"
    type:  tier
    tiers: [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21]
    style: integer
    sql: datediff(day,${sales_order_line.created_date}, ${sales_order_line.fulfilled_date}) ;;
  }

  dimension: order_age_bucket_transmitted {
    view_label: "Fulfillment"
    group_label: " Advanced"
    label: "Order Age Bucket (Transmitted)"
    hidden: no
    description: "Number of days between today and when order was transmitted (1,2,3,4,5,6,7,11,15,21)
    Source: netsuite.sales_order_line"
    type:  tier
    tiers: [1,2,3,4,5,6,7,11,15,21]
    style: integer
    sql: datediff(day,${transmitted_date_date}, ${current_date}) ;;
  }

  measure: adj_gross_amt {
    ##added by Scott on 6/1/20
    label: " 5 - Adjusted gross sales"
    description: "GWP items split allocation between to free product, netted from main product. Current through 5/28/2020.
    Source: netsuite.sales_order_line"
    view_label: "zz Margin Calculations"
    value_format: "$#,##0"
    type: sum
    sql: nvl(${TABLE}.adjusted_gross_amt,0) ;;
  }

  dimension: adj_gross_amt_dim {
    ##added by Scott on 6/1/20
    description: "used for calculating wholesale freight in shipping view"
    hidden: yes
    type: number
    sql: nvl(${TABLE}.adjusted_gross_amt,0) ;;
  }

  measure: order_discounts {
    ##added by Scott on 6/1/20
    label: " 2 - Order-level discounts"
    description: "Order-level discounts such as MD, MED, FR with promotional discounts removed. Current through 5/31/2020
    Source: netsuite.sales_order_line"
    view_label: "zz Margin Calculations"
    value_format: "$#,##0"
    type: sum
    sql: nvl(${TABLE}.order_discount_amt,0) ;;
  }

  measure: promo_discounts {
    ##added by Scott on 6/1/20
    label: " 3 - Promotional discounts"
    description: "Total promotional discounts applied to order. This includes call center promo-matching. Current through 5/31/2020.
    Source: netsuite.sales_order_line"
    view_label: "zz Margin Calculations"
    value_format: "$#,##0"
    type: sum
    sql: nvl(${TABLE}.adjusted_discount_amt,0) ;;
  }

  measure: cc_discounts {
    ##added by Scott on 6/1/20
    label: " 4 - Call center discounts"
    description: "These are special discounts applied at the call center as apologies or other free product. Current through 5/31/2020.
    Source: netsuite.sales_order_line"
    view_label: "zz Margin Calculations"
    value_format: "$#,##0"
    type: sum
    sql: nvl(${TABLE}.cc_discount,0) ;;
  }

  measure: full_IMU {
    ##added by Scott on 6/1/20
    label: " 1 - IMU"
    description: "This is the MSRP or full, pre-discounted price of the item. Current through 5/31/2020.
    Source: netsuite.sales_order_line"
    view_label: "zz Margin Calculations"
    value_format: "$#,##0"
    type: sum
    sql: ${pre_discount_amt} ;;
  }

  measure: COGS {
    #hidden: yes
    label: " 6 - Total Standard Cost"
    description: "Total Cost (cost per unit * number of units). Source: netsuite.sales_order_line"
    view_label: "zz Margin Calculations"
    drill_fields: [sales_order_details*]
    type:  number
    value_format: "$#,##0"
    sql:  ${total_standard_cost} ;;
  }

  measure: wholesale_freight {
    hidden:  yes
    label: "wholesale Freight"
    description: "For wholesale, we're using % to sales for this calculation"
    view_label: "zz Margin Calculations"
    value_format: "$#,##0"
    type: sum
    sql: case when ${customer_table.companyname} ilike '%Raymour & Flanigan Furniture%' then 0.03* ${TABLE}.gross_amt
              when ${customer_table.companyname} ilike '%d. noblin%' then 0.04*  ${TABLE}.gross_amt
              when ${customer_table.companyname} ilike '%Macy%' then 0.095*  ${TABLE}.gross_amt
              when ${customer_table.companyname} ilike '%Mattress Firm%' then 0.03* ${TABLE}.gross_amt
              when ${customer_table.companyname} ilike '%Mathis Brothers Furniture%' then 0.03* ${TABLE}.gross_amt
              when ${customer_table.companyname} ilike '%Big Sandy%' then 0.03* ${TABLE}.gross_amt
              when ${customer_table.companyname} ilike '%City Furniture%' then 0.03* ${TABLE}.gross_amt
              when ${customer_table.companyname} ilike '%Living Spaces%' then 0.03* ${TABLE}.gross_amt
              when ${customer_table.companyname} ilike '%HOM Furniture%' then 0.03* ${TABLE}.gross_amt
              when ${customer_table.companyname} ilike '%Levin Furniture%' then 0.03* ${TABLE}.gross_amt
              when ${customer_table.companyname} ilike '%Miskelly%s Furnitur%' then 0.03* ${TABLE}.gross_amt
              when ${customer_table.companyname} ilike '%Ivan Smith%' then 0.03* ${TABLE}.gross_amt
              when ${customer_table.companyname} ilike '%Nebraska Furniture Ma%' then 0.03* ${TABLE}.gross_amt
              when ${customer_table.companyname} ilike '%Cardi%s Furniture%' then 0.03* ${TABLE}.gross_amt
              when ${customer_table.companyname} ilike '%Gardner White%' then 0.03* ${TABLE}.gross_amt
              when ${customer_table.companyname} ilike '%Morris Furniture%' then 0.03* ${TABLE}.gross_amt
              when ${customer_table.companyname} ilike '%Darvin Furniture%' then 0.03* ${TABLE}.gross_amt
              when ${customer_table.companyname} ilike '%Furniture Ro%' then 0.03* ${TABLE}.gross_amt
              when ${customer_table.companyname} ilike '%STEINHAFELS%' then 0.03* ${TABLE}.gross_amt
              when ${customer_table.companyname} ilike '%North Dakota Mattress Venture%' then 0.040* ${TABLE}.gross_amt
              when ${customer_table.companyname} ilike '%OK Mattress Ventures%' then 0.040* ${TABLE}.gross_amt
              when ${customer_table.companyname} ilike '%South Dakota Mattress Ventures%' then 0.040* ${TABLE}.gross_amt
              when ${customer_table.companyname} ilike '%Rooms To Go%' then 0.030* ${TABLE}.gross_amt else 0 end  ;;
  }


  measure: freight {
    hidden:  no
    label: " 8 - Total Freight"
    description: "This is the total shipping charges incurred across all shipping partners for any individual order/item combo. For wholesale, we're using % to sales for this calculation"
    view_label: "zz Margin Calculations"
    value_format: "$#,##0"
    type: number
    sql: nvl(${fulfillment.total_shipping},0)+nvl(${wholesale_freight},0) ;;
  }


##  measure: return_amt {
##    label: " 7 - Return $"
##    description: "For orders fulfilled more than 130 days ago, actual values are used. All others use the most recent rolling 90 day average. Source: looker.calculation"
##    view_label: "zz Margin Calculations"
##    value_format: "$#,##0"
##    type: number
##    sql_distinct_key: ${fulfillment.PK}||'-'||${return_order.primary_key}||'-'||${item_order} ;;
##    sql:  case when (${fulfilled_date} is null
##                or (datediff(d,${fulfilled_date},current_date)<130) and ${sales_order.channel_id} in (1,5)) then ${item_return_rate.return_rate_dim}*${adj_gross_amt}
##                else nvl(${return_order_line.total_returns_completed_dollars_dim},0) end ;;
##  }

##  measure: return_clawback {
##    label: " 7a - Return clawback"
##    description: "This is an contra-sales adjustment for the free items on a GWP when the main item is returned. For orders fulfilled more than 130 days ago, actual values are used. All others use the most recent rolling 90 day average. Source: looker.calculation"
##    view_label: "zz Margin Calculations"
##    value_format: "$#,##0"
##    type: number
##    sql_distinct_key: ${fulfillment.PK}||'-'||${return_order.primary_key}||'-'||${item_order} ;;
##    sql:  case when (${fulfilled_date} is null
##                or (datediff(d,${fulfilled_date},current_date)<130) and ${sales_order.channel_id} in (1,5)) then ${item_return_rate.return_clawback}*${adj_gross_amt}
##                else nvl(${return_order_line.total_returns_completed_dollars_dim},0) end ;;
##  }

  measure: merch_fees {
    label: " 9 - Merchant fees"
    description: "Estimate of merchant fees for transaction, based on 4.97% blended affirm rate, 15% amazon affiliate rate and 2.55% for all others.
      Source: looker.calculation"
    view_label: "zz Margin Calculations"
    value_format: "$#,##0"
    type: sum
    sql: case when ${sales_order.channel_id} = 2 then 0
              when ${sales_order.source} in ('Amazon-FBM-US','Amazon-FBA','Amazon FBA - US') then 0.15
              when ${sales_order.payment_method} ilike 'AFFIRM' then 0.0497
              when ${sales_order.payment_method} ilike 'SPLITIT' then 0.04
              else 0.0255 end * nvl(${TABLE}.adjusted_gross_amt,0) ;;
    }

  measure: direct_affiliate {
    label: "10 - Affiliate commissions"
    description: "Actual commission paid on order to affiliate partner. Source: looker.calculation"
    view_label: "zz Margin Calculations"
    value_format: "$#,##0"
    type: sum
    sql: case when ${affiliate_sales_order.comm_rate} < 0 then 0 else nvl(${affiliate_sales_order.comm_rate},0)*nvl(${TABLE}.adjusted_gross_amt,0) end ;;
  }

  measure: warranty_accrual {
    label: "11 - Warranty"
    description: "Esimate of future warranty incurred. Calculated at 1% of gross sales. Source: looker.calculation"
    view_label: "zz Margin Calculations"
    value_format: "$#,##0"
    type: sum
    sql: case when ${customer_table.companyname} ilike '%mathis bro%' then 0.02
              when ${customer_table.companyname} ilike '%rooms to go%' then 0.085
              when ${sales_order.channel_id} = 2 then 0
              else 0.01 end *nvl(${TABLE}.adjusted_gross_amt,0) ;;
  }

  measure: vir {
    label: "12a - Wholesale VIR"
    description: "Estimate of wholesale VOlume Incentive Rebate dollars, based on % of fulfilled gross orders.Removed pre net-revenue estimate"
    view_label: "zz Margin Calculations"
    value_format: "$#,##0"
    type: sum
    sql: case when ${customer_table.companyname} ilike '%Mattress Firm%' then 0.035 else 0 end * nvl(${TABLE}.adjusted_gross_amt,0) ;;
    }

  measure: mdf {
    label: "12 - Wholesale MDF"
    description: "Estimate of wholesale MDF dollars, based on % of fulfilled gross orders. Includes, Co-op, SPIFF, VIR, comfort exchange"
    view_label: "zz Margin Calculations"
    value_format: "$#,##0"
    type: sum
    sql: case when ${customer_table.companyname} ilike '%Bloomingdale%' then 0.0145
          when ${customer_table.companyname} ilike '%Raymour & Flanigan Furniture%' then 0.05
          when ${customer_table.companyname} ilike '%Sleep Country%' then 0.115
          when ${customer_table.companyname} ilike '%Macy%' then 0.095
          when ${customer_table.companyname} ilike '%Mattress Firm%' then 0.029
          when ${customer_table.companyname} ilike '%Mathis Brothers Furniture%' then 0.05
          when ${customer_table.companyname} ilike '%Big Sandy%' then 0.04
          when ${customer_table.companyname} ilike '%City Furniture%' then 0.04
          when ${customer_table.companyname} ilike '%Living Spaces%' then 0.04
          when ${customer_table.companyname} ilike '%HOM Furniture%' then 0.035
          when ${customer_table.companyname} ilike '%Levin Furniture%' then 0.035
          when ${customer_table.companyname} ilike '%Miskelly%s Furnitur%' then 0.035
          when ${customer_table.companyname} ilike '%Ivan Smith%' then 0.035
          when ${customer_table.companyname} ilike '%Nebraska Furniture Ma%' then 0.035
          when ${customer_table.companyname} ilike '%Cardi%s Furniture%' then 0.035
          when ${customer_table.companyname} ilike '%Gardner White%' then 0.035
          when ${customer_table.companyname} ilike '%Morris Furniture%' then 0.035
          when ${customer_table.companyname} ilike '%Darvin Furniture%' then 0.035
          when ${customer_table.companyname} ilike '%Furniture Ro%' then 0.02
          when ${customer_table.companyname} ilike '%STEINHAFELS%' then 0.02
          else 0 end * nvl(${TABLE}.adjusted_gross_amt,0) ;;
    }

  measure: promo_adj {
    ##added by Scott on 6/1/20
    label: "13 - Wholesale promo adj"
    description: "This is a calculation for tier 1 holiday promo matching as well as GWP accruals for certain vendors."
    view_label: "zz Margin Calculations"
    value_format: "$#,##0"
    type: sum
    sql: case when ${customer_table.companyname} ilike '%furniture row%' then 0.044*nvl(${TABLE}.adjusted_gross_amt,0)
              when ${customer_table.companyname} ilike '%steinheifal%' then 0.044*nvl(${TABLE}.adjusted_gross_amt,0)
              when ${sales_order.channel_id} = 2 then 0.029*nvl(${TABLE}.adjusted_gross_amt,0)
              else 0 end ;;
  }


  measure: net_revenue {
    label: "Net revenue estimate"
    description: "Estimated net revenue: gross revenue (IMU) less discounts, less cancellations, less returns, less VIR"
    type: number
    view_label: "zz Margin Calculations"
    value_format: "$#,##0"
    sql: ${adj_gross_amt}-${vir}-${item_return_rate.adj_return_amt}-${item_return_rate.adj_return_clawback}-${mdf}-${promo_adj} ;;
  }

  measure: gross_margin {
    ##added by Scott Clark 11/25/2020
    label: "Gross margin"
    description: "Total margin dollars after all direct product and order related expenses are netted out"
    type: number
    view_label: "zz Margin Calculations"
    value_format: "$#,##0"
    sql: ${net_revenue}-${COGS}-${direct_affiliate}-${warranty_accrual}-${merch_fees}-${freight} ;;
  }

  measure: gm_rate{
    ##added by Scott Clark 11/25/2020
    label: "Gross margin %"
    description: "Gross margin / adjusted gross sales"
    type: number
    view_label: "zz Margin Calculations"
    value_format: "0.0%"
    sql: ${gross_margin}/nullif(${adj_gross_amt},0)  ;;
  }

  measure: roa_sales {
    label: "Gross Sales - for ROAs"
    group_label: "Gross Sales"
    description: "The sales included in calculating return on adspend (ROAs).  100% of DTC and Owned Retail, 50% of Wholesale. Source:looker.calculation"
    value_format: "$#,##0"
    type: sum
    sql: case when ${sales_order.channel_id} in (1,5) then ${gross_amt}
      when ${sales_order.channel_id} = 2 then ${gross_amt}*0.5
      else 0 end;;
  }

  measure: max_units {
    group_label: "Gross Sales"
    label: "Max Gross Sales (units)"
    type: sum
    sql: max(${TABLE}.ordered_qty) over partition by ${item.sku_id} ;;
  }

  measure: insidesales_sales {
    group_label: "Gross Sales"
    description: "Summing Gross Sales from orders placed by an insidesales sales agent.  Excluding warranties and exchanges. Excluding customer care"
    label: "Sales - Inside Sales Team ($)"
    type: sum
    value_format: "$#,##0"
    sql: case when ${agent_name.merged_name} is not null
      and ${agent_name.zendesk_sell_id} is not null
      and NOT ${sales_order.is_exchange}
      and NOT ${sales_order.is_upgrade}
      and NOT ${sales_order.warranty_order_flg}
      and ${sales_order.gross_amt} > 0
      then ${gross_amt} else 0 end;;
  }

  measure: insidesales_orders {
    hidden: no
    group_label: "Gross Sales"
    label: "Sales - Inside Sales Team (#)"
    type: count_distinct
    value_format: "#,##0"
    sql: case when ${agent_name.merged_name} is not null
      and ${agent_name.zendesk_sell_id} is not null
      and NOT ${sales_order.is_exchange}
      and NOT ${sales_order.is_upgrade}
      and NOT ${sales_order.warranty_order_flg}
      and ${sales_order.gross_amt} > 0
      then ${sales_order.order_id} else 0 end;;
  }

  measure: owned_retail_sales {
    group_label: "Gross Sales"
    description: "Summing Gross Sales from orders placed by an insidesales sales agent.  Excluding warranties and exchanges. Excluding customer care"
    label: "Sales - Owned Retail ($)"
    hidden: yes
    type: sum
    value_format: "$#,##0"
    filters: [sales_order.channel: "Owned Retail",sales_order.is_exchange_upgrade_warranty: "No"]
    sql:  ${gross_amt} ;;
  }

  measure: customer_care_sales {
    hidden: no
    group_label: "Gross Sales"
    label: "Sales - Customer Care Team ($)"
    description: "Summing Gross Sales where the order was from a customer care agent. Excluding warranties and exchanges."
    type: sum
    value_format: "$#,##0"
    sql: case when ${agent_name.merged_name} is not null
      and ${agent_name.zendesk_sell_id} is null
      and NOT ${sales_order.is_exchange}
      and NOT ${sales_order.is_upgrade}
      and NOT ${sales_order.warranty_order_flg}
      then ${gross_amt} else 0 end;;
  }

  measure: customer_care_orders {
    group_label: "Gross Sales"
    label: "Sales - Customer Care Team (#)"
    type: count_distinct
    value_format: "#,##0"
    sql: case when ${agent_name.merged_name} is not null
      and ${agent_name.zendesk_sell_id} is null
      and NOT ${sales_order.is_exchange}
      and NOT ${sales_order.is_upgrade}
      and NOT ${sales_order.warranty_order_flg}
      then ${sales_order.order_id} else 0 end;;
  }

##Creating Mattress ASP -Jared
  measure: asp_gross_amt_mattress {
    hidden: yes
    type: sum
    filters: [free_item: "No" , item.category_name: "MATTRESS", item.line_raw: "-COVER" ]
    sql: ${TABLE}.gross_amt ;;
  }

  measure: asp_total_units_mattress {
    hidden: yes
    type: sum
    filters: [free_item: "No",gross_amt: "> 0" , item.category_name: "MATTRESS", item.line_raw: "-COVER" ]
    sql: ${TABLE}.ordered_qty ;;
  }

  measure: asp_mattress {
    hidden: no
    label: "Mattress ASP"
    description: "Mattress Average Sales Price, this measure is excluding free items ($0 orders). Source: looker.calculation"
    type: number
    value_format: "$#,##0"
    sql:case when ${asp_total_units_mattress} > 0 then ${asp_gross_amt_mattress}/${asp_total_units_mattress} else 0 end ;;
  }


  set: fulfill_details {
    fields: [fulfill_details*]
  }

  set: fulfillment_details {
    fields: [order_id
      , customer_table.customer_id
      , order_id
      , sales_order.tranid
      , sales_order.ship_by_date,sales_order.minimum_ship_date
      , SLA_Target_date
      , item.product_description
      , Qty_Fulfilled_in_SLA
      , total_units
      , SLA_Achievement_prct
      , item_id
      , created_date
      , fulfilled_date
      , carrier
      , DTC_carrier
      , fulfillment.in_hand
      , fulfillment.left_purple
      , fulfillment.transmitted_date]
  }

  set: sales_order_details {
    fields: [order_id
      , sales_order.tranid
      , created_date
      , fulfilled_date
      , customer_table.customer_id
      , location, sale_order.source
      , total_units.gross_amt
      , item.item_id
      , item.sku_id
      , item.category_name
      , item.line_raw
      , item.model_raw
      , item.product_description_raw
      , item.color
      , total_gross_Amt_non_rounded
      , total_units
      , total_standard_cost
      , total_discounts
      , agent_name.merged_name]
  }

}
