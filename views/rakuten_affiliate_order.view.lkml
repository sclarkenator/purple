view: affiliate_sales_order {
  sql_table_name: "MARKETING"."RAKUTEN_AFFILIATE_ORDER"   ;;

    dimension: order_id {
    primary_key: yes
    type: string
    sql: '#'||${TABLE}."ORDER_ID" ;;
    hidden:  yes
  }

  dimension: affiliate_name {
    type: string
    view_label: "Sales Order"
    group_label: " Advanced"
    description: "Source: rakuten.rakuten_affliate_order"
    sql: ${TABLE}.publisher_name ;;
  }

  dimension: order_id_flag {
    view_label: "Sales Order"
    label: "     * Is Affiliate Order"
    description: "Source: rakuten.rakuten_affliate_order"
    type: yesno
    sql: ${order_id} is not NULL ;;
  }

  dimension: publisher_id {
    hidden: yes
    type: number
    sql: ${TABLE}."PUBLISHER_ID" ;;
  }

  dimension: sales {
    hidden: yes
    type: number
    sql: case when ${TABLE}."SALES" < 1 then 1 else ${TABLE}.sales end ;;
  }

  dimension: total_commission {
    hidden: yes
    type: number
    sql: nvl(${TABLE}."TOTAL_COMMISSION",0) ;;
  }

  dimension: comm_rate {
    hidden: yes
    view_label: "zz Margin Calculations"
    type: number
    sql: ${total_commission}/${sales}  ;;
  }

}
