view: highjump_shiphist {
  sql_table_name: ANALYTICS"."HIGHJUMP"."SHIPHIST ;;

  dimension:  transaction_number {
    label: "Transaction Number"
    description: "Shopify ID"
    type: number
    hidden:  no
    sql: ${TABLE}.transaction_number ;;
  }

  dimension:  order_number {
    label: "Order Number"
    description: "Netsuite Order Number"
    type: number
    hidden:  no
    sql: ${TABLE}.order_number ;;
  }

  dimension:  ordered {
    label: "Order Date"
    description: "Date the item was ordered"
    type: date
    hidden:  no
    sql: ${TABLE}.ordered ;;
  }

  dimension:  shipped {
    label: "Ship Date"
    description: "Time the Order was shipped"
    type: date_time
    hidden:  no
    sql: ${TABLE}.shipped ;;
  }

  dimension:  is_shipped {
    label: "Is Shipped"
    description: "T/F if shipped"
    type: yesno
    hidden:  no
    sql: ${TABLE}.is_shipped = "TRUE" ;;
  }

  dimension:  carrier {
    label: "Carrier"
    description: "Carrier reported on Highjump"
    type: string
    hidden:  no
    sql: ${TABLE}.carrier ;;
  }
}
