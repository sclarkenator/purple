view: paypal_sync {
  # Or, you could make this view a derived table, like this:
  derived_table: {
    sql:
    select
      convert_timezone('America/Denver',p.posted) as posted,
      p.invoice_id,
      p.account_id,
      p.transaction_id,
      p.reference_id,
      p.currency,
      p.amount,
      p.fee,
      o.name,
      o.id,
      p.type
    from analytics.accounting.paypal_sync p
      left join analytics_stage.shopify_us_ft.transaction s on p.transaction_id = s.authorization
      left join analytics_stage.shopify_us_ft."ORDER" o on s.order_id = o.id
    where posted >= '2020-09-01'
      ;;
  }

  dimension_group: created {
    description:  "Source: paypal.paypal_sync"
    type: time
    timeframes: [raw, hour_of_day, date, day_of_week, day_of_week_index, day_of_month, day_of_year, week, week_of_year, month, month_num, month_name, quarter, quarter_of_year, year]
    convert_tz: no
    datatype: timestamp
    sql: to_timestamp_ntz(${TABLE}.posted) ;;
  }

  dimension: invoice_id {
    description: "Source: paypal.paypal_sync"
    type: string
    sql: ${TABLE}.invoice_id ;;
  }

  dimension: account_id {
    description: "Source: paypal.paypal_sync"
    type: string
    sql: ${TABLE}.account_id ;;
  }

  dimension: transaction_id {
    description: "Source: paypal.paypal_sync"
    type: string
    sql: ${TABLE}.transaction_id ;;
  }

  dimension: reference_id {
    description: "Source: paypal.paypal_sync"
    type: string
    sql: ${TABLE}.reference_id ;;
  }

  dimension: currency {
    description: "Source: paypal.paypal_sync"
    type: string
    sql: ${TABLE}.currency ;;
  }

  dimension: name {
    description: "Source: shopify.order"
    type: string
    sql: ${TABLE}.name ;;
  }

  dimension: id {
    description: "Source: shopify.order"
    type: string
    sql: ${TABLE}.id ;;
  }

  dimension: type {
    description: "Source: paypal.paypal_sync"
    type: string
    sql: ${TABLE}.type ;;
  }

  measure: amount {
    type: sum
    value_format: "$#,##0.00"
    sql:  ${TABLE}.amount ;;
  }

  measure: fee {
    type: sum
    value_format: "$#,##0.00"
    sql:  ${TABLE}.fee ;;
  }

}
