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
    timeframes: [
      raw,
      time,
      hour,
      hour_of_day,
      date,
      day_of_week,
      week,
      week_of_year,
      month,
      quarter,
      year
    ]
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
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}."INSERT_TS" ;;
  }

  dimension_group: reported {
    description: "Source: incontact. rpt_skill_with_disposition_count"
    type: time
    timeframes: [
      raw,
      date,
      week,
      week_of_year,
      month,
      quarter,
      year
    ]
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


  measure: avg_abandon_time {
    description: "Source: incontact. rpt_skill_with_disposition_count"
    hidden: no
    type: average
    sql: ${TABLE}."ABANDON_TIME" ;;
  }

  measure: avg_acw_time {
    description: "Source: incontact. rpt_skill_with_disposition_count"
    hidden: yes
    type: number
    sql: ${TABLE}."ACW_TIME" ;;
  }

  measure: total_handle_time {
    description: "Source: incontact. rpt_skill_with_disposition_count"
    type: sum
    value_format: "#,##0"
    sql: ${TABLE}."HANDLE_TIME" ;;
  }

  measure: avg_talk_time {
    description: "Source: incontact. rpt_skill_with_disposition_count"
    type: average
    value_format: "#,##0"
    sql: nvl(${TABLE}."HANDLE_TIME",0) - nvl(${TABLE}."HOLD_TIME",0);;
  }

  measure: avg_hold_time {
    description: "Source: incontact. rpt_skill_with_disposition_count"
    hidden: no
    type: average
    sql: case when ${TABLE}."HOLD_TIME" > 0 then ${TABLE}."HOLD_TIME" end
    ;;
  }

  measure: count {
    description: "Number of phone calls. Source: looker.calculation"
    type: count

  }
}
