view: team_lead_name {
  sql_table_name: CUSTOMER_CARE.team_lead_name ;;

  dimension: incontact_id {
    type:  number
    primary_key: yes
    sql:  ${TABLE}."INCONTACT_ID" ;;
  }
  dimension: team_lead_id{
    type: number
    sql: ${TABLE}."TEAM_LEAD_ID" ;;
  }


  dimension: start_date {
    type:  date
    sql:${TABLE}."START_DATE" ;;
  }

  dimension: end_date {
    type:  date
    sql: ${TABLE}."END_DATE" ;;
  }

  dimension: team_Name {
    type:  string
    sql: ${TABLE}."TEAM_NAME" ;;
  }

  dimension: agent_Name {
    type:  string
    sql: ${TABLE}.agent_name ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }



  }
