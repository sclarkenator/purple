view: liveperson_agent_status_type {
  sql_table_name: "LIVEPERSON"."LIVEPERSON_AGENT_STATUS_TYPE" ;;
  # sql_table_name: "LIVEPERSON"."AGENT_STATUS_TYPE" ;;

  dimension: agent_status_type_name {
    label: "Agent Status Type Name"
    type: string
    sql: ${TABLE}."NAME" ;;
  }

  dimension: type_id {
    type: number
    hidden: yes
    sql: ${TABLE}."TYPE_ID" ;;
  }

  measure: agent_status_type_count {
    label: "Agent Status Type Count"
    type: count
    hidden: yes
    drill_fields: [agent_status_type_name]
  }
}
