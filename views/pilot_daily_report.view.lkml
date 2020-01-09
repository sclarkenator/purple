view: pilot_daily_report {
  sql_table_name: SHIPPING.PILOT_DAILY_REPORT ;;

  dimension: appointment {
    type: string
    sql: ${TABLE}."APPOINTMENT" ;;
  }

  dimension: consignee_city {
    type: string
    sql: ${TABLE}."CONSIGNEE_CITY" ;;
  }

  dimension: consignee_ref {
    type: string
    sql: ${TABLE}."CONSIGNEE_REF" ;;
  }

  dimension: current_status {
    type: string
    sql: ${TABLE}."CURRENT_STATUS" ;;
  }

  dimension_group: entry {
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
    sql: ${TABLE}."ENTRY" ;;
  }

  dimension: line_item_1 {
    type: string
    sql: ${TABLE}."LINE_ITEM_1" ;;
  }

  dimension: line_item_2 {
    type: string
    sql: ${TABLE}."LINE_ITEM_2" ;;
  }

  dimension: line_item_3 {
    type: string
    sql: ${TABLE}."LINE_ITEM_3" ;;
  }

  dimension: line_item_4 {
    type: string
    sql: ${TABLE}."LINE_ITEM_4" ;;
  }

  dimension: line_item_5 {
    type: string
    sql: ${TABLE}."LINE_ITEM_5" ;;
  }

  dimension: line_item_6 {
    type: string
    sql: ${TABLE}."LINE_ITEM_6" ;;
  }

  dimension_group: pickup {
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
    sql: ${TABLE}."PICKUP" ;;
  }

  dimension: pieces {
    type: number
    sql: ${TABLE}."PIECES" ;;
  }

  dimension: pieces_1 {
    type: number
    sql: ${TABLE}."PIECES_1" ;;
  }

  dimension: pieces_2 {
    type: number
    sql: ${TABLE}."PIECES_2" ;;
  }

  dimension: pieces_3 {
    type: number
    sql: ${TABLE}."PIECES_3" ;;
  }

  dimension: pieces_4 {
    type: number
    sql: ${TABLE}."PIECES_4" ;;
  }

  dimension: pieces_5 {
    type: number
    sql: ${TABLE}."PIECES_5" ;;
  }

  dimension: pieces_6 {
    type: number
    sql: ${TABLE}."PIECES_6" ;;
  }

  dimension_group: pod {
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
    sql: ${TABLE}."POD" ;;
  }

  dimension: pod_signature {
    type: string
    sql: ${TABLE}."POD_SIGNATURE" ;;
  }

  dimension: pro_number {
    type: string
    sql: ${TABLE}."PRO_NUMBER" ;;
  }

  dimension: shipper_city {
    type: string
    sql: ${TABLE}."SHIPPER_CITY" ;;
  }

  dimension: shipper_ref {
    type: string
    sql: ${TABLE}."SHIPPER_REF" ;;
  }

  dimension_group: status {
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
    sql: ${TABLE}."STATUS" ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
