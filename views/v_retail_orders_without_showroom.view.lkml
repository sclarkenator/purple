view: v_retail_orders_without_showroom {
  sql_table_name: "CUSTOMER_CARE"."V_RETAIL_ORDERS_WITHOUT_SHOWROOM"
    ;;

  dimension: purple_showroom_name {
    type: string
    sql: ${TABLE}."PURPLE_SHOWROOM_NAME" ;;
  }

  dimension: transaction_type {
    type: string
    sql: ${TABLE}."TRANSACTION_TYPE" ;;
  }

  dimension: transaction_number {
    type: string
    sql: ${TABLE}."TRANSACTION_NUMBER" ;;
  }

  dimension: transaction_id {
    type: number
    sql: ${TABLE}."TRANSACTION_ID" ;;
  }

  dimension_group: created {
    type: time
    timeframes: [date, day_of_week, day_of_month, week, week_of_year, month, month_name, quarter, quarter_of_year, year]
    convert_tz: no
    datatype: date
    sql: to_date(${TABLE}."CREATED") ;;
  }

    dimension_group: transaction_date {
      label: "Posted"
      type: time
      timeframes: [date, day_of_week, day_of_month, week, week_of_year, month, month_name, quarter, quarter_of_year, year]
      convert_tz: no
      datatype: date
      sql: ${TABLE}."TRANSACTION_DATE" ;;
    }

}
