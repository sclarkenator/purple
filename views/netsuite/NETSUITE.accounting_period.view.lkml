view: accounting_period {
  sql_table_name: "FINANCE"."ACCOUNTING_PERIOD"
    ;;
  drill_fields: [accounting_period_id]

  dimension: accounting_period_id {
    primary_key: yes
    hidden: yes
    type: number
    sql: ${TABLE}."ACCOUNTING_PERIOD_ID" ;;
  }

  dimension: adjustment {
    hidden: yes
    type: string
    sql: ${TABLE}."ADJUSTMENT" ;;
  }

  dimension: closed_accounts_payable {
    hidden: yes
    type: string
    sql: ${TABLE}."CLOSED_ACCOUNTS_PAYABLE" ;;
  }

  dimension: closed_accounts_receivable {
    hidden: yes
    type: string
    sql: ${TABLE}."CLOSED_ACCOUNTS_RECEIVABLE" ;;
  }

  dimension: closed_payroll {
    hidden: yes
    type: string
    sql: ${TABLE}."CLOSED_PAYROLL" ;;
  }

  dimension: inactive {
    hidden: yes
    type: string
    sql: ${TABLE}."INACTIVE" ;;
  }

  dimension: locked_accounts_payable {
    hidden: yes
    type: string
    sql: ${TABLE}."LOCKED_ACCOUNTS_PAYABLE" ;;
  }

  dimension: locked_accounts_receivable {
    hidden: yes
    type: string
    sql: ${TABLE}."LOCKED_ACCOUNTS_RECEIVABLE" ;;
  }

  dimension: locked_payroll {
    hidden: yes
    type: string
    sql: ${TABLE}."LOCKED_PAYROLL" ;;
  }

  dimension: name {
    type: string
    sql: ${TABLE}."NAME" ;;
  }

  dimension: parent_id {
    hidden: yes
    type: number
    sql: ${TABLE}."PARENT_ID" ;;
  }

  dimension_group: period_closed {
    hidden: yes
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
    sql: CAST(${TABLE}."PERIOD_CLOSED" AS TIMESTAMP_NTZ) ;;
  }

  dimension_group: period_end {
    hidden: yes
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}."PERIOD_END" ;;
  }

  dimension_group: period_start {
    hidden: yes
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}."PERIOD_START" ;;
  }

  dimension: type {
    hidden: yes
    type: string
    sql: ${TABLE}."TYPE" ;;
  }

  measure: count {
    hidden: yes
    type: count
    drill_fields: [accounting_period_id, name]
  }
}
