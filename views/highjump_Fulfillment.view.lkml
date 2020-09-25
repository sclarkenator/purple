view: highjump_fulfillment {
  sql_table_name: analytics.highjump.highjump_fulfillment ;;

  dimension:  row_id {
    group_label: "Highjump"
    label: "primary key"
    type: string
    hidden: yes
    primary_key: yes
    sql: ${TABLE}.row_id ;;
  }

  dimension:  transaction_number {
    group_label: "Highjump"
    label: "NetSuite Tran ID"
    description: "NetSuite Transaction ID. Source: highjump.highjump_fulfillment"
    type: string
    hidden: yes
    sql: ${TABLE}.transaction_number ;;
  }

  dimension: sku {
    group_label: "Highjump"
    label: "SKU ID"
    description: "Product SKU ID. Source: highjump.highjump_fulfillment"
    type: string
    hidden: yes
    sql: ${TABLE}.sku_id ;;
  }

  dimension:  source_order_number {
    group_label: "Highjump"
    label: "Related Tran ID"
    description: "Shopify Order Number. Source: highjump.highjump_fulfillment"
    type: string
    hidden: yes
    sql: ${TABLE}.source_order_number ;;
  }

  dimension:  required {
    group_label: "Highjump"
    label: "Order Date"
    description: "Date the item was ordered. Source: highjump.highjump_fulfillment"
    type: date
    hidden: yes
    sql: ${TABLE}.required ;;
  }

  dimension:  shipped {
    group_label: "Highjump"
    label: "Ship Date"
    description: "Time the Order was shipped. Source: highjump.highjump_fulfillment"
    type: date
    hidden: no
    sql: ${TABLE}.shipped ;;
  }

  dimension:  tracking_number {
    group_label: "Highjump"
    label: "Tracking Number"
    description: "Item's Shipping Tracking Number. Source: highjump.highjump_fulfillment"
    type: string
    hidden:  no
    sql: ${TABLE}.tracking_number ;;
  }

  dimension: quantity {
    group_label: "Highjump"
    label: "Quantity"
    description: "Number of Units. Source: highjump.highjump_fulfillment"
    type:  number
    hidden: no
    sql: ${TABLE}.quantity ;;
  }
}
