view: agent_team_history {
  ## Historic tracking of agent's team leads.  May be replaced by CDC table for Agent_Lkp

  sql_table_name: CUSTOMER_CARE.team_lead_name ;;

  dimension: end_date {
    label: "End Date"
    description: "The last day that an agent was part of a team."
    group_label: "* Historic Team Data"
    type:  date
    sql: ${TABLE}."END_DATE" ;;
  }

  dimension: incontact_id {
    label: "InContact ID"
    description: "Agent's InContact ID"
    group_label: "* Historic Team Data"
    type:  number
    value_format_name: id
    # hidden: yes
    sql:  ${TABLE}."INCONTACT_ID" ;;
  }

  dimension: current_team_flag {
    label: "Current Team Flag"
    description: "Flags whether this is the agents current/most recent team."
    group_label: "* Historic Team Data"
    type: yesno
    sql: ${end_date} >= cast(getdate() as date) and ${start_date} <= cast(getdate() as date) ;;
  }

  dimension: start_date {
    label: "Begin Date"
    description: "The first day that an agent was part of a team."
    group_label: "* Historic Team Data"
    type:  date
    sql:${TABLE}."START_DATE" ;;
  }

  dimension: team_name {
    label: "Team Lead Name"
    description: "Name of team lead"
    group_label: "* Historic Team Data"
    type:  string
    sql: ${TABLE}."TEAM_NAME" ;;
  }

  dimension: team_email {
    label: "Team Email"
    description: "Email for team lead"
    group_label: "* Historic Team Data"
    type:  string
    sql: ${TABLE}.team_email ;;
  }

  ## VISIBLE FIELDS ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  ##########################################################################################
  ## HIDDEN FIELDS vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv

  dimension: primary_key {
    label: "Primary Key"
    description: "[InContact ID] & [Start Date]"
    group_label: "* Historic Team Data"
    primary_key: yes
    hidden: yes
    type: string
    sql: concat(${TABLE}.incontact_id, replace(${start_date}, '-', '')) ;;
  }

  dimension: team_lead_id{
    label: "Team Lead ID"
    description: "Team Lead's InContact ID"
    group_label: "* Historic Team Data"
    hidden: yes
    type: number
    sql: ${TABLE}."TEAM_LEAD_ID" ;;
  }

  measure: count {
    label: "Team Count"
    description: "Count of teams which agent was a member."
    group_label: "* Historic Team Data"
    type: count
    hidden: yes
    drill_fields: []
  }
}
