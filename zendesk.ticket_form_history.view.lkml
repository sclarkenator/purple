view: ticket_form_history {
  sql_table_name: select * from analytics_stage.zendesk.ticket_form_history  ;;

  measure: count {
    type: count
    hidden: yes
    drill_fields: [detail*]
  }

  dimension: pk {
    hidden: yes
    primary_key: yes
    type: string
    sql: ${TABLE}.id || ${TABLE}.update_at ;;
  }

  dimension_group: updated_at {
    type: time
    hidden: yes
    sql: ${TABLE}."UPDATED_AT" ;;
  }

  dimension: id {
    type: number
    hidden: yes
    sql: ${TABLE}."ID" ;;
  }

  dimension_group: created_at {
    type: time
    hidden: yes
    sql: ${TABLE}."CREATED_AT" ;;
  }

  dimension: name {
    type: string
    sql: ${TABLE}."NAME" ;;
  }

  dimension: display_name {
    type: string
    sql: ${TABLE}."DISPLAY_NAME" ;;
  }

  dimension: end_user_visible {
    type: string
    hidden: yes
    sql: ${TABLE}."END_USER_VISIBLE" ;;
  }

  dimension: active {
    type: string
    hidden: yes
    sql: ${TABLE}."ACTIVE" ;;
  }

  dimension: _fivetran_deleted {
    type: string
    hidden: yes
    sql: ${TABLE}."_FIVETRAN_DELETED" ;;
  }

  dimension_group: _fivetran_synced {
    type: time
    hidden: yes
    sql: ${TABLE}."_FIVETRAN_SYNCED" ;;
  }

  set: detail {
    fields: [
      updated_at_time,
      id,
      created_at_time,
      name,
      display_name,
      end_user_visible,
      active,
      _fivetran_deleted,
      _fivetran_synced_time
    ]
  }
}
