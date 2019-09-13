view: warranty_timeline {
  sql_table_name: ACCOUNTING.WARRANTY_TIMELINE ;;

  dimension_group: fulfilled {
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
    sql: ${TABLE}."FULFILLED" ;;
  }

  dimension: fulfillment_id {
    type: number
    sql: ${TABLE}."FULFILLMENT_ID" ;;
    hidden:  yes
  }

  dimension: fulfillment_tranid {
    type: number
    value_format_name: id
    link: {
      label: "Netsuite"
      url: "https://4651144.app.netsuite.com/app/accounting/transactions/itemship.nl?id={{fulfillment_id._value}}&whence="}
    sql: ${TABLE}."FULFILLMENT_TRANID" ;;
  }


  dimension: item_id {
    type: number
    sql: ${TABLE}."ITEM_ID" ;;
  }

  dimension_group: original_created {
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
    sql: ${TABLE}."ORIGINAL_CREATED" ;;
  }

  dimension: original_order_id {
    type: number
    value_format: "0"
    sql: ${TABLE}."ORIGINAL_ORDER_ID" ;;
    hidden:  yes
  }

  dimension: original_tranid {
    type: string
    link: {
      label: "Netsuite"
      url: "https://{{url_type._value}} {{original_order_id._value}}"}
    sql: ${TABLE}."ORIGINAL_TRANID" ;;
  }

  dimension: qty_fulfilled {
    type: number
    sql: ${TABLE}."QTY_FULFILLED" ;;
  }

  dimension_group: rma_created {
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
    sql: ${TABLE}."RMA_CREATED" ;;
  }

  dimension: rma_order_id {
    type: number
    sql: ${TABLE}."RMA_ORDER_ID" ;;
  }

  dimension: rma_ref_id {
    type: string
    link: {
      label: "Netsuite"
      url: "https://4651144.app.netsuite.com/app/accounting/transactions/rtnauth.nl?id={{rma_order_id._value}}&whence="}
    sql: ${TABLE}."RMA_REF_ID" ;;
  }

  dimension: source {
    type: string
    sql: ${TABLE}."SOURCE" ;;
  }

  dimension: warranty {
    type: string
    sql: ${TABLE}."WARRANTY" ;;
  }

  dimension_group: warranty_created {
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
    sql: ${TABLE}."WARRANTY_CREATED" ;;
  }

  dimension: warranty_order_id {
    type: number
    sql: ${TABLE}."WARRANTY_ORDER_ID" ;;
    hidden:  yes
  }

  dimension: warranty_tranid {
    type: string
    link: {
      label: "Netsuite"
      url: "https://4651144.app.netsuite.com/app/accounting/transactions/salesord.nl?id={{warranty_order_id._value}}&whence="}
    sql: ${TABLE}."WARRANTY_TRANID" ;;
  }



  dimension: url_type {
    hidden: yes
    type: string
    sql:
        CASE
            WHEN ${TABLE}."SOURCE" = 'Netsuite' THEN ('4651144.app.netsuite.com/app/accounting/transactions/salesord.nl?id=')
            WHEN ${TABLE}."SOURCE" = 'Shopify - US' THEN ('purple-ca.myshopify.com/admin/orders/')
            WHEN ${TABLE}."SOURCE" = 'Shopify - CA' THEN ('onpurple.myshopify.com/admin/orders/')
            ELSE Null
        END ;;
  }


  measure: count {
    type: count
    drill_fields: []
  }
}
