view: zendesk_sell_deal {
  derived_table: {sql:
      select z.draft_count, a.*
      from customer_care.zendesk_sell_deal a
      left join (
            --getting max row num for each draft
            select draft_order_name , max(rownum) draft_count
            from (
              --applying row number to each draft order name
              select deal_id, draft_order_name
              , row_number () over (partition by draft_order_name order by deal_id) as rownum
              from customer_care.zendesk_sell_deal
            )
            group by 1
      ) z on z.draft_order_name = a.draft_order_name ;;
}

  dimension: age {
    type: number
    hidden: yes
    group_label: "Advanced - Sell"
    sql: ${TABLE}."AGE" ;;
  }

  dimension: amount {
    hidden: yes
    type: number
    group_label: "Advanced - Sell"
    sql: ${TABLE}."AMOUNT" ;;
  }

  dimension: contact_id {
    hidden: yes
    type: number
    group_label: "Advanced - Sell"
    sql: ${TABLE}."CONTACT_ID" ;;
  }

  dimension_group: created {
    hidden: yes
    type: time
    group_label: "Advanced - Sell"
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
    hidden: yes
    type: number
    group_label: "Advanced - Sell"
    sql: ${TABLE}."CUSTOMIZED_WIN_LIKELIHOOD" ;;
  }

  dimension: deal_id {
    hidden: yes
    primary_key: yes
    type: number
    group_label: "Advanced - Sell"
    sql: ${TABLE}."DEAL_ID" ;;
  }

  dimension: discount_codes {
    hidden: yes
    type: string
    group_label: "Advanced - Sell"
    sql: ${TABLE}."DISCOUNT_CODES" ;;
  }

  dimension: discount_eligibility_status {
    hidden: yes
    type: string
    group_label: "Advanced - Sell"
    sql: ${TABLE}."DISCOUNT_ELIGIBILITY_STATUS" ;;
  }

  dimension: draft_order_name {
    hidden: yes
    type: string
    group_label: "Advanced - Sell"
    drill_fields: [deal_id]
    sql: ${TABLE}."DRAFT_ORDER_NAME" ;;
  }

  dimension: draft_order_rank {
    hidden: yes
    type: number
    group_label: "Advanced - Sell"
    sql: ${TABLE}."DRAFT_ORDER_RANK" ;;
  }

  dimension_group: estimated_close {
    hidden: yes
    type: time
    group_label: "Advanced - Sell"
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
    hidden: yes
    type: string
    group_label: "Advanced - Sell"
    sql: ${TABLE}."FINANCING" ;;
  }

  dimension: gender {
    hidden: yes
    type: string
    group_label: "Advanced - Sell"
    sql: ${TABLE}."GENDER" ;;
  }

  dimension: lease_to_own {
    hidden: yes
    type: string
    group_label: "Advanced - Sell"
    sql: ${TABLE}."LEASE_TO_OWN" ;;
  }

  dimension: loss_reason_id {
    hidden: yes
    type: number
    group_label: "Advanced - Sell"
    sql: ${TABLE}."LOSS_REASON_ID" ;;
  }

  dimension: marital_status {
    hidden: yes
    type: string
    group_label: "Advanced - Sell"
    sql: ${TABLE}."MARITAL_STATUS" ;;
  }

  dimension: mattress_preference {
    hidden: yes
    type: string
    group_label: "Advanced - Sell"
    sql: ${TABLE}."MATTRESS_PREFERENCE" ;;
  }

  dimension: name {
    hidden: yes
    type: string
    group_label: "Advanced - Sell"
    sql: ${TABLE}."NAME" ;;
  }

  dimension: organization_id {
    hidden: yes
    type: number
    group_label: "Advanced - Sell"
    sql: ${TABLE}."ORGANIZATION_ID" ;;
  }

  dimension: preferred_sleeping_position {
    hidden: yes
    type: string
    group_label: "Advanced - Sell"
    sql: ${TABLE}."PREFERRED_SLEEPING_POSITION" ;;
  }

  dimension: related_tranid {
    hidden: yes
    type: string
    group_label: "Advanced - Sell"
    sql: ${TABLE}."RELATED_TRANID" ;;
  }

  dimension: related_tranid_rank {
    hidden: yes
    type: number
    group_label: "Advanced - Sell"
    sql: ${TABLE}."RELATED_TRANID_RANK" ;;
  }

  dimension: size {
    hidden: yes
    type: string
    group_label: "Advanced - Sell"
    sql: ${TABLE}."SIZE" ;;
  }

  dimension: source_name {
    type: string
    group_label: "Advanced - Sell"
    description: "Where the contact with the customer initiated. Source: zendesk_sell.zendesk_sell_deal"
    sql: ${TABLE}."SOURCE_NAME" ;;
  }

  dimension: stage_name {
    hidden: yes
    type: string
    group_label: "Advanced - Sell"
    sql: ${TABLE}."STAGE_NAME" ;;
  }

  dimension: tags {
    hidden: yes
    type: string
    group_label: "Advanced - Sell"
    sql: ${TABLE}."TAGS" ;;
  }

  dimension: timeframe_to_buy {
    hidden: yes
    type: string
    group_label: "Advanced - Sell"
    sql: ${TABLE}."TIMEFRAME_TO_BUY" ;;
  }

  dimension: user_id {
    hidden: yes
    type: number
    group_label: "Advanced - Sell"
    sql: ${TABLE}."USER_ID" ;;
  }

  dimension: draft_count {
    hidden: yes
    type: number
    group_label: "Advanced - Sell"
    sql: ${TABLE}.draft_count ;;
  }

  measure: count {
    hidden: yes
    type: count
    group_label: "Advanced - Sell"
    drill_fields: [name, draft_order_name, source_name, stage_name]
  }


  measure: Deal_ID_count {
    hidden: yes
    type: count
    group_label: "Advanced - Sell"
  }
  }
