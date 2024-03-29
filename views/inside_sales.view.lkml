view: inside_sales {
  sql_table_name: CUSTOMER_CARE.INSIDE_SALES
    ;;

  dimension: deal_id {
    type: number
    sql: ${TABLE}.DEAL_ID ;;
  }

  dimension: fraud_risk {
    type: string
    sql: ${TABLE}.FRAUD_RISK ;;
  }

  dimension_group: insert_ts {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.INSERT_TS ;;
  }

  dimension: order_id {
    type: number
    sql: ${TABLE}.ORDER_ID ;;
  }

  dimension: order_link {
    type: string
    sql: ${TABLE}.ORDER_LINK ;;
  }

  dimension_group: update_ts {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.UPDATE_TS ;;
  }

  dimension: zendesk_sell_user_id {
    type: number
    sql: ${TABLE}.ZENDESK_SELL_USER_ID ;;
  }

  dimension: RETAIL_AGENT {
    type: yesno
    label: " * Is Retail Agent"
    description: "Yes if agent is a retail agent"
    sql: ${TABLE}.RETAIL_AGENT = 'TRUE' ;;
  }

  dimension: LIVEPERSON_AGENT_ID {
    type: string
    hidden: yes
    sql: ${TABLE}.LIVEPERSON_AGENT_ID ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
