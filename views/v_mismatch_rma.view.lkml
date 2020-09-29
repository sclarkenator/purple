view: v_mismatch_rma {
  sql_table_name: ANALYTICS.CUSTOMER_CARE.V_MISMATCH_RMA
    ;;

  dimension: category {
    label: "Form"
    type: string
    sql: ${TABLE}."CATEGORY" ;;
  }

  dimension: comments {
    type: string
    sql: ${TABLE}."COMMENTS" ;;
  }

  dimension_group: created {
    label: "TimeStamp"
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
    sql: CAST(${TABLE}."CREATED" AS TIMESTAMP_NTZ) ;;
  }

  dimension: customer {
    label: "Name"
    type: string
    sql: ${TABLE}."CUSTOMER" ;;
  }

  dimension: email {
    label: "Email"
    type: string
    sql: ${TABLE}."EMAIL" ;;
  }

  dimension: item_category {
    type: string
    sql: ${TABLE}."ITEM_CATEGORY" ;;
  }

  dimension: order_number {
    label: "Order"
    type: string
    sql: ${TABLE}."ORDER_NUMBER" ;;
  }

  dimension: phone {
    label: "Phone"
    type: string
    sql: ${TABLE}."PHONE" ;;
  }

  dimension: policy {
    type: string
    sql: ${TABLE}."POLICY" ;;
  }

  dimension: reasons {
    type: string
    sql: ${TABLE}."REASONS" ;;
  }

  dimension: return_option {
    type: string
    sql: ${TABLE}."RETURN_OPTION" ;;
  }

  dimension: rma_number {
    label: "RMAnum"
    type: string
    sql: ${TABLE}."RMA_NUMBER" ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
