view: v_visitors_view_normailized_ids {
  sql_table_name: "TEALIUM"."V_VISITORS_VIEW_NORMAILIZED_IDS"
    ;;

  dimension_group: updated {
    type: time
    hidden: yes
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}."UPDATED" ;;
  }

  dimension: visitor_id {
    type: string
    hidden: yes
    sql: ${TABLE}."VISITOR_ID" ;;
  }

  dimension: vp_customer_email {
    type: string
    label: "Customer Email"
    sql: ${TABLE}."VP_CUSTOMER_EMAIL" ;;
  }

  measure: count {
    type: count
    hidden:  yes
    drill_fields: []
  }
}
