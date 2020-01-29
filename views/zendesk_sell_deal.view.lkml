view: zendesk_sell_deal {
  sql_table_name: "CUSTOMER_CARE"."ZENDESK_SELL_DEAL"
    ;;

  dimension: age {
    type: number
    sql: ${TABLE}."AGE" ;;
  }

  dimension: amount {
    type: number
    sql: ${TABLE}."AMOUNT" ;;
  }

  dimension: contact_id {
    type: number
    sql: ${TABLE}."CONTACT_ID" ;;
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
    sql: ${TABLE}."CREATED_AT" ;;
  }

  dimension: customized_win_likelihood {
    type: number
    sql: ${TABLE}."CUSTOMIZED_WIN_LIKELIHOOD" ;;
  }

  dimension: deal_id {
    type: number
    sql: ${TABLE}."DEAL_ID" ;;
  }

  dimension: discount_codes {
    type: string
    sql: ${TABLE}."DISCOUNT_CODES" ;;
  }

  dimension: discount_eligibility_status {
    type: string
    sql: ${TABLE}."DISCOUNT_ELIGIBILITY_STATUS" ;;
  }

  dimension: draft_order_name {
    type: string
    drill_fields: [deal_id]
    sql: ${TABLE}."DRAFT_ORDER_NAME" ;;
  }

  dimension: draft_order_rank {
    type: number
    sql: ${TABLE}."DRAFT_ORDER_RANK" ;;
  }

  dimension_group: estimated_close {
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
    sql: ${TABLE}."ESTIMATED_CLOSE_DATE" ;;
  }

  dimension: financing {
    type: string
    sql: ${TABLE}."FINANCING" ;;
  }

  dimension: gender {
    type: string
    sql: ${TABLE}."GENDER" ;;
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

  dimension: lease_to_own {
    type: string
    sql: ${TABLE}."LEASE_TO_OWN" ;;
  }

  dimension: loss_reason_id {
    type: number
    sql: ${TABLE}."LOSS_REASON_ID" ;;
  }

  dimension: marital_status {
    type: string
    sql: ${TABLE}."MARITAL_STATUS" ;;
  }

  dimension: mattress_preference {
    type: string
    sql: ${TABLE}."MATTRESS_PREFERENCE" ;;
  }

  dimension: name {
    type: string
    sql: ${TABLE}."NAME" ;;
  }

  dimension: organization_id {
    type: number
    sql: ${TABLE}."ORGANIZATION_ID" ;;
  }

  dimension: preferred_sleeping_position {
    type: string
    sql: ${TABLE}."PREFERRED_SLEEPING_POSITION" ;;
  }

  dimension: related_tranid {
    type: string
    sql: ${TABLE}."RELATED_TRANID" ;;
  }

  dimension: related_tranid_rank {
    type: number
    sql: ${TABLE}."RELATED_TRANID_RANK" ;;
  }

  dimension: size {
    type: string
    sql: ${TABLE}."SIZE" ;;
  }

  dimension: source_name {
    type: string
    sql: ${TABLE}."SOURCE_NAME" ;;
  }

  dimension: stage_name {
    type: string
    sql: ${TABLE}."STAGE_NAME" ;;
  }

  dimension: tags {
    type: string
    sql: ${TABLE}."TAGS" ;;
  }

  dimension: timeframe_to_buy {
    type: string
    sql: ${TABLE}."TIMEFRAME_TO_BUY" ;;
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
    sql: ${TABLE}."UPDATE_TS" ;;
  }

  dimension: user_id {
    type: number
    sql: ${TABLE}."USER_ID" ;;
  }

  measure: count {
    type: count
    drill_fields: [name, draft_order_name, source_name, stage_name]
  }


measure: Deal_ID_count {
    type: count

  }
  }
