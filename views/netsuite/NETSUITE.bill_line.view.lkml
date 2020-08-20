view: finance_bill_line {
    sql_table_name: finance.bill_line ;;

    dimension: bill_id{
      description: "Bill id"
      type:  number
      sql: ${TABLE}.BILL_ID ;;
    }

    dimension: bill_line_id {
      type:  number
      sql: ${TABLE}.bill_line_id;;
    }

    dimension: account_id {
      type:  number
      sql: ${TABLE}.account_id;;
    }
    dimension: item_id {
      type:  number
      sql: ${TABLE}.item_id;;
    }
    dimension: class_id {
      type:  number
      sql: ${TABLE}.class_id;;
    }

    dimension: company_id{
      type:  number
      sql: ${TABLE}.company_id;;
    }
    dimension: schedule_id{
      type:  number
      sql: ${TABLE}.schedule_id;;
    }
    dimension: expense_category_id {
      type:  number
      sql: ${TABLE}.expense_category_id;;
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
  dimension_group: modified {
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
    sql: ${TABLE}."MODIFIED" ;;
  }
  dimension_group: closed {
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
    sql: ${TABLE}."CLOSED" ;;
  }
  dimension_group: cleared {
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
    sql: ${TABLE}."CLEARED" ;;
  }
  dimension_group: actual_ship {
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
    sql: ${TABLE}."ACTUAL_SHIP" ;;
  }
  dimension_group: rev_rec_start {
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
    sql: ${TABLE}."REV_REC_START" ;;
  }
  dimension_group: rev_rec_end {
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
    sql: ${TABLE}."REV_REC_END" ;;
  }
  dimension_group: estimated_arrival {
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
    sql: ${TABLE}.estimated_arrival ;;
  }
  dimension_group: period_closed {
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
    sql: ${TABLE}.period_closed ;;
  }
  dimension: required_delivery {
    type:  string
    sql: ${TABLE}.required_delivery;;
  }
  dimension: amount {
    type:  number
    sql: ${TABLE}.amount;;
  }
  dimension: amount_foreign {
    type:  number
    sql: ${TABLE}.amount_foreign;;
  }
  dimension: amount_linked {
    type:  number
    sql: ${TABLE}.amount_linked;;
  }
  dimension: quantity {
    type:  number
    sql: ${TABLE}.quantity;;
  }
  dimension: location {
    type:  string
    sql: ${TABLE}.location;;
  }
  dimension: department  {
    type:  string
    sql: ${TABLE}.department;;
  }
  dimension: product_line  {
    type:  string
    sql: ${TABLE}.product_line;;
  }
  dimension:unit_of_measure  {
    type:  string
    sql: ${TABLE}.unit_of_measure;;
  }
  dimension:transaction_discount_line{
    type:  string
    sql: ${TABLE}.transaction_discount_line;;
  }
  dimension: memo  {
    type:  string
    sql: ${TABLE}.memo;;
  }
  dimension: has_cost_line {
    type:  string
    sql: ${TABLE}.has_cost_line;;
  }
  dimension:is_cost_line  {
    type:  string
    sql: ${TABLE}.is_cost_line;;
  }
  dimension: is_fx_variance  {
    type:  string
    sql: ${TABLE}.is_fx_variance;;
  }
  dimension_group: insert_ts{
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
  dimension: primary_key {
    primary_key: yes
    sql: CONCAT(${bill_id}, ${bill_line_id}) ;;
  }

  measure: count {
    type: count }



 }
