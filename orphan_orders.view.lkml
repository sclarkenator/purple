#-------------------------------------------------------------------
# Owner - Scott Clark
#-------------------------------------------------------------------

view: orphan_orders {
    sql_table_name: customer_care.shopify_orphan_orders;;

  dimension: RELATED_TRANID {
    label: "Order ID (netsuite)"
    description:  "This is the 'name' field in Shopify, related_tranid in Netsuite "
    type:  string
    sql: ${TABLE}.name ;; }

  dimension: ORDER_ID {
    label: "Order ID (shopify)"
    description:  "This is the 'ID' field in Shopify"
    type:  string
    primary_key: yes
    html: <a href = "https://onpurple.myshopify.com/admin/orders/{{value}}"> {{value}} </a> ;;
    sql: ${TABLE}.id ;; }

  dimension: status {
    label: "Status"
    description:  "This is the financial status of the order"
    type:  string
    sql: ${TABLE}.financial_status ;; }

  dimension_group: order_date {
    label: "Order Date"
    description: "Date order was placed in shopify (Mountain time zone)"
    type:  time
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
    sql: ${TABLE}.order_date ;; }

  measure: order_size {
    label: "Total Order Size ($)"
    description: "Total order size in USD"
    type:  sum
    sql: ${TABLE}.total_price ;; }

}
