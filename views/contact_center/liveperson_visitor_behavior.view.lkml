view: liveperson_visitor_behavior {
  sql_table_name: liveperson.campaign ;;

  dimension: visitor_behavior_id {
    label: "Visitor Behavior ID"
    type: number
    value_format_name: id
    hidden: yes
    sql: ${TABLE}.visitor_behavior_id ;;
  }

  dimension: visitor_behavior_name {
    label: "Visitor Behavior Name"
    type: string
    sql: ${TABLE}.visitor_behavior_name ;;
  }
}
