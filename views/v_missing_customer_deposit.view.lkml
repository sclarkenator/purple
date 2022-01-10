# The name of this view in Looker is "V Missing Customer Deposit"
view: v_missing_customer_deposit {
  # The sql_table_name parameter indicates the underlying database table
  # to be used for all fields in this view.
  sql_table_name: "CUSTOMER_CARE"."V_MISSING_CUSTOMER_DEPOSIT"
    ;;
  # No primary key is defined for this view. In order to join this view in an Explore,
  # define primary_key: yes on a dimension that has no repeated values.

  # Dates and timestamps can be represented in Looker using a dimension group of type: time.
  # Looker converts dates and timestamps to the specified timeframes within the dimension group.

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

  # Here's what a typical dimension looks like in LookML.
  # A dimension is a groupable field that can be used to filter query results.
  # This dimension will be called "Customer Balance" in Explore.

  dimension: customer_balance {
    type: number
    sql: ${TABLE}."CUSTOMER_BALANCE" ;;
  }

  # A measure is a field that uses a SQL aggregate function. Here are defined sum and average
  # measures for this dimension, but you can also add measures of many different aggregates.
  # Click on the type parameter to see all the options in the Quick Help panel on the right.

  measure: total_customer_balance {
    type: sum
    sql: ${customer_balance} ;;
  }

  dimension: etail_order_name {
    type: string
    sql: ${TABLE}."ETAIL_ORDER_NAME" ;;
  }

  dimension: order_amount {
    type: string
    sql: ${TABLE}."ORDER_AMOUNT" ;;
  }

  measure: total_order_amount {
    type: sum
    sql: ${order_amount} ;;
  }

  dimension: order_id {
    type: number
    sql: ${TABLE}."ORDER_ID" ;;
  }

  dimension: source {
    type: string
    sql: ${TABLE}."SOURCE" ;;
  }

  dimension: status {
    type: string
    sql: ${TABLE}."STATUS" ;;
  }

  dimension: transaction_number {
    type: string
    sql: ${TABLE}."TRANSACTION_NUMBER" ;;
  }

  measure: count {
    type: count
    drill_fields: [etail_order_name]
  }
}
