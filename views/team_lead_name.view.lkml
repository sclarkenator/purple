view: team_lead_name {
  sql_table_name: CUSTOMER_CARE.team_lead_name ;;

  dimension: incontact_id {
    type:  number
    primary_key: yes
    hidden: yes
    sql:  ${TABLE}."INCONTACT_ID" ;;
  }
  dimension: team_lead_id{
    type: number
    hidden: yes
    sql: ${TABLE}."TEAM_LEAD_ID" ;;
  }


  dimension: start_date {
    type:  date
    hidden: yes
    sql:${TABLE}."START_DATE" ;;
  }

  dimension: end_date {
    type:  date
    hidden: yes
    sql: ${TABLE}."END_DATE" ;;
  }

  dimension: team_Name {
    type:  string
    description: "From Team Lead"
    sql: ${TABLE}."TEAM_NAME" ;;
  }

  dimension: team_email {
    type:  string
    description: "From Team Lead"
    sql: ${TABLE}.team_email ;;
  }

  dimension: agent_Name {
    type:  string
    hidden: yes
    sql: ${TABLE}.agent_name ;;
  }

  dimension: agent_email {
    type:  string
    hidden: yes
    sql: ${TABLE}.agent_email ;;
  }

  measure: count {
    type: count
    hidden: yes
    drill_fields: []
  }
}
