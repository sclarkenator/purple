view: expeditors {
  sql_table_name: "CSV_UPLOADS"."EXPEDITORS"
    ;;

  dimension: country_of_origin {
    type: string
    sql: ${TABLE}."COUNTRY_OF_ORIGIN" ;;
  }

  dimension: duty {
    type: number
    sql: ${TABLE}."DUTY" ;;
  }

  dimension: entered_value {
    type: number
    sql: ${TABLE}."ENTERED_VALUE" ;;
  }

  dimension_group: entry {
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
    sql: ${TABLE}."ENTRY_DATE" ;;
  }

  dimension: entry_no {
    type: string
    sql: ${TABLE}."ENTRY_NO" ;;
  }

  dimension: file_no {
    type: string
    sql: ${TABLE}."FILE_NO" ;;
  }

  dimension: hmf_harbor_fee {
    type: number
    sql: ${TABLE}."HMF_HARBOR_FEE" ;;
  }

  dimension_group: import {
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
    sql: ${TABLE}."IMPORT_DATE" ;;
  }

  dimension: importer_of_record {
    type: string
    sql: ${TABLE}."IMPORTER_OF_RECORD" ;;
  }

  dimension: inv_seq {
    type: string
    sql: ${TABLE}."INV_SEQ" ;;
  }

  dimension: invoice_bill_number {
    type: string
    sql: ${TABLE}."INVOICE_BILL_NUMBER" ;;
  }

  dimension: isf {
    type: string
    sql: ${TABLE}."ISF" ;;
  }

  dimension: item_description {
    type: string
    sql: ${TABLE}."ITEM_DESCRIPTION" ;;
  }

  dimension: item_number {
    type: string
    sql: ${TABLE}."ITEM_NUMBER" ;;
  }

  dimension: item_quantity {
    type: string
    sql: ${TABLE}."ITEM_QUANTITY" ;;
  }

  dimension: line_7501 {
    type: string
    sql: ${TABLE}."LINE_7501" ;;
  }

  dimension: line_seq {
    type: string
    sql: ${TABLE}."LINE_SEQ" ;;
  }

  dimension: mb {
    type: string
    sql: ${TABLE}."MB" ;;
  }

  dimension: mpf {
    type: number
    sql: ${TABLE}."MPF" ;;
  }

  dimension_group: payment {
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
    sql: ${TABLE}."PAYMENT_DATE" ;;
  }

  dimension: po_no {
    type: string
    sql: ${TABLE}."PO_NO" ;;
  }

  dimension: port_filing {
    type: string
    sql: ${TABLE}."PORT_FILING" ;;
  }

  dimension: tariff_desc {
    type: string
    sql: ${TABLE}."TARIFF_DESC" ;;
  }

  dimension: tariff_no {
    type: string
    sql: ${TABLE}."TARIFF_NO" ;;
  }

  dimension: tariff_rate {
    type: number
    sql: ${TABLE}."TARIFF_RATE" ;;
  }

  dimension: tariff_seq {
    type: string
    sql: ${TABLE}."TARIFF_SEQ" ;;
  }

  dimension: vessel {
    type: string
    sql: ${TABLE}."VESSEL" ;;
  }

  dimension: voyage_flight {
    type: string
    sql: ${TABLE}."VOYAGE_FLIGHT" ;;
  }

  dimension: x_v_indicator {
    type: string
    sql: ${TABLE}."X_V_INDICATOR" ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
 # Entered Value  Duty  MPF HMF Harbor Fee

  measure: total_entered_value {
    type: sum
    value_format: "$#,##0.00"
    sql: ${TABLE}.entered_value ;;
  }

  measure: total_duty {
    type: sum
    value_format: "$#,##0.00"
    sql: ${TABLE}.duty ;;
  }

  measure: total_hmf_harbor_fee {
    type: sum
    value_format: "$#,##0.00"
    sql: ${TABLE}.hmf_harbor_fee ;;
  }

}
