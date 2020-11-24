view: agent_name {
  sql_table_name: customer_care.agent_lkp ;;


dimension: incontact_id {
  description: "The InContact ID for this agent. Source: incontact.agent_lkp"
  type:  number
  hidden: yes
  sql: ${TABLE}.incontact_id ;;
  primary_key: yes
}

dimension: zendesk_id {
  description: "The ZenDesk ID for this agent. Source: incontact.agent_lkp"
  type:  number
  hidden: yes
  sql: ${TABLE}.zendesk_id ;;
}

dimension: shopify_id {
  description: "The Shopify ID for this agent. Source: incontact.agent_lkp"
  type:  number
  hidden: yes
  sql: coalesce(${TABLE}.shopify_id_pos,${TABLE}.shopify_id) ;;
}

dimension: shopify_id_us {
  description: "The Shopify ID for this agent. Source: incontact.agent_lkp"
  type:  number
  hidden: yes
  sql: ${TABLE}.shopify_id ;;
}

dimension: shopify_id_pos {
  description: "The Shopify POS ID for this agent. Source: shopify_pos.agent_lkp"
  type:  number
  hidden: yes
  sql: ${TABLE}.shopify_id_pos ;;
}

  dimension: retail {
    hidden: no
    label: " * Is Retail Agent"
    type:  yesno
    sql: ${TABLE}.retail ;;
  }

dimension: name {
  label: "CC Agent Name"
  group_label: " Advanced"
  description: "The name of this agent. Source:incontact.agent_lkp"
  type:  string
  sql: ${TABLE}.name ;;
}

  dimension: associate_name {
    label: "Associate"
    hidden: no
    group_label: " Advanced"
    description: "The name of this associate. Source:incontact.agent_lkp"
    type:  string
    link: {
      url: "https://purple.looker.com/dashboards-next/3902?Associate={{ value }}"}
      sql: ${TABLE}.name ;;
  }

  link: {
    label: "Show SKU dashboard"
    url: "https://purple.looker.com/dashboards-next/3895?SKU+ID={{ value }}"
    icon_url: "https://www.google.com/s2/favicons?domain=looker.com" }

  dimension: merged_name{
    group_label: " Advanced"
    label: "CC/ZD Agent Name"
    description: "The name of this agent. Source:incontact.agent_lkp"
    type:  string
    sql: nvl(${zendesk_sell.name},${TABLE}.name)  ;;
  }

  dimension: primary_location{
    label: "Primary Location"
    group_label: " Advanced"
    view_label: "Owned Retail"
    description: "The primary location where a retail agent works. Source:incontact.agent_lkp"
    type:  string
    sql: ${TABLE}.location ;;
  }

  dimension: email_join {
    description: "The email address for this agent"
    type:  string
    hidden: yes
    sql: lower(${TABLE}.email) ;;
  }

  dimension: team_type {
    description: "Source: incontact.agent_lkp"
    hidden: yes
    type:  string
    sql: ${TABLE}.team_type ;;
  }

  dimension: employee_type {
    description: "Source: incontact.agent_lkp"
    hidden: yes
    type:  string
    sql: ${TABLE}.employee_type ;;
  }

  dimension_group: purple_with_purpose {
    type: time
    hidden: yes
    timeframes: [raw, date, day_of_week, day_of_month, week, week_of_year, month, month_name, quarter, quarter_of_year, year]
    convert_tz: no
    datatype: timestamp
    sql: ${TABLE}.purple_with_purpose ;;
  }

  dimension_group: mentor {
    hidden: yes
    type: time
    timeframes: [raw, date, day_of_week, day_of_month, week, week_of_year, month, month_name, quarter, quarter_of_year, year]
    convert_tz: no
    datatype: timestamp
    sql: ${TABLE}.mentor ;;
  }

  dimension_group: service_recovery_team {
    hidden: yes
    type: time
    timeframes: [raw, date, day_of_week, day_of_month, week, week_of_year, month, month_name, quarter, quarter_of_year, year]
    convert_tz: no
    datatype: timestamp
    sql: ${TABLE}.service_recovery_team ;;
  }

}
