view: wholesale_mfrm_manual_asn {
  sql_table_name: MATTRESS_FIRM.WHOLESALE_MFRM_MANUAL_ASN ;;

  dimension_group: actual_ship {
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
    sql: ${TABLE}."ACTUAL_SHIP" ;;
  }

  dimension: order_id {
    type: number
    sql: ${TABLE}."ORDER_ID" ;;
  }

  dimension: po_check_number {
    type: string
    sql: ${TABLE}."PO_CHECK_NUMBER" ;;
  }

  dimension: status {
    type: string
    sql: ${TABLE}."STATUS" ;;
  }

  dimension: tracking_numbers {
    type: string
    sql: ${TABLE}."TRACKING_NUMBERS" ;;
  }

  dimension_group: trandate {
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

  measure: count {
    type: count
    drill_fields: []
  }
}
