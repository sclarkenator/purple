view: account {
  sql_table_name: "SALES"."ACCOUNT"
    ;;
  drill_fields: [account_id]

  dimension: account_id {
    primary_key: yes
    hidden: no
    type: number
    sql: ${TABLE}."ACCOUNT_ID" ;;
  }

  dimension: accountnumber {
    hidden: no
    label: "Account Number"
    type: string
    sql: ${TABLE}."ACCOUNTNUMBER" ;;
  }

  dimension: cashflow_rate_type {
    hidden: yes
    type: string
    sql: ${TABLE}."CASHFLOW_RATE_TYPE" ;;
  }

  dimension: description {
    hidden: no
    type: string
    sql: ${TABLE}."DESCRIPTION" ;;
  }

  dimension: general_rate_type {
    hidden: yes
    type: string
    sql: ${TABLE}."GENERAL_RATE_TYPE" ;;
  }

  dimension: is_balancesheet {
    hidden: yes
    type: string
    sql: ${TABLE}."IS_BALANCESHEET" ;;
  }

  dimension: is_included_in_reval {
    hidden: yes
    type: string
    sql: ${TABLE}."IS_INCLUDED_IN_REVAL" ;;
  }

  dimension: is_including_child_subs {
    hidden: yes
    type: string
    sql: ${TABLE}."IS_INCLUDING_CHILD_SUBS" ;;
  }

  dimension: is_leftside {
    hidden: yes
    type: string
    sql: ${TABLE}."IS_LEFTSIDE" ;;
  }

  dimension: isinactive {
    hidden: yes
    type: string
    sql: ${TABLE}."ISINACTIVE" ;;
  }

  dimension: name {
    type: string
    sql: ${TABLE}."NAME" ;;
  }

  dimension: openbalance {
    hidden: yes
    type: number
    sql: ${TABLE}."OPENBALANCE" ;;
  }

  dimension: type_name {
    hidden: no
    type: string
    sql: ${TABLE}."TYPE_NAME" ;;
  }

  dimension: type_sequence {
    hidden: yes
    type: number
    sql: ${TABLE}."TYPE_SEQUENCE" ;;
  }

  measure: count {
    hidden: yes
    type: count
    drill_fields: [account_id, name, type_name]
  }
}
