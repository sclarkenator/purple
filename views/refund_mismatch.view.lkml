view: refund_mismatch {
  sql_table_name: CUSTOMER_CARE.V_REFUND_MISMATCH ;;


  dimension: tax_discrepancy {
    type: string
    sql: ${TABLE}."TAX_DISCREPANCY" ;;
  }

  dimension: amount_diff {
    type: number
    value_format: "$0.00"
    sql: ${TABLE}."AMOUNT_DIFF";;
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
    value_format: "$0.00"
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

  dimension: url_shopify {
    hidden: yes
    type: string
    sql:
        CASE
            WHEN ${TABLE}."SOURCE" = 'Shopify - US' THEN ('onpurple')
            WHEN ${TABLE}."SOURCE" = 'Shopify - Canada' THEN ('purple-ca')
            ELSE Null
        END ;;
  }

  dimension: related_tranid {
    type: string
    label: "Check #"
    primary_key: yes
    link: {
      label: "Netsuite"
      url: "https://4651144.app.netsuite.com/app/accounting/transactions/{{url_type._value}}rfnd.nl?id={{transaction_id._value}}&whence="
      icon_url: "https://www.google.com/s2/favicons?domain=www.netsuite.com"
      }
    sql: ${TABLE}."RELATED_TRANID";;
  }

  dimension: etail_calculated_refund {
    type: string
    sql: ${TABLE}."ETAIL_CALCULATED_REFUND" ;;
  }

  dimension: etail_order_id {
    type: number
    sql: ${TABLE}."ETAIL_ORDER_ID" ;;
  }

  dimension: etail_refund_amounts {
    type: string
    sql: ${TABLE}."ETAIL_REFUND_AMOUNTS" ;;
  }

  dimension: etail_refund_updated {
    type: string
    label: "Etail Refund Exported"
    sql: ${TABLE}."ETAIL_REFUND_UPDATED" ;;
  }

  dimension: etail_total_refunded {
    type: number
    sql: ${TABLE}."ETAIL_TOTAL_REFUNDED" ;;
  }

  dimension: source {
    type: string
    sql: ${TABLE}."SOURCE" ;;
  }

  dimension: transaction_id {
    type: number
    sql: ${TABLE}."TRANSACTION_ID" ;;
  }

  dimension: transaction_number {
    type: string
    link: {
      label: "Shopify"
      url: "https://{{url_shopify._value}}.myshopify.com/admin/orders/{{etail_order_id._value}}"
      icon_url: "https://www.google.com/s2/favicons?domain=www.shopify.com"
    }
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
