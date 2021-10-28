view: liveperson_goal {
  sql_table_name: liveperson.campaign ;;

  dimension: goal_id {
    label: "Goal ID"
    group_label: "* Engagment Data"
    type: number
    value_format_name: id
    hidden: yes
    sql: ${TABLE}.goal_id ;;
  }

  dimension: goal_name {
    label: "Goal Name"
    type: string
    sql: ${TABLE}.goal_name ;;
  }
}
