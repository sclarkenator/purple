view: v_first_data_order_num {
  sql_table_name: ACCOUNTING.V_FIRST_DATA_ORDER_NUM ;;

  dimension: amount {
    type: number
    sql: ${TABLE}."AMOUNT" ;;
  }

  dimension: auth_no {
    type: string
    sql: ${TABLE}."AUTH_NO" ;;
  }

  dimension: authorization {
    type: string
    sql: ${TABLE}."AUTHORIZATION" ;;
  }

  dimension: bank_resp_code {
    type: string
    sql: ${TABLE}."BANK_RESP_CODE" ;;
  }

  dimension: card_type {
    type: string
    sql: ${TABLE}."CARD_TYPE" ;;
  }

  dimension: code {
    type: string
    sql: ${TABLE}."CODE" ;;
  }

  dimension_group: created {
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
    sql: ${TABLE}."CREATED" ;;
  }

  dimension: cust_ref_num {
    type: string
    sql: ${TABLE}."CUST_REF_NUM" ;;
  }

  dimension: customer_name {
    type: string
    sql: ${TABLE}."CUSTOMER_NAME" ;;
  }

  dimension: expiry {
    type: number
    sql: ${TABLE}."EXPIRY" ;;
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
    sql: ${TABLE}."INSERT_TS" ;;
  }

  dimension: order_number {
    type: string
    sql: ${TABLE}."ORDER_NUMBER" ;;
  }

  dimension: ref_num {
    type: string
    sql: ${TABLE}."REF_NUM" ;;
  }

  dimension: tag {
    type: number
    sql: ${TABLE}."TAG" ;;
  }

  dimension: transaction_status {
    type: string
    sql: ${TABLE}."TRANSACTION_STATUS" ;;
  }

  dimension: primary_key {
    primary_key: yes
    sql: CONCAT(${order_number}, ${created_date}) ;;
    hidden: yes
  }

  measure: count {
    type: count
    drill_fields: [customer_name]
  }
}
