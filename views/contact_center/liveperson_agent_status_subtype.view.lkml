view: liveperson_agent_status_subtype {
  sql_table_name: "LIVEPERSON"."LIVEPERSON_AGENT_STATUS_SUBTYPE" ;;
  # sql_table_name: "LIVEPERSON"."AGENT_STATUS_SUBTYPE" ;;

  dimension: status_subtype_name {
    label: "Subtype Subtype"
    description: "Subtype of status change when Type = 'Status Changed'."
    type: string
    sql: ${TABLE}."NAME" ;;
  }

  dimension: subtype_id {
    type: number
    hidden: yes
    sql: ${TABLE}."SUBTYPE_ID" ;;
  }

  measure: status_subtype_count {
    label: "Status Subtype Count"
    type: count
    hidden: yes
    drill_fields: [status_subtype_name]
  }
}
