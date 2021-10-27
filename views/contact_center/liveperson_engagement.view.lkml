view: liveperson_engagement {
  sql_table_name: liveperson.campaign ;;

  dimension: engagement_id {
    label: "Engagement ID"
    type: number
    value_format_name: id
    sql: ${TABLE}.engagement_id ;;
  }

  dimension: engagement_name {
    label: "Engagement Name"
    type: string
    sql: ${TABLE}.engagement_name ;;
  }
}
