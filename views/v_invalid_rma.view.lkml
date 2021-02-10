view: v_invalid_rma {
  sql_table_name: "CUSTOMER_CARE"."V_INVALID_RMA"
    ;;

  dimension: created_by {
    type: string
    sql: ${TABLE}."CREATED_BY" ;;
    label: "Created By"
  }

  dimension: assigned_to {
    type: string
    sql: ${TABLE}."ASSIGNED_TO" ;;
    label: "Assigned To"
  }

  dimension: category {
    type: string
    sql: ${TABLE}."CATEGORY" ;;
    label: "Category"
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
    label: "RMA Created"
  }

  dimension_group: customer_receipt {
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
    sql: ${TABLE}."CUSTOMER_RECEIPT" ;;
    label: "Customer Receipt"
  }

  dimension_group: expiry {
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
    sql: ${TABLE}."EXPIRY" ;;
    label: "Expiry"
  }

  dimension: invalid_reason {
    type: string
    sql: ${TABLE}."INVALID_REASON" ;;
    label: "Invalid Reason"
  }

  dimension: item {
    type: string
    sql: ${TABLE}."ITEM" ;;
    label: "Item Description"
  }

  dimension: item_id {
    type: number
    sql: ${TABLE}."ITEM_ID" ;;
    label: "Item ID"
  }

  dimension: order_id {
    type: number
    sql: ${TABLE}."ORDER_ID" ;;
    label: "Order ID"
  }

  dimension: order_number {
    type: string
    sql: ${TABLE}."ORDER_NUMBER" ;;
    label: "Order #"
  }

  dimension: product_line {
    type: string
    sql: ${TABLE}."PRODUCT_LINE" ;;
    label: "Product Line"
  }

  dimension: product_line_id {
    type: number
    sql: ${TABLE}."PRODUCT_LINE_ID" ;;
    label: "Product Line ID"
  }

  dimension: return_reason {
    type: string
    sql: ${TABLE}."RETURN_REASON" ;;
    label: "Return/Warranty Reason"
  }

  dimension: reason_other {
    type: string
    sql: ${TABLE}."REASON_OTHER" ;;
    label: "Other Reason"
  }

  dimension: return_reason_id {
    type: number
    sql: ${TABLE}."RETURN_REASON_ID" ;;
    label: "Reason ID"
  }

  dimension: rma_number {
    type: string
    sql: ${TABLE}."RMA_NUMBER" ;;
    label: "RMA Number"
  }

  dimension: trial_days {
    type: number
    sql: ${TABLE}."TRIAL_DAYS" ;;
    label: "Trial/Warranty Period"
  }

  measure: count {
    type: count
    drill_fields: [created_by]
  }
}
