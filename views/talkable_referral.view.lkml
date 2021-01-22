view: talkable_referral {
  sql_table_name: "MARKETING"."TALKABLE_REFERRAL"
    ;;

  dimension: coupon_code {
    type: string
    sql: ${TABLE}."COUPON_CODE" ;;
  }

   dimension: order_amount {
    type: number
    sql: ${TABLE}."ORDER_AMOUNT" ;;
  }

  dimension_group: order_created {
    type: time
    timeframes: [raw,time,date,week,month,quarter,year]
    sql: CAST(${TABLE}."ORDER_CREATED" AS TIMESTAMP_NTZ) ;;
  }

  dimension: order_number {
    type: string
    primary_key: yes
    sql: ${TABLE}."ORDER_NUMBER" ;;
  }

  dimension: referred_email {
    type: string
    sql: ${TABLE}."REFERRED_EMAIL" ;;
  }

  dimension: referrer_email {
    type: string
    sql: ${TABLE}."REFERRER_EMAIL" ;;
  }

  dimension: type {
    type: string
    sql: ${TABLE}."TYPE" ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }

  measure: total_order_amount {
    type: sum
    sql: ${TABLE}."ORDER_AMOUNT" ;;
    drill_fields: [referred_email,referrer_email,order_number,order_created_date, sales_order_base.total_units_raw, sales_order_line_base.gross_Amt, item.category_name, item.line_raw, item.model_raw, item.product_description]
  }
}
