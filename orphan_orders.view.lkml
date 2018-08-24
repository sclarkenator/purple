view: orphan_orders {
    derived_table: {
      sql:
          select so.name
          from analytics_stage.shopify_us_ft."ORDER" so
          where to_Date(convert_timezone('UTC','America/Denver',created_at::timestamp_ntz)) > '2018-07-01'
          and so.cancelled_at is not null
          and to_Date(convert_timezone('UTC','America/Denver',created_at::timestamp_ntz)) < to_date(current_date)
          minus
          select o.related_tranid
          from sales_order o
          where o.created > '2018-07-01'
          and o.channel_id = 1
          and o.source = 'Shopify - US'
          and o.created < to_date(current_date)  ;;
    }

    dimension: RELATED_TRANID {
      label: "Order ID"
      description:  "This is the 'name' field in Shopify, related_tranid in Netsuite "
      type:  string
      sql: ${TABLE}.name ;;
    }

}
