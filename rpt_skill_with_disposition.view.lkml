view: rpt_skill_with_disposition {
  sql_table_name: CUSTOMER_CARE.rpt_skill_with_disposition_count ;;

  dimension: reported {
    type: date
    sql: ${TABLE}."reported" ;;
  }

  dimension: agent_id {
    type:  number
    sql: ${TABLE}."agent_id" ;;
    primary_key: yes
  }

  dimension: disposition {
    type: string
    sql: ${TABLE}."disposition" ;;
  }

  dimension: skill {
    type: string
    sql: ${TABLE}."skill" ;;
  }

  dimension: contact_info_from {
    type:  string
    sql: ${TABLE}."contact_info_from" ;;

  }

  dimension: contact_info_to {
    type: string
    sql: ${TABLE}."contact_info_to" ;;
  }

  dimension: contact_id {
    type: number
    sql: ${TABLE}."contact_id" ;;
  }
  dimension: captured {
    type:  date_time
    sql: ${TABLE}."captured" ;;
  }

  dimension: handle_time {
    type: duration_minute
    sql: ${TABLE}."handle_time" ;;
  }

  dimension: avg_inqueue_time {
    type: duration_minute
    sql: ${TABLE}."avg_inqueue_time" ;;
  }
  dimension: abandon_time{
    type:  duration_minute
    sql: ${TABLE}."abandon_time" ;;
  }

  dimension: hold_time{
    type: duration_minute
    sql: ${TABLE}."hold_time" ;;
  }

  dimension: acw_time {
    type: duration_minute
    sql: ${TABLE}."acw_time" ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }

}
