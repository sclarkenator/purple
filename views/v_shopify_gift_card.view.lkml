view: v_shopify_gift_card {
  sql_table_name: "ACCOUNTING"."V_SHOPIFY_GIFT_CARD"
    ;;

  dimension: amount {
    type: number
    sql: ${TABLE}."AMOUNT" ;;
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
    sql: CAST(${TABLE}."CREATED_AT" AS TIMESTAMP_NTZ) ;;
  }

  dimension: etail_order_id {
    type: number
    link: {
      label: "Shopify"
      url: "https://{{url_shopify._value}}.myshopify.com/admin/orders/{{etail_order_id._value}}"
      icon_url: "https://www.google.com/s2/favicons?domain=www.shopify.com"
      }
    description: "This is Shopify's internal ID. This will be a hyperlink to the sales order in Shopify."
    sql: ${TABLE}."ETAIL_ORDER_ID" ;;
  }

  dimension: gift_card_last_characters {
    type: string
    sql: ${TABLE}."GIFT_CARD_LAST_CHARACTERS" ;;
  }

  dimension: kind {
    type: string
    sql: ${TABLE}."KIND" ;;
  }

  dimension: order_id {
    label: "Order ID"
    hidden: no
    link: {
      label: "Netsuite"
      url: "https://4651144.app.netsuite.com/app/accounting/transactions/salesord.nl?id={{value}}&whence="
      icon_url: "https://www.google.com/s2/favicons?domain=www.netsuite.com"
      }
    description: "This is Netsuite's internal ID. This will be a hyperlink to the sales order in Netsuite."
    type: string
    sql: ${TABLE}."ORDER_ID" ;;
  }

  dimension_group: processed {
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
    sql: CAST(${TABLE}."PROCESSED_AT" AS TIMESTAMP_NTZ) ;;
  }

  dimension: receipt {
    type: string
    sql: ${TABLE}."RECEIPT" ;;
  }

  dimension: refund_id {
    type: number
    sql: ${TABLE}."REFUND_ID" ;;
  }

  dimension: related_tranid {
    type: string
    sql: ${TABLE}."RELATED_TRANID" ;;
  }

  dimension: shopify_transaction_id {
    type: number
    sql: ${TABLE}."SHOPIFY_TRANSACTION_ID" ;;
  }

  dimension: source {
    type: string
    sql: ${TABLE}."SOURCE" ;;
  }

  dimension: source_name {
    type: string
    sql: ${TABLE}."SOURCE_NAME" ;;
  }

  dimension: status {
    type: string
    sql: ${TABLE}."STATUS" ;;
  }

  dimension: system {
    type: string
    sql: ${TABLE}."SYSTEM" ;;
  }

  dimension: tranid {
    type: string
    sql: ${TABLE}."TRANID" ;;
  }

  dimension: url_shopify {
    hidden: yes
    type: string
    sql:
        CASE
            WHEN ${TABLE}."SOURCE" = 'Shopify - US' THEN ('onpurple')
            WHEN ${TABLE}."SOURCE" = 'SHOPIFY-US Historical' THEN ('onpurple')
            WHEN ${TABLE}."SOURCE" = 'Shopify - Canada' THEN ('purple-ca')
            WHEN ${TABLE}."SOURCE" = 'Shopify - POS' THEN ('purpleoutlet')
            ELSE Null
        END ;;
  }

  measure: count {
    type: count
    drill_fields: [source_name]
  }
}
