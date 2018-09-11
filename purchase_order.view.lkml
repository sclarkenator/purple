view: purchase_order {
  sql_table_name: PRODUCTION.PURCHASE_ORDER ;;

  dimension: purchase_order_id {
    primary_key: yes
    hidden: yes
    type: number
    sql: ${TABLE}."PURCHASE_ORDER_ID" ;;
  }

  dimension: channel {
    type: string
    sql: ${TABLE}."CHANNEL" ;;
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

  dimension: currency {
    type: string
    sql: ${TABLE}."CURRENCY" ;;
  }

  dimension: entity_id {
    type: number
    sql: ${TABLE}."ENTITY_ID" ;;
  }

  dimension: exchange_rate {
    type: number
    sql: ${TABLE}."EXCHANGE_RATE" ;;
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

  dimension: location_id {
    type: number
    hidden: yes
    sql: ${TABLE}."LOCATION_ID" ;;
  }

  dimension: Order_memo {
    type: string
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

  dimension: related_tranid {
    type: string
    sql: ${TABLE}."RELATED_TRANID" ;;
  }

  dimension: requester {
    type: string
    sql: ${TABLE}."REQUESTER" ;;
  }

  dimension_group: required_ship_by {
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
    sql: ${TABLE}."REQUIRED_SHIP_BY" ;;
  }

  dimension_group: sales_effective {
    type: time
    hidden: yes
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

  dimension: status {
    type: string
    sql: ${TABLE}."STATUS" ;;
  }

  dimension: terms {
    type: string
    sql: ${TABLE}."TERMS" ;;
  }

  dimension_group: trandate {
    type: time
    hidden: yes
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
    label: "Document Number"
    type: string
    link: {
      label: "NetSuite"
      url: "https://system.na2.netsuite.com/app/accounting/transactions/purchord.nl?id={{purchase_order.tranid._value}}"
    }
    sql: ${TABLE}."TRANID" ;;
  }

  dimension: transaction_number {
    type: string
    hidden: yes
    sql: ${TABLE}."TRANSACTION_NUMBER" ;;
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

  measure: Order_count {
    type: count
    drill_fields: [purchase_order_id, purchase_order_line.count]
  }
}
