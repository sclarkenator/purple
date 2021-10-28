view: liveperson_lob {
  sql_table_name: liveperson.campaign ;;

  dimension: lob_id {
    label: "LOB ID"
    type: number
    value_format_name: id
    hidden: yes
    sql: ${TABLE}.lob_id ;;
  }

  dimension: lob_name {
    label: "LOB Name"
    type: string
    sql: ${TABLE}.lob_name ;;
  }
}
