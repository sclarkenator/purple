view: v_chat_sales {
   sql_table_name: analytics.customer_care.v_chat_sales ;;

   dimension: order_id {
     type: string
     hidden: yes
     group_label: "Advanced - Chats"
     sql: ${TABLE}.order_id ;;
   }

  dimension: system {
    group_label: "Advanced - Chats"
    description: "System the order was placed in"
    type: string
    hidden: yes
    sql: ${TABLE}.system ;;
  }

  dimension: chat_id {
    type: string
    hidden: yes
    group_label: "Advanced - Chats"
    sql: ${TABLE}.chat_id ;;
  }

  dimension: incontact_id {
    group_label: "Advanced - Chats"
    description: "Shopify order ID"
    type: string
    hidden: yes
    sql: ${TABLE}.incontact_id ;;
  }

}
