view: cordial_id {
  sql_table_name: "MARKETING"."CORDIAL_ID"
    ;;

  dimension: c_id {
    primary_key: yes
    type: string
    sql: ${TABLE}."C_ID" ;;
  }

  dimension: email_join {
    type: string
    hidden: yes
    sql: lower(${TABLE}."EMAIL") ;;
  }

  dimension: subscribe_status {
    label: "Cordial Subscribe Status"
    description: "Corial subscrition status Source: cordial.cordial_id"
    hidden: yes
    type: string
    sql: ${TABLE}."SUBSCRIBE_STATUS" ;;
  }

  measure: count {
    hidden: yes
    type: count
    drill_fields: []
  }
}
