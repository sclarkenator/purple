view: rpt_skill_with_disposition_count {
  ##sql_table_name: CUSTOMER_CARE.RPT_SKILL_WITH_DISPOSITION_COUNT ;;
derived_table: {
  sql: select * from CUSTOMER_CARE.RPT_SKILL_WITH_DISPOSITION_COUNT where captured::date < '2050-01-01' ;;
}

dimension: primary_key {
  type: string
  hidden: yes
  primary_key: yes
  sql: ${TABLE}.captured || ${TABLE}.contact_info_from ;;
}

  dimension: abandon_time {
    description: "How long a person was in queue before abandoning the call (without speaking to an agent)"
    type: number
    hidden: yes
    sql: ${TABLE}."ABANDON_TIME" ;;
  }

  dimension: acw_time {
    description: "After Call Work Time (making notes, etc. before they're available for another call)"
    type: number
    hidden: yes
    sql: ${TABLE}."ACW_TIME" ;;
  }

  dimension: agent {
    type: string
    hidden: yes #unhide this for agent based tables, I'm just using this view for disposition things right now
    sql: ${TABLE}."AGENT" ;;
  }

  dimension: avg_inqueue_time {
    type: number
    hidden: yes
    sql: ${TABLE}."AVG_INQUEUE_TIME" ;;
  }

  dimension_group: captured {
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
    sql: ${TABLE}."CAPTURED" ;;
  }

  dimension: inbound_flag {
    label: "     * Is Inbound Call (Yes / No)"
    type: yesno
    description: "Yes if Purple received the call / the call is inbound.
      Source: incontact. rpt_skill_with_disposition_count"
    sql: substring(${contact_info_to},0,3) = '888';;
  }

  dimension: contact_info_from {
    description: "Person initiating the call (Purple if Outbound call, Customer if Inbound call)"
    type: string
    sql: ${TABLE}."CONTACT_INFO_FROM" ;;
  }

  dimension: contact_info_to {
    description: "Receiver of call (Purple if Inbound call, Customer if Outbound call)"
    type: string
    sql: ${TABLE}."CONTACT_INFO_TO" ;;
  }

  dimension: disposition {
    type: string
    sql: lower(${TABLE}."DISPOSITION") ;; ## remove the lower() if we standardize naming and capitalization in snowflake between this and zendesk data
  }

  dimension: handle_time {
    description: "Talk time + Hold time"
    type: number
    hidden: no
    sql: ${TABLE}."HANDLE_TIME" ;;
  }

  dimension: hold_time {
    description: "Time customer was on hold (not in queue)"
    type: number
    hidden: yes
    sql: ${TABLE}."HOLD_TIME" ;;
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
    sql: ${TABLE}."REPORTED" ;;
  }

  dimension: skill {
    type: string
    sql: ${TABLE}."SKILL" ;;
  }


  measure: avg_abandon_time {
    hidden: yes
    type: average
    sql: ${TABLE}."ABANDON_TIME" ;;
  }

  measure: avg_acw_time {
    hidden: yes
    type: number
    sql: ${TABLE}."ACW_TIME" ;;
  }

  measure: total_handle_time {
    type: sum
    sql: ${TABLE}."HANDLE_TIME" ;;
  }

  measure: avg_hold_time {
    hidden: yes
    type: number
    sql: ${TABLE}."HOLD_TIME" ;;
  }



  measure: count {
    description: "Number of phone calls"
    type: count

  }
}
