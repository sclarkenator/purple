view: agent_data {
  ## Tracks agent data from agent_lkp table along with current team information
  ## Does not track historic data

  sql_table_name: analytics.customer_care.agent_data ;;

  set: agents_minimal_grouping {
    fields: [
      agent_name,
      team_group,
      team_type,
      team_name,
      incontact_id,
      is_active,
      is_retail,
      is_supervisor
    ]
  }

  set: agents_liveperson_linked {
    fields: [
      is_active,
      is_supervisor
    ]
  }

  ##########################################################################################
  ##########################################################################################
  ## GENERAL DIMENSIONS

  dimension: agent_name {
    label: "Agent Name"
    description: "Agents First and Last name."
    type: string
    sql: ${TABLE}.name ;;
  }

  dimension: email {
    label: "Agent Email"
    description: "The email address for this agent."
    type:  string
    sql: ${TABLE}.email ;;
  }

  dimension: employee_type {
    label: "Employee Type"
    description: "Is agent a Temp or Purple employee."
    type:  string
    sql: ${TABLE}.employee_type ;;
  }

  dimension: team_group {
    label: "Team Group"
    description: "The current Team Group for each agent."
    type: string
    sql: ${TABLE}.team_group ;;
    # sql: case when employee_type is null and ${TABLE}.current_team_name is null then 'Other'
    #   when ${TABLE}.team_type in ('Admin', 'WFM', 'QA') then 'Admin'
    #   when ${TABLE}.team_type in ('Training', 'Sales') then ${TABLE}.team_type
    #   else 'Customer Care' end ;;
  }

  dimension: team_name {
    label: "Team Lead"
    description: "The current Team Lead's name for this agent."
    type: string
    sql: ${TABLE}.current_team_name ;;
  }

  dimension: team_name_email {
    label: "Team Lead Email"
    description: "The current Team Lead's email for this agent."
    type: string
    sql: ${TABLE}.current_team_email ;;
  }

  dimension: team_type {
    label: "Team Type"
    description: "Current Team Type.  Calculated using data from incontact.agent_lkp"
    type: string
    sql: ${TABLE}.team_type ;;
    # sql: nullif(case when ${TABLE}.retail = true then 'Retail'
    #   when nullif(${TABLE}.team_type, '') is null and ${is_active} = true then 'Admin'
    #   else ${TABLE}.team_type end, '') ;;
  }

  dimension: tenure {
    label: "Tenure by Month"
    group_label: "* Tenure Metrics"
    description: "Agent tenure in months."
    type: number
    value_format_name: decimal_0
    sql: case when not (${TABLE}.employee_type is null and ${TABLE}.current_team_name is null) then datediff(month, ${start_date}, current_date) end ;;
  }

  dimension: tenure_week {
    label: "Tenure by Week"
    group_label: "* Tenure Metrics"
    description: "Agent tenure in weeks."
    type: number
    value_format_name: decimal_0
    sql: case when not (${TABLE}.employee_type is null and ${TABLE}.current_team_name is null) then datediff(week, ${start_date}, current_date) end ;;
  }

  dimension: tenure_buckets {
    label: "Tenure Bucket by Month"
    group_label: "* Tenure Metrics"
    type: tier
    style: integer
    tiers: [0, 4, 7, 10]
    sql: ${tenure} ;;
  }

  ##########################################################################################
  ##########################################################################################
  ## FLAG DIMENSIONS

  dimension: is_active {
    label: "Is Active"
    group_label: "* Agent Flags"
    description: "Whether or not this agent is active in the system."
    type: yesno
    sql: ${TABLE}.active_flag ;;
  }

  dimension: is_enabled {
    label: "Is Enabled"
    group_label: "* Agent Flags"
    description: "Whether agent acount is enabled in LivePerson."
    type: yesno
    sql: ${TABLE}.enabled ;;
  }

  dimension: is_mentor {
    label: "Is Mentor"
    group_label: "* Agent Flags"
    description: "Mentors flag."
    type: yesno
    sql: ${TABLE}.mentor is not null ;;
  }

  dimension: is_purple_with_purpose {
    label: "Is PWP Cert"
    group_label: "* Agent Flags"
    description: "Purple with Purpose cetrification flag."
    type: yesno
    sql: ${TABLE}.purple_with_purpose is not null ;;
  }

  dimension: is_retail {
    label: "Is Retail Agent"
    group_label: "* Agent Flags"
    description: "Is this a retail agent."
    type:  yesno
    sql: ${TABLE}.retail ;;
  }

  dimension: is_service_recovery_team {
    label: "Is SRT Cert"
    group_label: "* Agent Flags"
    description: "Service Recovery Team flag."
    type: yesno
    sql: ${TABLE}.service_recovery_team is not null ;;
  }

  dimension: is_supervisor {
    label: "Is Supervisor"
    group_label: "* Agent Flags"
    description: "Whether or not this agent is a supervisor."
    type: yesno
    sql: ${TABLE}.supervisor ;;
  }

  ##########################################################################################
  ##########################################################################################
  ## DATE/TIME STAMP DIMENSIONS

  dimension_group: created {
    label: "- Created"
    # hidden: yes
    type: time
    timeframes: [raw,
      date,
      week,
      month,
      # quarter,
      year]
    convert_tz: no
    datatype: timestamp
    sql: ${TABLE}.created ;;
  }

  dimension_group: end {
    label: "- End"
    description: "Termination Date if not null, else Inactive Date."
    type: time
    timeframes: [raw,
      date,
      week,
      month,
      # quarter,
      year]
    sql: case when ${terminated_date} is not null then ${terminated_date}
      else ${inactive_date} end;;
  }

  dimension_group: hired {
    label: "- Hired"
    description: "Date agent was initially hired."
    type: time
    timeframes: [raw,
      date,
      week,
      month,
      # quarter,
      year]
    convert_tz: no
    datatype: timestamp
    sql: ${TABLE}.hired ;;
  }

  dimension_group: inactive {
    label: "- Inactive"
    description: "Date agent became inactive."
    type: time
    timeframes: [raw,
      date,
      week,
      month,
      # quarter,
      year]
    datatype: timestamp
    sql: ${TABLE}.inactive ;;
  }

  dimension_group: mentor {
    label: "- Mentor"
    type: time
    timeframes: [raw,
      date,
      week,
      month,
      # quarter,
      year]
    convert_tz: no
    datatype: timestamp
    sql: ${TABLE}.mentor ;;
  }

  dimension_group: purple_with_purpose {
    label: "- Purple with Purpose"
    type: time
    timeframes: [raw,
      date,
      week,
      month,
      # quarter,
      year]
    convert_tz: no
    datatype: timestamp
    sql: ${TABLE}.purple_with_purpose ;;
  }

  dimension_group: service_recovery_team {
    label: "- Service Recovery Team"
    type: time
    timeframes: [raw,
      date,
      week,
      month,
      # quarter,
      year]
    convert_tz: no
    datatype: timestamp
    sql: ${TABLE}.service_recovery_team ;;
  }

  dimension_group: start {
    label: "- Start"
    description: "Hire Date if not null, else Created Date."
    type: time
    timeframes: [raw,
      date,
      week,
      month,
      # quarter,
      year]
    sql: case when ${hired_date} is not null then ${hired_date}
      else ${created_date} end;;
  }

  dimension_group: terminated {
    label: "- Terminated"
    description: "Date of voluntary or involuntary termination."
    type: time
    timeframes: [raw,
      date,
      week,
      month,
      # quarter,
      year]
    convert_tz: no
    datatype: timestamp
    sql: ${TABLE}.terminated ;;
  }

  dimension: update_ts {
    label: "- Update TS"
    hidden: yes
    type:  date_time
    sql: ${TABLE}.update_ts ;;
  }

  ##########################################################################################
  ##########################################################################################
  ## ID DIMENSIONS

  dimension: incontact_id {  # PRIMARY KEY
    label: "InContact ID"
    group_label: "* IDs"
    description: "Agent's InContact ID. May equate to Agent ID in some reports."
    primary_key: yes
    type:  number
    value_format_name: id
    sql: ${TABLE}.incontact_id ;;
  }

  dimension: liveperson_id {
    label: "LivePerson ID"
    group_label: "* IDs"
    description: "LivePerson Agent ID."
    type:  number
    value_format_name: id
    sql: ${TABLE}.liveperson_id ;;
  }

  dimension: zendesk_id {
    label: "Zendesk ID"
    group_label: "* IDs"
    description: "Agent's ZenDesk ID."
    type:  number
    value_format_name: id
    sql: ${TABLE}.zendesk_id ;;
  }

  dimension: zendesk_sell_id {
    label: "Zendesk Sell ID"
    group_label: "* IDs"
    description: "The ZenDesk Sell ID for this agent."
    type:  number
    value_format_name: id
    sql: ${TABLE}.zendesk_sell_user_id ;;
  }

  dimension: shopify_id {
    label: "Shopify ID"
    group_label: "* IDs"
    description: "Agent's Shopify ID ."
    type:  number
    value_format_name: id
    sql: ${TABLE}.shopify_id ;;
  }

  dimension: shopify_id_pos {
    label: "Shopify POS ID"
    group_label: "* IDs"
    description: "The Shopify POS ID for Retail agent."
    type:  number
    value_format_name: id
    hidden: yes
    sql: ${TABLE}.shopify_id_pos ;;
  }
  dimension: workday_id {
    label: "Workday ID"
    group_label: "* IDs"
    description: "Agent's Workday ID."
    type:  number
    value_format_name: id
    sql: ${TABLE}.workday_id ;;
  }

  ##########################################################################################
  ##########################################################################################
  ## MEASURES

  measure: count {
    label: "Agent Count"
    description: "Count of Agents."
    type: count
    link: {
      label: "View Tenure Detail"
      url: "https://purple.looker.com/looks/5759"
    }
  }

  measure: tenure_average {
    label: "Tenure Average"
    description: "Average tenure in months."
    type: average
    value_format_name: decimal_1
    sql: ${tenure} ;;
    link: {
      label: "View Tenure Detail"
      url: "https://purple.looker.com/looks/5759"
    }
    link: {
      label: "Go To Headcount Dashboard"
      url: "https://purple.looker.com/dashboards-next/4502?Headcount%20Date=today&Team%20Type=&Employee%20Type=&Team%20Lead%20Name=-Other&Team%20Group="
    }
  }
}
