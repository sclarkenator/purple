view: v_intransit {
  sql_table_name: "PRODUCTION"."V_INTRANSIT"
    ;;

  dimension: amount_unbilled {
    type: number
    sql: ${TABLE}."AMOUNT_UNBILLED" ;;
    value_format: "$#.00;($#.00)"
  }

  dimension: bol {
    type: string
    sql: ${TABLE}."BOL" ;;
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

  dimension: from_location {
    type: string
    sql: ${TABLE}."FROM_LOCATION" ;;
  }

  dimension: memo {
    type: string
    sql: ${TABLE}."MEMO" ;;
  }

  dimension: po_tranid {
    type: string
    sql: ${TABLE}."PO_TRANID" ;;
  }

  dimension: receiving_location {
    type: string
    sql: ${TABLE}."RECEIVING_LOCATION" ;;
  }

  dimension: status {
    type: string
    sql: ${TABLE}."STATUS" ;;
  }

  dimension: tranid {
    type: string
    sql: ${TABLE}."TRANID" ;;
  }

  dimension: vendor {
    type: string
    sql: ${TABLE}."VENDOR" ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
