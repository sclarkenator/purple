view: team_lead {
  sql_table_name: CUSTOMER_CARE.team_lead ;;

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
    type:  number
    sql:${TABLE}."START_DATE" ;;
  }

  dimension: end_date {
    type:  number
    sql: ${TABLE}."END_DATE" ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }



  }
