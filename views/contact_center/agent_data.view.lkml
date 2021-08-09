view: agent_data {
  derived_table: {
    sql:
      select distinct a.*,
          c.team_name as current_team_name,
          c.team_email as current_team_email,
          case when a.inactive is null then true else false end as active_flag

      from analytics.customer_care.agent_lkp a

          left join (
              select *,
                  rank()over(partition by incontact_id order by end_date desc) as rnk
              from analytics.customer_care.team_lead_name
              where team_name is not null
              ) c
              on a.incontact_id = c.incontact_id
              and c.rnk = 1 ;;
  }
                                                                                                              measure: count {  ## This is just for testing and can be removed once our data s pulling correctly.
                                                                                                                type: count
                                                                                                              }

  ##########################################################################################
  ##########################################################################################
  ## GENERAL DIMENSIONS

  dimension: agent_name {
    label: "Agent Name"
    description: "Agents First and Last name.  Source: incontact.agent_lkp"
    type: string
    sql: ${TABLE}.name ;;
  }

  dimension: email {
    label: "Agent Email"
    description: "The email address for this agent. Source: incontact.agent_lkp"
    type:  string
    sql: ${TABLE}.email ;;
  }

  dimension: employee_type {
    label: "Employee Type"
    description: "Source: incontact.agent_lkp"
    type:  string
    sql: ${TABLE}.employee_type ;;
  }

  dimension: team_name {
    label: "Team Lead"
    description: "The current Team Lead's name for this agent. Source: incontact.team_lead_name"
    type: string
    sql: ${TABLE}.current_team_name ;;
  }

  dimension: team_name_email {
    label: "Team Lead Email"
    description: "The current Team Lead's email for this agent. Source: incontact.team_lead_name"
    type: string
    sql: ${TABLE}.current_team_email ;;
  }

  dimension: team_type {
    label: "Team Type"
    description: "Current Team Type.  Source: incontact.agent_lkp"
    type: string
    sql: ${TABLE}.team_type ;;
  }

  ##########################################################################################
  ##########################################################################################
  ## FLAG DIMENSIONS

  dimension: is_active {
    label: "Is Active"
    group_label: "* Flags"
    description: "Whether or not this agent is active in the system. Source: incontact.agent_lkp.inactive is not null."
    type: yesno
    sql: ${TABLE}.active_flag ;;
  }

  dimension: is_mentor {
    label: "Is Mentor"
    group_label: "* Flags"
    description: "Mentors flag. Source: incontact.agent_lkp.mentor is not null."
    type: yesno
    sql: ${TABLE}.mentor is not null ;;
  }

  dimension: is_purple_with_purpose {
    label: "Is PWP Cert"
    group_label: "* Flags"
    description: "Purple with Purpose cetrification flag. Source: incontact.agent_lkp.purple_with_purpose is not null."
    type: yesno
    sql: ${TABLE}.purple_with_purpose is not null ;;
  }

  dimension: is_retail {
    label: "Is Retail Agent"
    group_label: "* Flags"
    description: "Is this a retail agent. Source: incontact.agent_lkp"
    type:  yesno
    sql: ${TABLE}.retail ;;
  }

  dimension: is_service_recovery_team {
    label: "Is SRT Cert"
    group_label: "* Flags"
    description: "Service Recovery Team flag. Source: incontact.agent_lkp.service_recovery_team is not null."
    type: yesno
    sql: ${TABLE}.service_recovery_team is not null ;;
  }

  dimension: is_supervisor {
    label: "Is Supervisor"
    group_label: "* Flags"
    description: "Whether or not this agent is a supervisor. Source: incontact.agent_lkp"
    type: yesno
    sql: ${TABLE}.supervisor ;;
  }

  ##########################################################################################
  ##########################################################################################
  ## DATE/TIME STAMP DIMENSIONS

  dimension_group: inactive {
    label: "* Inactive"
    description: "Date agent became inactive. Source: incontact.agent_lkp"
    type: time
    timeframes: [raw,
      date,
      week,
      month,
      quarter,
      year]
    datatype: timestamp
    sql: ${TABLE}.inactive ;;
  }

  dimension_group: created {
    label: "* Created"
    hidden: yes
    type: time
    timeframes: [raw,
      date,
      week,
      month,
      quarter,
      year]
    convert_tz: no
    datatype: timestamp
    sql: ${TABLE}.created ;;
  }

  dimension_group: purple_with_purpose {
    label: "* Purple with Purpose"
    type: time
    timeframes: [raw,
      date,
      week,
      month,
      quarter,
      year]
    convert_tz: no
    datatype: timestamp
    sql: ${TABLE}.purple_with_purpose ;;
  }

  dimension_group: mentor {
    label: "* Mentor"
    type: time
    timeframes: [raw,
      date,
      week,
      month,
      quarter,
      year]
    convert_tz: no
    datatype: timestamp
    sql: ${TABLE}.mentor ;;
  }

  dimension_group: service_recovery_team {
    label: "* Service Recovery Team"
    type: time
    timeframes: [raw,
      date,
      week,
      month,
      quarter,
      year]
    convert_tz: no
    datatype: timestamp
    sql: ${TABLE}.service_recovery_team ;;
  }

  dimension: update_ts {
    label: "* Update TS"
    hidden: yes
    type:  date_time
    sql: ${TABLE}.update_ts ;;
  }

  ##########################################################################################
  ##########################################################################################
  ## ID DIMENSIONS

  dimension: incontact_id {
    label: "InContact ID"
    group_label: "* IDs"
    description: "InContact ID may equate to Agent ID in some reports. Source: incontact.agent_lkp"
    primary_key: yes
    type:  number
    sql: ${TABLE}.incontact_id ;;
  }

  dimension: zendesk_id {
    label: "Zendesk ID"
    group_label: "* IDs"
    description: "The ZenDesk ID for this agent. Source: incontact.agent_lkp"
    type:  number
    sql: ${TABLE}.zendesk_id ;;
  }

  dimension: zendesk_sell_id {
    label: "Zendesk Sell ID"
    group_label: "* IDs"
    description: "The ZenDesk Sell ID for this agent. Source: incontact.agent_lkp"
    type:  number
    sql: ${TABLE}.zendesk_sell_user_id ;;
  }

  dimension: shopify_id {
    label: "Shopify ID"
    group_label: "* IDs"
    description: "The Shopify ID for this agent. Source: incontact.agent_lkp"
    type:  number
    sql: ${TABLE}.shopify_id ;;
  }

  dimension: shopify_id_pos {
    label: "Shopify POS ID"
    group_label: "* IDs"
    description: "The Shopify POS ID for Retail agent. Source: incontact.agent_lkp"
    type:  number
    sql: ${TABLE}.shopify_id_pos ;;
  }

}