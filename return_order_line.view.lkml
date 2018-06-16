view: return_order_line {
  sql_table_name: SALES.RETURN_ORDER_LINE ;;

  dimension: item_order{
    primary_key:  yes
    hidden:  yes
    sql: ${TABLE}.item_id||'-'||${TABLE}.order_id ;;
    }

  measure: days_between {
    type: average
    sql: datediff(day,${sales_order_line.created_date},${TABLE}.closed_Date)    ;;
  }

  measure: units_returned {
    type: sum
    sql: ${TABLE}.return_qty ;;
  }

  measure: net_amt_returned {
    type: sum
    sql: ${TABLE}.net_amt ;;
  }

  dimension: allow_discount_removal {
    type: string
    sql: ${TABLE}.ALLOW_DISCOUNT_REMOVAL ;;
  }

  dimension: auto_invoice_type_id {
    hidden: yes
    type: number
    sql: ${TABLE}.AUTO_INVOICE_TYPE_ID ;;
  }

  dimension_group: closed {
    label: "Return"
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
    sql: ${TABLE}.CLOSED ;;
  }

  dimension: cost_estimate_type {
    hidden: yes
    type: string
    sql: ${TABLE}.COST_ESTIMATE_TYPE ;;
  }

  dimension: created_ts {
    hidden: yes
    type: string
    sql: ${TABLE}.CREATED_TS ;;
  }

  dimension: department_id {
    hidden: yes
    type: number
    sql: ${TABLE}.DEPARTMENT_ID ;;
  }

  dimension: insert_ts {
    hidden: yes
    type: string
    sql: ${TABLE}.INSERT_TS ;;
  }

  dimension: item_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.ITEM_ID ;;
  }

  dimension: item_received {
    type: string
    sql: ${TABLE}.ITEM_RECEIVED ;;
  }

  dimension: line_shipping_method_id {
    hidden: yes
    type: number
    sql: ${TABLE}.LINE_SHIPPING_METHOD_ID ;;
  }

  dimension: location_id {
    type: number
    sql: ${TABLE}.LOCATION_ID ;;
  }

  dimension: memo {
    hidden: yes
    type: string
    sql: ${TABLE}.MEMO ;;
  }

  dimension: net_amt {
    type: number
    sql: ${TABLE}.NET_AMT ;;
  }

  dimension: order_id {
    hidden: yes
    type: number
    sql: ${TABLE}.ORDER_ID ;;
  }

  dimension: price_type_id {
    hidden: yes
    type: number
    sql: ${TABLE}.PRICE_TYPE_ID ;;
  }

  dimension: product_line_id {
    hidden: yes
    type: number
    # hidden: yes
    sql: ${TABLE}.PRODUCT_LINE_ID ;;
  }

  dimension: quantity_received_in_shipment {
    type: number
    sql: ${TABLE}.QUANTITY_RECEIVED_IN_SHIPMENT ;;
  }

  dimension: return_order_id {
    hidden: yes
    type: number
    sql: ${TABLE}.RETURN_ORDER_ID ;;
  }

  dimension: return_qty {
    type: number
    sql: ${TABLE}.RETURN_QTY ;;
  }

  dimension: revenue_item {
    label: "Is return amount tied to a revenue item?"
    type: yesno
    sql: ${TABLE}.REVENUE_ITEM ;;
  }

  dimension_group: shipment_received {
    hidden: yes
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
    sql: ${TABLE}.SHIPMENT_RECEIVED ;;
  }

  dimension: transaction_discount_line {
    hidden: yes
    type: string
    sql: ${TABLE}.TRANSACTION_DISCOUNT_LINE ;;
  }

  dimension: update_ts {
    hidden: yes
    type: string
    sql: ${TABLE}.UPDATE_TS ;;
  }



  # ----- Sets of fields for drilling ------
  set: detail {
    fields: [
      return_order.return_order_id,
      item.item_id,
      item.model_name,
      item.category_name,
      item.sub_category_name,
      item.product_line_name,
      product_line.product_line_id
    ]
  }
}
