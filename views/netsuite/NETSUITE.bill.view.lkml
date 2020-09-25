view: finance_bill {


    sql_table_name: finance.bill ;;

    dimension: bill_id{
      description: "Bill id"
      type:  number
      sql: ${TABLE}.BILL_ID ;;
      primary_key: yes
    }

    dimension: entity_id {
      type:  number
      sql: ${TABLE}.entity_id;;
    }

  dimension: channel_id {
    type:  number
    sql: ${TABLE}.channel_id;;
  }
  dimension: pfa_record_id {
    type:  number
    sql: ${TABLE}.PFA_RECORD_ID;;
  }
  dimension: purchase_order_id {
    type:  number
    sql: ${TABLE}.purchase_order_id;;
  }

  dimension: prepayment_po_id {
    type:  number
    sql: ${TABLE}.prepayment_po_id;;
  }
  dimension: accounting_period_id{
    type:  number
    sql: ${TABLE}.accounting_period_id;;
  }
  dimension: preferred_entity_bank_id {
    type:  number
    sql: ${TABLE}.preferred_entity_bank_id;;
  }
  dimension: reversing_transaction_id {
    type:  number
    sql: ${TABLE}.reversing_transaction_id;;
  }
  dimension: vp_purchase_order_bill_id{
    type:  number
    sql: ${TABLE}.vp_purchase_order_bill_id;;
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
  dimension_group: trandate {
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
    sql: ${TABLE}."TRANDATE" ;;
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
  dimension_group: due {
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
    sql: ${TABLE}."DUE" ;;
  }

  dimension_group: tax_point {
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
    sql: ${TABLE}."TAX_POINT" ;;
  }
  dimension_group: exworks {
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
    sql: ${TABLE}."EXWORKS" ;;
  }

  dimension_group: exfactory {
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
    sql: ${TABLE}."EXFACTORY" ;;
  }

  dimension_group: required_ship {
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
    sql: ${TABLE}."REQUIRED_SHIP" ;;
  }

  dimension_group: actual_invoice {
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
    sql: ${TABLE}."ACTUAL_INVOICE" ;;
  }
  dimension_group: sales_effective {
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
    sql: ${TABLE}."sales_effective" ;;
  }

  dimension: transaction_number {
    type:  string
    sql: ${TABLE}.transaction_number;;
  }

  dimension: tranid {
    type:  string
    sql: ${TABLE}.TRANID;;
  }

  dimension: transaction_type {
    type:  string
    sql: ${TABLE}.transaction_type;;
  }

  dimension: currency {
    type:  string
    sql: ${TABLE}.currency;;
  }


  dimension: payment_terms {
    type:  string
    sql: ${TABLE}.payment_terms;;
  }

  dimension: memo {
    type:  string
    sql: ${TABLE}.memo;;
  }

  dimension: exchange_rate {
    type:  number
    sql: ${TABLE}.exchange_rate;;
  }
  dimension: is_non_posting {
    type:  string
    sql: CASE WHEN ${TABLE}.is_non_posting = 'Yes' THEN 'Yes' ELSE 'No' END;;
  }
  dimension: is_payment_hold{
    type:  yesno
    sql: ${TABLE}.is_payment_hold;;
  }
  dimension: status{
    type:  yesno
    sql: ${TABLE}.status;;
  }
  dimension: location{
    type:  string
    sql: ${TABLE}.location;;
  }
  dimension: employee{
    type:  string
    sql: ${TABLE}.employee;;
  }

  dimension: billaddress{
    type:  string
    sql: ${TABLE}.billaddress;;
  }

  dimension: external_ref_number{
    type:  string
    sql: ${TABLE}.external_ref_number;;
  }

  dimension: with_prepayments{
    type:  yesno
    sql: ${TABLE}.with_prepayments;;
  }

  dimension: vendor_email{
    type:  string
    sql: ${TABLE}.vendor_email;;
  }

  dimension: account_based_number{
    type:  string
    sql: ${TABLE}.account_based_number;;
  }
  dimension: for_electronic_bank_payment{
    type:  yesno
    sql: ${TABLE}.for_electronic_bank_payment;;
  }
  dimension: transaction_source{
    type:  string
    sql: ${TABLE}.transaction_source;;
  }

  dimension:purchase_order{
    type:  string
    sql: ${TABLE}.purchase_order;;
  }
  dimension: is_N_1099_reimbursed {
    type:  yesno
    sql: ${TABLE}.N_1099_reimbursed;;
  }
  dimension: transaction_extid{
    type:  string
    sql: ${TABLE}.transaction_extid;;
  }
  dimension: incoterm{
    type:  yesno
    sql: ${TABLE}.incoterm;;
  }
  dimension: stampli_ap_invoice_url{
    type:  string
    sql: ${TABLE}.stampli_ap_invoice_url;;
  }
  dimension: incoterm_location{
    type:  string
    sql: ${TABLE}.incoterm_location;;
  }
  dimension: container_count{
    type:  number
    sql: ${TABLE}.container_count;;
  }
  dimension: workfront_request{
    type:  number
    sql: ${TABLE}.workfront_request;;
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
  measure: count {
    type: count }

}
