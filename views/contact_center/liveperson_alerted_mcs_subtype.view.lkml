view: liveperson_alerted_mcs_subtype {
  sql_table_name: "LIVEPERSON"."LIVEPERSON_ALERTED_MCS_SUBTYPE" ;;
  # sql_table_name: "LIVEPERSON"."ALERTED_MCS_SUBTYPE" ;;

  dimension: alerted_mcs_name {
    label: "Alerted MCS Name"
    type: string
    sql: ${TABLE}."NAME" ;;
  }

  dimension: subtype_id {
    type: number
    hidden: yes
    sql: ${TABLE}."SUBTYPE_ID" ;;
  }

  measure: alerted_mcs_count {
    label: "Alerted MCS Count"
    type: count
    hidden: yes
    drill_fields: [alerted_mcs_name]
  }
}
