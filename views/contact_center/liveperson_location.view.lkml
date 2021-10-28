view: liveperson_location {
  sql_table_name: liveperson.campaign ;;

  dimension: location_id {
    label: "Location ID"
    type: number
    value_format_name: id
    hidden: yes
    sql: ${TABLE}.location_id ;;
  }

  dimension: location_name {
    label: "Location Name"
    type: string
    sql: ${TABLE}.location_name ;;
  }
}
