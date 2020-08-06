view: receipt_line {
  sql_table_name: "FINANCE"."RECEIPT_LINE"
    ;;
  drill_fields: [receipt_line_id]

  dimension: pk{
    type: string
    primary_key:  yes
    hidden:  yes
    sql: ${TABLE}.receipt_id||'-'||${TABLE}.receipt_line_id ;;
  }

  dimension: receipt_line_id {
    hidden: yes
    group_label: " Advanced"
    description: "Source: netsuite.receipt_line"
    type: number
    sql: ${TABLE}."RECEIPT_LINE_ID" ;;
  }

  dimension: account {
    hidden: yes
    group_label: " Advanced"
    description: "Source: netsuite.receipt_line"
    type: string
    sql: ${TABLE}."ACCOUNT" ;;
  }

  dimension: company_id {
    group_label: " Advanced"
    description: "Source: netsuite.receipt_line"
    type: number
    sql: ${TABLE}."COMPANY_ID" ;;
  }

  dimension_group: created {
    description: "Source: netsuite.receipt_line"
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
    sql: CAST(${TABLE}."CREATED" AS TIMESTAMP_NTZ) ;;
  }

  dimension: department {
    group_label: " Advanced"
    description: "Source: netsuite.receipt_line"
    type: string
    sql: ${TABLE}."DEPARTMENT" ;;
  }

  dimension: do_restock {
    hidden: yes
    group_label: " Advanced"
    description: "Source: netsuite.receipt_line"
    type: string
    sql: ${TABLE}."DO_RESTOCK" ;;
  }

  dimension_group: estimated_arrival {
    description: "Source: netsuite.receipt_line"
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
    sql: ${TABLE}."ESTIMATED_ARRIVAL" ;;
  }

  dimension: has_cost_line {
    hidden: yes
    group_label: " Advanced"
    description: "Source: netsuite.receipt_line"
    type: string
    sql: ${TABLE}."HAS_COST_LINE" ;;
  }

  dimension: intransit {
    label: " * In Transit"
    description: "Source: netsuite.receipt_line"
    type: yesno
    sql: ${TABLE}."INTRANSIT" ;;
  }

  dimension: is_cost_line {
    hidden: yes
    description: "Source: netsuite.receipt_line"
    type: string
    sql: ${TABLE}."IS_COST_LINE" ;;
  }

  dimension: is_landed_cost {
    hidden: yes
    description: "Source: netsuite.receipt_line"
    type: string
    sql: ${TABLE}."IS_LANDED_COST" ;;
  }

  dimension: item_id {
    hidden: no
    group_label: " Advanced"
    description: "Source: netsuite.receipt_line"
    type: number
    sql: ${TABLE}."ITEM_ID" ;;
  }

  dimension: item_unit_price {
    group_label: " Advanced"
    description: "Source: netsuite.receipt_line"
    type: number
    sql: ${TABLE}."ITEM_UNIT_PRICE" ;;
  }

  dimension: kit_part_number {
    group_label: " Advanced"
    description: "Source: netsuite.receipt_line"
    type: string
    sql: ${TABLE}."KIT_PART_NUMBER" ;;
  }

  dimension: memo {
    group_label: " Advanced"
    description: "Source: netsuite.receipt_line"
    type: string
    sql: ${TABLE}."MEMO" ;;
  }

  dimension: part_number_print {
    group_label: " Advanced"
    description: "Source: netsuite.receipt_line"
    type: string
    sql: ${TABLE}."PART_NUMBER_PRINT" ;;
  }

  dimension: product_line {
    group_label: " Advanced"
    description: "Source: netsuite.receipt_line"
    type: string
    sql: ${TABLE}."PRODUCT_LINE" ;;
  }

  dimension: receipt_id {
    hidden: yes
    group_label: " Advanced"
    description: "Source: netsuite.receipt_line"
    type: number
    sql: ${TABLE}."RECEIPT_ID" ;;
  }

  dimension: required_delivery {
    hidden: yes
    group_label: " Advanced"
    description: "Source: netsuite.receipt_line"
    type: string
    sql: ${TABLE}."REQUIRED_DELIVERY" ;;
  }

  dimension_group: tmp_required_delivery {
    label: "Required Delivery"
    description: "Source: netsuite.receipt_line"
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
    sql: ${TABLE}."TMP_REQUIRED_DELIVERY" ;;
  }

  dimension: unit_of_measure {
    group_label: " Advanced"
    description: "Source: netsuite.receipt_line"
    type: string
    sql: ${TABLE}."UNIT_OF_MEASURE" ;;
  }

  measure: amount {
    group_label: " Advanced"
    description: "Source: netsuite.receipt_line"
    type: sum
    sql: ${TABLE}."AMOUNT" ;;
  }

  measure: amount_foreign {
    hidden:  yes
    group_label: " Advanced"
    description: "Source: netsuite.receipt_line"
    type: sum
    sql: ${TABLE}."AMOUNT_FOREIGN" ;;
  }

  measure: count {
    hidden: no
    group_label: " Advanced"
    type: count
    drill_fields: [receipt_line_id]
  }

  measure: item_count {
    group_label: " Advanced"
    description: "Source: netsuite.receipt_line"
    type: sum
    sql: ${TABLE}."ITEM_COUNT" ;;
  }
}
