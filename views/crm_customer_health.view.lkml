view: crm_customer_health {
  sql_table_name: "DATAGRID"."MARKETING"."V_CUSTOMER_HEALTH"
  ;;

  dimension: email {
    type: string
    sql: ${TABLE}."EMAIL" ;;
  }

  dimension: email_join {
    type: string
    hidden: yes
    sql: lower(${TABLE}."EMAIL") ;;
  }

  dimension: subscribed_at_purchase {
    label: "Cordial Subscribe Status (at time of purchase)"
    description: "Corial subscrition status at time of purchaseSource: cordial.cordial_id"
    type: string
    sql: ${TABLE}."SUBSCRIBED_AT_TIME_OF_PURCHASE" ;;
  }

  dimension:  current_subscribe_status{
    label: "Current subscribe status"
    type: string
    sql: ${TABLE}."CURRENT_SUBSCRIBE_STATUS" ;;
  }

  dimension: mattress_units {
    label: "Number of mattress units in order"
    type: number
    sql: ${TABLE}."MATTRESS_UNITS" ;;
  }

  dimension: pillow_units {
    label: "Number of pillow units in order"
    type: number
    sql: ${TABLE}."PILLOW_UNITS" ;;
  }

  dimension: tier_one_flag {
    type: yesno
    #sql: case when ${TABLE}."TIER_ONE_FLAG" = 1 then "Yes" when ${TABLE}."TIER_ONE_FLAG" = 0 then "No" end ;;
    sql: ${TABLE}."TIER_ONE_FLAG" = 1;;
  }

  dimension: tier_one_name {
    type: string
    sql: ${TABLE}."TIER_ONE_NAME" ;;
  }

  dimension_group: order_date {
    label: "Order Date"
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
    sql: ${TABLE}."ORDER_DATE" ;;
  }

  dimension_group: first_order_date {
    label: "First Order Date"
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
    sql: ${TABLE}."FIRST_ORDER_DATE" ;;
  }

  dimension: days_since_first {
    type: number
    label: "Days since first purchase"
    sql: ${TABLE}."DAYS_BETWEEN_FIRST" ;;
  }

  dimension: days_since_last {
    type: number
    label: "Days since last purchase"
    sql: ${TABLE}."DAYS_BETWEEN_LAST" ;;
  }

  dimension: order_value {
    type: number
    label: "Order Value"
    sql: ${TABLE}."ORDER_VALUE" ;;
  }

  dimension: lifetime_orders {
    type: number
    label: "Number of lifetime orders"
    sql: ${TABLE}."ORDERS" ;;
  }

}
