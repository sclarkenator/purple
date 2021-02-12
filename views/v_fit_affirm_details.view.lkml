view: v_fit_affirm_details {
  derived_table: {
    sql:
      select
        h.id
        , t.created
        , t.event_type
        , t.amount
      from analytics.accounting.affirm_transaction t
      join analytics.accounting.affirm_header h on t.entry_id = h.id
      where h.id = 'Z5JY-VA0T'
    ;;
  }
  dimension: h_id {
    type: string
    sql: ${TABLE}.id ;;
  }
  dimension: created {
    type: date_time
    sql: ${TABLE}.created ;;
  }
  dimension: event_type {
    type: string
    sql: ${TABLE}.event_type ;;
  }
  dimension: amount {
    type: number
    sql: ${TABLE}.amount ;;
  }
  dimension: pk {
    type: string
    primary_key: yes
    sql: ${created} || ${h_id} || ${event_type} ;;
  }
  measure: total_amount {
    type: sum
    sql: ${TABLE}.amount ;;
  }
}
