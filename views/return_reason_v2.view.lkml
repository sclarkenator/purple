view: return_reason_v2 {
  sql_table_name: "CUSTOMER_CARE"."RETURN_REASON"
    ;;

  dimension: category {
    type: string
    hidden: yes
    sql: ${TABLE}."CATEGORY" ;;
  }

  dimension_group: created {
    hidden: yes
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

  dimension: email {
    hidden: yes
    type: string
    sql: ${TABLE}."EMAIL" ;;
  }

  dimension: order_id {
    type: number
    hidden: yes
    sql: ${TABLE}."ORDER_ID" ;;
  }

  dimension: reason {
    label: "Return Reason"
    description: "Showing each of the resons for the product return."
    type: string
    sql: ${TABLE}."REASON" ;;
  }

  dimension: rma_number {
    type: string
    hidden: yes
    sql: ${TABLE}."RMA_NUMBER" ;;
  }

  dimension: pk {
    primary_key: yes
    hidden: yes
    sql: ${order_id} || ${rma_number} ||${reason} ;;
  }

}
