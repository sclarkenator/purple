view: liveperson_engagement {
  sql_table_name: liveperson.campaign ;;

  dimension: engagement_id {
    label: "Engagement ID"
    group_label: "* Engagment Data"
    type: number
    value_format_name: id
    hidden: yes
    sql: ${TABLE}.engagement_id ;;
  }

  dimension: engagement_name {
    label: "Engagement Name"
    type: string
    sql: ${TABLE}.engagement_name ;;
  }
}
