view: orphan_orders {
    derived_table: {
      sql:
            select s.name
                    ,o.id
                    ,o.financial_status
                    ,o.total_price
            from analytics_stage.shopify_us_ft."ORDER" o
            join
              (select so.name
              from analytics_stage.shopify_us_ft."ORDER" so
              where to_Date(convert_timezone('UTC','America/Denver',created_at)) > '2018-07-01'
              and so.cancelled_at is not null
              and to_Date(convert_timezone('UTC','America/Denver',created_at)) < to_date(current_date)
              minus
              select o.related_tranid
              from sales_order o
              where o.created > '2018-08-01'
              and o.channel_id = 1
              and o.source = 'Shopify - US'
              and o.created < to_date(current_date)) s
            on s.name = o.name  ;;
    }

    dimension: RELATED_TRANID {
      label: "Order ID"
      description:  "This is the 'name' field in Shopify, related_tranid in Netsuite "
      type:  string
      sql: ${TABLE}.name ;;
    }

  dimension: ORDER_ID {
    label: "Order ID"
    description:  "This is the 'ID' field in Shopify"
    type:  string
    sql: ${TABLE}.id ;;
  }

  dimension: status {
    label: "Status"
    description:  "This is the financial status of the order"
    type:  string
    sql: ${TABLE}.financial_status ;;
  }

  measure: order_size {
    label: "Order size"
    description: "Total order size in USD"
    type:  sum
    sql: ${TABLE}.total_price ;;
  }
}
