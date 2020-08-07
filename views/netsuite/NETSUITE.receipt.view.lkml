view: receipt {
  sql_table_name: "FINANCE"."RECEIPT"
    ;;
  drill_fields: [receipt_id]

  dimension: receipt_id {
    primary_key: yes
    group_label: " Advanced"
    type: number
    link: {
      label: "Netsuite"
      url: "https://4651144.app.netsuite.com/app/accounting/transactions/itemrcpt.nl?id={{value}}&whence="
      icon_url: "https://www.google.com/s2/favicons?domain=www.netsuite.com"
    }
    sql: ${TABLE}."RECEIPT_ID" ;;
  }

  dimension: accounting_period {
    group_label: " Advanced"
    description: "Source: netsuite.receipt"
    type: string
    sql: ${TABLE}."ACCOUNTING_PERIOD" ;;
  }

  dimension_group: created {
    description: "Source: netsuite.receipt"
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

  dimension: created_by {
    group_label: " Advanced"
    description: "Source: netsuite.receipt"
    type: string
    sql: ${TABLE}."CREATED_BY" ;;
  }

  dimension: currency {
    group_label: " Advanced"
    description: "Source: netsuite.receipt"
    type: string
    sql: ${TABLE}."CURRENCY" ;;
  }

  dimension: entity_name {
    group_label: " Advanced"
    description: "Source: netsuite.receipt"
    type: string
    sql: ${TABLE}."ENTITY_NAME" ;;
  }

  dimension_group: in_hand {
    description: "Source: netsuite.receipt"
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
    sql: ${TABLE}."IN_HAND" ;;
  }

  dimension: incoterm {
    hidden:  yes
    group_label: " Advanced"
    description: "Source: netsuite.receipt"
    type: string
    sql: ${TABLE}."INCOTERM" ;;
  }

  dimension: landed_cost_allocation_method {
    group_label: " Advanced"
    description: "Source: netsuite.receipt"
    type: string
    sql: ${TABLE}."LANDED_COST_ALLOCATION_METHOD" ;;
  }

  dimension: location {
    group_label: " Advanced"
    description: "Source: netsuite.receipt"
    type: string
    sql: ${TABLE}."LOCATION" ;;
  }

  dimension: memo {
    group_label: " Advanced"
    description: "Source: netsuite.receipt"
    type: string
    sql: ${TABLE}."MEMO" ;;
  }

  dimension: original_tranid {
    group_label: " Advanced"
    description: "Source: netsuite.receipt"
    type: string
    sql: ${TABLE}."ORIGINAL_TRANID" ;;
  }

  dimension: original_transaction_id {
    group_label: " Advanced"
    description: "Source: netsuite.receipt"
    type: number
    sql: ${TABLE}."ORIGINAL_TRANSACTION_ID" ;;
  }

  dimension: packing_list {
    group_label: " Advanced"
    description: "Source: netsuite.receipt"
    type: string
    sql: ${TABLE}."PACKING_LIST" ;;
  }

  dimension_group: required_ship {
    description: "Source: netsuite.receipt"
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
    sql: ${TABLE}."REQUIRED_SHIP" ;;
  }

  dimension_group: sales_effective {
    description: "Source: netsuite.receipt"
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
    sql: ${TABLE}."SALES_EFFECTIVE" ;;
  }

  dimension: sales_rep {
    group_label: " Advanced"
    description: "Source: netsuite.receipt"
    type: string
    sql: ${TABLE}."SALES_REP" ;;
  }

  dimension_group: trandate {
    hidden:  yes
    description: "Source: netsuite.receipt"
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
    sql: ${TABLE}."TRANDATE" ;;
  }

  dimension: tranid {
    group_label: " Advanced"
    description: "Source: netsuite.receipt"
    type: string
    sql: ${TABLE}."TRANID" ;;
  }

  dimension: transaction_number {
    group_label: " Advanced"
    description: "Source: netsuite.receipt"
    type: string
    sql: ${TABLE}."TRANSACTION_NUMBER" ;;
  }

  dimension: transaction_type {
    group_label: " Advanced"
    label: "Original Transaction Type"
    description: "Source: netsuite.receipt"
    type: string
    sql: ${TABLE}."TRANSACTION_TYPE" ;;
  }

  dimension: transfer_location {
    group_label: " Advanced"
    description: "Source: netsuite.receipt"
    type: string
    sql: ${TABLE}."TRANSFER_LOCATION" ;;
  }

  measure: count {
    hidden:  no
    type: count
    drill_fields: [receipt_id, entity_name]
  }

  measure: exchange_rate {
    group_label: " Advanced"
    description: "Source: netsuite.receipt"
    type: average
    sql: ${TABLE}."EXCHANGE_RATE" ;;
  }
}
