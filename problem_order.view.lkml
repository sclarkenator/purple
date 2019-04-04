view: problem_order {
  derived_table: {
    sql:
      select
        created, customer, order_id, order_name, reason, financial_status,
        case
          when order_name ilike '%ca%' then 'https://purple-ca.myshopify.com/admin/orders/' || order_id::varchar(100)
          else 'https://onpurple.myshopify.com/admin/orders/' || order_id::varchar(100)
        end as hyper_link
      from analytics.customer_care.problem_order;;
  }

  dimension_group: created {
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
    sql: ${TABLE}."CREATED" ;;
  }

  dimension: hyper_link {
    type: string
    sql: ${TABLE}."HYPER_LINK" ;;
    hidden: yes
  }

  dimension: order_id {
    type: string
    sql: ${TABLE}."ORDER_ID" ;;
    html: <a href = "{{hyper_link}}" target="_blank"> {{value}} </a> ;;
  }

  dimension: order_name {
    type: string
    sql: ${TABLE}."ORDER_NAME" ;;
    html: <a href = "{{hyper_link}}" target="_blank"> {{value}} </a> ;;
  }

  dimension: reason {
    type: string
    sql: ${TABLE}."REASON" ;;
  }

  dimension: customer {
    type: string
    sql: ${TABLE}."CUSTOMER" ;;
  }

  dimension: financial_status {
    type: string
    sql: ${TABLE}."FINANCIAL_STATUS" ;;
  }

}
