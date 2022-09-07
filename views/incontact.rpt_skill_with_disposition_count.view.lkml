view: rpt_skill_with_disposition_count {
  ##sql_table_name: CUSTOMER_CARE.RPT_SKILL_WITH_DISPOSITION_COUNT ;;
derived_table: {
  sql: select * from CUSTOMER_CARE.RPT_SKILL_WITH_DISPOSITION_COUNT where contacted::date < '2050-01-01' ;;
}

dimension: primary_key {
  type: string
  hidden: yes
  primary_key: yes
  sql: ${TABLE}.contacted || ${TABLE}.contact_info_from ;;
}

  dimension: abandon_time {
    description: "How long a person was in queue before abandoning the call (without speaking to an agent). Source: incontact. rpt_skill_with_disposition_count"
    type: number
    hidden: no
    sql: ${TABLE}."ABANDON_TIME" ;;
  }

  dimension: acw_time {
    description: "After Call Work Time (making notes, etc. before they're available for another call). Source: incontact. rpt_skill_with_disposition_count"
    type: number
    hidden: no
    sql: ${TABLE}."ACW_TIME" ;;
  }

  dimension: agent_id {
    type: string
    description: "Agent Incontact ID Source: incontact. rpt_skill_with_disposition_count"
    hidden: no #unhide this for agent based tables, I'm just using this view for disposition things right now
    sql: ${TABLE}."AGENT_ID" ;;
  }

  dimension: contact_id {
    type: string
    description: "Call Segment Incontact ID Source: incontact. rpt_skill_with_disposition_count"
    hidden: no
    sql: ${TABLE}."CONTACT_ID" ;;
  }

  dimension: avg_inqueue_time {
    description: "Source: incontact. rpt_skill_with_disposition_count"
    type: number
    hidden: no
    sql: ${TABLE}."AVG_INQUEUE_TIME" ;;
  }

  dimension_group: contacted {
    description: "Source: incontact. rpt_skill_with_disposition_count"
    type: time
    hidden: no
    timeframes: [raw,time,hour,hour_of_day,date,day_of_week,week,week_of_year,month,quarter,year, minute30, month_name]
    sql: ${TABLE}."CONTACTED" ;;
  }

  dimension: inbound_flag {
    label: "     * Is Inbound Call (Yes / No)"
    type: yesno
    description: "Yes if Purple received the call / the call is inbound.
      Source: incontact. rpt_skill_with_disposition_count"
    sql: substring(${contact_info_to},0,3) = '888';;
  }

  dimension: contact_info_from {
    description: "Person initiating the call (Purple if Outbound call, Customer if Inbound call). Source: incontact. rpt_skill_with_disposition_count"
    type: string
    sql: ${TABLE}."CONTACT_INFO_FROM" ;;
  }

  dimension: contact_info_to {
    description: "Receiver of call (Purple if Inbound call, Customer if Outbound call). Source: incontact. rpt_skill_with_disposition_count"
    type: string
    sql: ${TABLE}."CONTACT_INFO_TO" ;;
  }

  dimension: disposition {
    description: "Source: incontact. rpt_skill_with_disposition_count"
    type: string
    sql: lower(${TABLE}."DISPOSITION") ;; ## remove the lower() if we standardize naming and capitalization in snowflake between this and zendesk data
  }

  dimension: handle_time {
    description: "Talk time + Hold time. Source: incontact. rpt_skill_with_disposition_count"
    type: number
    hidden: no
    sql: ${TABLE}."HANDLE_TIME" ;;
  }

  dimension: hold_time {
    description: "Time customer was on hold (not in queue). Source: incontact. rpt_skill_with_disposition_count"
    type: number
    hidden: no
    sql: ${TABLE}."HOLD_TIME" ;;
  }

  dimension: hold_buckets {
    description: "Source: looker.calculation"
    type: tier
    tiers: [0, 30, 45, 60, 75, 90, 105, 120, 135, 150, 165, 180, 195, 210, 225, 240   ]
    style: integer # the default value, could be excluded
    sql: ${TABLE}."HOLD_TIME" ;;
  }

  dimension: in_queue_time {
    description: "Source: looker.calculation"
    type: number
    sql: ${TABLE}."INQUEUE_TIME" ;;
  }

  dimension: in_queue_buckets {
    description: "Source: looker.calculation"
    type: tier
    tiers: [0, 30, 45, 60, 75, 90, 105, 120, 135, 150, 165, 180, 195, 210, 225, 240 ]
    style: integer # the default value, could be excluded
    sql: ${TABLE}."INQUEUE_TIME" ;;
  }

  dimension_group: insert_ts {
    type: time
    hidden: yes
    timeframes: [raw,time,date,week,month,quarter,year]
    sql: ${TABLE}."INSERT_TS" ;;
  }

  dimension_group: reported {
    description: "Source: incontact. rpt_skill_with_disposition_count"
    type: time
    timeframes: [raw,date,week,week_of_year,month,quarter,year]
    convert_tz: no
    datatype: date
    hidden: yes
    sql: ${TABLE}."REPORTED" ;;
  }

  dimension: skill {
    description: "Source: incontact. rpt_skill_with_disposition_count"
    type: string
    sql: ${TABLE}."SKILL" ;;
  }

  dimension: campaign {
      description: "Campaign is the call type and skill grouping from inContact"
      type: string
      sql: ${TABLE}."CAMPAIGN" ;;
  }

  dimension: call_type {
    description: ""
    type: string
    sql:
    case
        when ${skill} in ('8885Purple','888Purple','AAA EnCompass','Abandoned Carts','American Legion Auxiliary','Archaeology Magazine','Arthritis Today','BOGO 50','C_D_L_Trucker_Discount','CDL_Trucker _Discount','Discover Magazine Ad','Doctors_Medical_Discount','Elks','FB Campaign','FKL Free Sheets 2Pillow','FKL_10Percent off Mattress','FKL_20Dollar_Off','FKL_SleepMask','Financing','First 100 Days','Fluent','Inbound Sales','Innovation and Tech Today','Magazine Ad','Mantra Wellness magazine','Military Officer','MyMove','Online Chat','Parade 1','Parade 2','Presidents Day Promo','Progressive','Progressive Corporate Support','Purple Call Campaign','Sales Team Landing Page 1','Sales Team Landing Page 2','Sales Xfer (From Support)','Sleep Bundles','Smithsonian','Spring Sale','TV Ads','Teacher_Discount','Teacher Discount','Time Magazine','SheerID Discount')
            then 'Sales Inbound'
        when ${skill} in ('Customer Service General','Customer Service Spanish','Order Follow Up','Purple Outlet Store','Retail Support','Returns','Returns - Mattress','Returns - Other','Support Xfer (From Sales)','Training - Support Xfer','Warranty','Support Tier 1 to Tier 2 xfer')
            then 'Support Inbound'
        when ${skill} in ('Service Recovery','Sleep Country Canada','Sleep County Canada','Showrooms (Purple owned Retail','Showrooms (Purple owned Retail)')
            then 'SRT'
        when ${skill} = 'Customer Service OB'
            then 'Support OB'
        when ${skill} in ('Fraud (Avail M-F 8a-6p)','Verification (Avail M-F 8a-5p)','Verification')
            then 'Verification'
        when ${skill} = 'Sales Team OB'
            then 'Sales OB'
        when ${skill} = 'PurpleBoysPodcast'
            then 'PurpleBoysPodcast'
        when ${skill} in ('Operations Support','Ops Service Recovery','Purple Delivery','Shipping (Manna)','Shipping (XPO Logistics)')
            then 'Ops'
        else 'Other/Unknown'
    end
    ;;
  }

  dimension: call_transfer {
    label: "  * Is Transferred Call"
    type: yesno
    sql:
      case when ${skill} in ('Sales Xfer (From Support)','Support Xfer (From Sales)','Training - Support Xfer','Support Tier 1 to Tier 2 xfer') then true else false end
    ;;
  }

  measure: avg_abandon_time {
    description: "Source: incontact. rpt_skill_with_disposition_count"
    hidden: no
    type: average
    value_format: "#,##0.00"
    sql: ${TABLE}."ABANDON_TIME" ;;
  }

  measure: avg_acw_time {
    description: "Source: incontact. rpt_skill_with_disposition_count"
    hidden: yes
    type: average
    value_format: "#,##0.00"
    sql: ${TABLE}."ACW_TIME" ;;
  }

  measure: total_acw_time {
    label: "Total ACW Time"
    description: "Source: incontact. rpt_skill_with_disposition_count"
    hidden: no
    type: sum
    value_format: "#,##0"
    sql: ${TABLE}."ACW_TIME" ;;
  }

  measure: total_handle_time {
    description: "Source: incontact. rpt_skill_with_disposition_count"
    type: sum
    value_format: "#,##0"
    sql: ${TABLE}."HANDLE_TIME" ;;
  }

  measure: total_handle_calls {
    description: "Source: incontact. rpt_skill_with_disposition_count"
    type: sum
    value_format: "#,##0"
    sql: case when ${handle_time} > 0 then 1 else 0 end ;;
  }

  measure: count_handle_time {
    description: "Count Distinct of handle time. Source: incontact. rpt_skill_with_disposition_count"
    type: count_distinct
    hidden: yes
    value_format: "#,##0"
    sql: ${TABLE}."HANDLE_TIME" ;;
  }

  measure: avg_acw {
    label: "Average ACW Time"
    description: "Average ACW in second, total_acw_time/count_handle_time. Source: looker.calculation"
    type: number
    value_format: "#,##0.00"
    sql: ${total_acw_time}/case when ${total_handle_calls} > 0 then ${total_handle_calls} else null end ;;
  }

  measure: avg_handle_time {
    label: "Average Handle Time"
    description: "total_handle_time/count_handle_time. Source: looker.calculation"
    type: number
    value_format: "#,##0.00"
    sql: ${total_handle_time}/case when ${total_handle_calls} > 0 then ${total_handle_calls} else null end ;;
  }

  measure: avg_hold_time_2 {
    hidden: no
    label: "Average Hold Time"
    description: "total_hold_time/count_handle_time. Source: looker.calculation"
    type: number
    value_format: "#,##0.00"
    sql: ${total_hold_time}/case when ${total_hold_calls} > 0 then ${total_hold_calls} else null end ;;
  }
  measure: total_hold_time {
    description: "Time customer was on hold (not in queue). Source: incontact. rpt_skill_with_disposition_count"
    type: sum
    hidden: no
    sql: ${hold_time} ;;
  }

  measure: total_hold_calls {
    description: "Time customer was on hold (not in queue). Source: incontact. rpt_skill_with_disposition_count"
    type: sum
    hidden: no
    sql: case when ${hold_time} > 0 then 1 else 0 end ;;
  }

  measure: avg_talk_time {
    description: "Source: incontact. rpt_skill_with_disposition_count"
    type: average
    hidden: yes
    value_format: "#,##0"
    sql: nvl(${TABLE}."HANDLE_TIME",0) - nvl(${TABLE}."HOLD_TIME",0);;
  }

  measure: avg_hold_time {
    description: "Source: incontact. rpt_skill_with_disposition_count"
    hidden: yes
    type: average
    sql: case when ${TABLE}."HOLD_TIME" > 0 then ${TABLE}."HOLD_TIME" end
    ;;
  }

  measure: total_inqueue_time {
    type: sum
    value_format: "#,##0"
    sql:  ${TABLE}.INQUEUE_TIME ;;
  }

  measure: total_inbound_calls {
    type: sum
    value_format: "#,##0"
    sql: case when ${inbound_flag} then 1 else 0 end;;
  }

  measure: average_inqueue_time {
    description: "Total In Queue Time/ Total Inbound Calls"
    type: number
    value_format: "#,##0"
    sql:  ${total_inqueue_time}/case when ${total_inbound_calls} > 0 then ${total_inbound_calls} else null end  ;;
  }


  measure: count {
    description: "Number of phone calls. Source: looker.calculation"
    type: count

  }
}
