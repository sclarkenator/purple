view: refund_mismatch {
  sql_table_name: CUSTOMER_CARE.REFUND_MISMATCH ;;

  dimension: amount_diff {
    type: number
    sql: ${TABLE}."AMOUNT_DIFF" ;;
  }

  dimension_group: created {
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
    sql: ${TABLE}."CREATED" ;;
  }

  dimension: created_from_type {
    type: string
    sql: ${TABLE}."CREATED_FROM_TYPE" ;;
  }

  dimension: etail_refund_exported {
    type: string
    sql: ${TABLE}."ETAIL_REFUND_EXPORTED" ;;
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

  dimension: netsuite_amount {
    type: number
    sql: ${TABLE}."NETSUITE_AMOUNT" ;;
  }

  dimension: n_3pl_cancellation_status {
    type: string
    sql: ${TABLE}."N_3PL_CANCELLATION_STATUS" ;;
  }


  dimension: quantity {
    type: string
    sql: ${TABLE}."QUANTITY" ;;
  }

  dimension: refund_number {
    type: number
    value_format: "0"
    sql: ${TABLE}."REFUND_NUMBER" ;;
  }

  dimension: url_type {
    hidden: yes
    type: string
    sql:
        CASE
            WHEN ${TABLE}."TYPE" = 'Cash Refund' THEN ('cash')
            WHEN ${TABLE}."TYPE" = 'Customer Refund' THEN ('cust')
            ELSE Null
        END ;;
  }

  dimension: related_tranid {
    type: string
    label: "Check #"
    link: {
      label: "Netsuite"
      url: "https://4651144.app.netsuite.com/app/accounting/transactions/{{url_type._value}}rfnd.nl?id={{transaction_id._value}}&whence="}
    sql: ${TABLE}."RELATED_TRANID";;
  }

  dimension: shopify_order_id {
    type: number
    sql: ${TABLE}."SHOPIFY_ORDER_ID" ;;
  }

  dimension: shopify_refund_amounts {
    type: string
    sql: ${TABLE}."SHOPIFY_REFUND_AMOUNTS" ;;
  }

  dimension: shopify_refund_updated {
    type: string
    label: "Shopify Refund Exported"
    sql: ${TABLE}."SHOPIFY_REFUND_UPDATED" ;;
  }

  dimension: shopify_total_refunded {
    type: number
    sql: ${TABLE}."SHOPIFY_TOTAL_REFUNDED" ;;
  }

  dimension: transaction_id {
    type: number
    sql: ${TABLE}."TRANSACTION_ID" ;;
  }

  dimension: transaction_number {
    type: string
    link: {
    label: "Shopify - US"
    url: "https://onpurple.myshopify.com/admin/orders/{{shopify_order_id._value}}"}
    sql: ${TABLE}."TRANSACTION_NUMBER" ;;
  }

  dimension: type {
    type: string
    sql: ${TABLE}."TYPE" ;;
  }


  measure: count {
    type: count
    drill_fields: []
  }
}
