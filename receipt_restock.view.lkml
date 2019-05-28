view: receipt_restock {
  sql_table_name: FINANCE.RECEIPT_RESTOCK ;;

  dimension: pk {
    type: string
    hidden: yes
    primary_key: yes
    sql: ${TABLE}."RECEIPT_ID" || ${TABLE}."ITEM_ID" ;;
  }

  dimension: amount {
    type: number
    hidden: yes
    sql: ${TABLE}."AMOUNT" ;;
  }

  dimension: amount_foreign {
    type: number
    hidden: yes
    sql: ${TABLE}."AMOUNT_FOREIGN" ;;
  }

  measure: total_amount {
    type: sum
    hidden: yes
    label: "Total Amount ($)"
    sql: ${TABLE}."AMOUNT" ;;
  }

  dimension: company_id {
    type: number
    hidden: yes
    sql: ${TABLE}."COMPANY_ID" ;;
  }

  dimension_group: created {
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
    sql: ${TABLE}."CREATED" ;;
  }

  dimension: do_restock {
    type: yesno
    description: "Indicates if the item has been restocked"
    sql: ${TABLE}."DO_RESTOCK" ;;
  }

  dimension_group: insert_ts {
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
    sql: ${TABLE}."INSERT_TS" ;;
  }

  dimension: item_count {
    type: number
    hidden: yes
    sql: ${TABLE}."ITEM_COUNT" ;;
  }

  measure: total_item_count {
    type: sum
    hidden: yes
    label: "Total Amount (units)"
    sql: ${TABLE}."ITEM_COUNT" ;;
  }

  dimension: item_id {
    type: number
    hidden: yes
    sql: ${TABLE}."ITEM_ID" ;;
  }

  dimension: item_unit_price {
    type: number
    hidden: yes
    sql: ${TABLE}."ITEM_UNIT_PRICE" ;;
  }

  dimension: memo {
    type: string
    hidden: yes
    label: "Receipt Memo"
    sql: ${TABLE}."MEMO" ;;
  }

  dimension_group: modified {
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
    sql: ${TABLE}."MODIFIED" ;;
  }

  dimension: product_line {
    type: string
    hidden: yes
    sql: ${TABLE}."PRODUCT_LINE" ;;
  }

  dimension: receipt_id {
    type: number
    hidden: yes
    sql: ${TABLE}."RECEIPT_ID" ;;
  }

  dimension: unit_of_measure {
    type: string
    hidden: yes
    sql: ${TABLE}."UNIT_OF_MEASURE" ;;
  }

  dimension_group: update_ts {
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
    sql: ${TABLE}."UPDATE_TS" ;;
  }

  measure: count {
    type: count
    hidden: yes
    drill_fields: []
  }
}
