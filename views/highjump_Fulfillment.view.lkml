view: highjump_fulfillment {
  sql_table_name: analytics.highjump.highjump_fulfillment ;;

  dimension:  row_id {
    label: "primary key"
    type: string
    hidden:  yes
    primary_key: yes
    sql: ${TABLE}.row_id ;;
  }

  dimension:  transaction_number {
    label: "NetSuite Tran ID"
    description: "NetSuite Transaction ID. Source: highjump.highjump_fulfillment"
    type: string
    hidden:  no
    sql: ${TABLE}.transaction_number ;;
  }

  dimension: sku {
    label: "SKU ID"
    description: "Product SKU ID. Source: highjump.highjump_fulfillment"
    type: string
    hidden: no
    sql: ${TABLE}.sku_id ;;
  }

  dimension:  source_order_number {
    label: "Related Tran ID"
    description: "Shopify Order Number. Source: highjump.highjump_fulfillment"
    type: string
    hidden:  no
    sql: ${TABLE}.source_order_number ;;
  }

  dimension:  required {
    label: "Order Date"
    description: "Date the item was ordered. Source: highjump.highjump_fulfillment"
    type: date
    hidden:  no
    sql: ${TABLE}.required ;;
  }

  dimension:  shipped {
    label: "Ship Date"
    description: "Time the Order was shipped. Source: highjump.highjump_fulfillment"
    type: date
    hidden:  no
    sql: ${TABLE}.shipped ;;
  }

  dimension:  tracking_number {
    label: "Tracking Number"
    description: "Item's Shipping Tracking Number. Source: highjump.highjump_fulfillment"
    type: string
    hidden:  no
    sql: ${TABLE}.tracking_number ;;
  }

  dimension: quantity {
    label: "Quantity"
    description: "Number of Units. Source: highjump.highjump_fulfillment"
    type:  number
    hidden:  no
    sql: ${TABLE}.quantity ;;
  }

}
