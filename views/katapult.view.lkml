view: katapult {
  sql_table_name: "ACCOUNTING"."KATAPULT"
    ;;

  dimension: application_id {
    type: number
    sql: ${TABLE}."APPLICATION_ID" ;;
  }

  dimension: consumer_discount {
    type: number
    sql: ${TABLE}."CONSUMER_DISCOUNT" ;;
  }

  dimension_group: delivery {
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
    sql: ${TABLE}."DELIVERY" ;;
  }

  dimension: delivery_fee {
    type: number
    sql: ${TABLE}."DELIVERY_FEE" ;;
  }

  dimension: discount {
    type: number
    sql: ${TABLE}."DISCOUNT" ;;
  }

  dimension_group: effective {
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
    sql: ${TABLE}."EFFECTIVE" ;;
  }

  dimension: first_name {
    type: string
    sql: ${TABLE}."FIRST_NAME" ;;
  }

  dimension_group: funded {
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
    sql: ${TABLE}."FUNDED" ;;
  }

  dimension: funding_id {
    type: number
    sql: ${TABLE}."FUNDING_ID" ;;
  }

  dimension: gross_funding_amount {
    type: number
    sql: ${TABLE}."GROSS_FUNDING_AMOUNT" ;;
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
    sql: CAST(${TABLE}."INSERT_TS" AS TIMESTAMP_NTZ) ;;
  }

  dimension: interchange_payable {
    type: number
    sql: ${TABLE}."INTERCHANGE_PAYABLE" ;;
  }

  dimension: is_funded {
    type: yesno
    sql: ${TABLE}."IS_FUNDED" ;;
  }

  dimension: last_name {
    type: string
    sql: ${TABLE}."LAST_NAME" ;;
  }

  dimension: leasable_items_value {
    type: number
    sql: ${TABLE}."LEASABLE_ITEMS_VALUE" ;;
  }

  dimension: lease_status {
    type: string
    sql: ${TABLE}."LEASE_STATUS" ;;
  }

  dimension: net_funding_amount {
    type: number
    sql: ${TABLE}."NET_FUNDING_AMOUNT" ;;
  }

  dimension: nonleasable_items_value {
    type: number
    sql: ${TABLE}."NONLEASABLE_ITEMS_VALUE" ;;
  }

  dimension: order_id {
    type: number
    sql: ${TABLE}."ORDER_ID" ;;
  }

  dimension_group: origination {
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
    sql: ${TABLE}."ORIGINATION" ;;
  }

  dimension: rebate {
    type: number
    sql: ${TABLE}."REBATE" ;;
  }

  dimension: running_total {
    type: number
    sql: ${TABLE}."RUNNING_TOTAL" ;;
  }

  dimension: store {
    type: string
    sql: ${TABLE}."STORE" ;;
  }

  dimension: transaction_detail {
    type: string
    sql: ${TABLE}."TRANSACTION_DETAIL" ;;
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
    sql: CAST(${TABLE}."UPDATE_TS" AS TIMESTAMP_NTZ) ;;
  }

  measure: count {
    type: count
    drill_fields: [first_name, last_name]
  }
}
