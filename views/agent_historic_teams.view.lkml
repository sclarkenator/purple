view: agent_historic_teams {
  sql_table_name: CUSTOMER_CARE.team_lead_name ;;

  dimension: end_date {
    label: "End Date"
    description: "The last day that an agent was part of a team."
    group_label: "* Historic Team Data"
    type:  date
    sql: ${TABLE}."END_DATE" ;;
  }

  dimension: start_date {
    label: "Begin Date"
    description: "The first day that an agent was part of a team."
    group_label: "* Historic Team Data"
    type:  date
    sql:${TABLE}."START_DATE" ;;
  }

  dimension: team_Name {
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
    sql: concat(${incontact_id}, replace(${start_date}, '-', '')) ;;
  }

  dimension: incontact_id {
    label: "InContact ID"
    description: "Agent's InContact ID"
    group_label: "* Historic Team Data"
    type:  number
    hidden: yes
    sql:  ${TABLE}."INCONTACT_ID" ;;
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
