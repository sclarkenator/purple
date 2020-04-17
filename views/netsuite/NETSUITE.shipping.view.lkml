view: shipping {
  sql_table_name: "SALES"."SHIPPING"
    ;;

  dimension: pk {
    primary_key: yes
    hidden: yes
    sql: ${order_id}||'-'||${item_id} ;;
  }

  dimension: item_id {
    hidden: yes
    type: number
    sql: ${TABLE}."ITEM_ID" ;;
  }

  dimension: order_id {
    hidden: yes
    type: number
    sql: ${TABLE}."ORDER_ID" ;;
  }

  dimension: fedex {
    hidden: yes
    type: number
    sql: ${TABLE}."FEDEX" ;;
  }

  dimension: mainfreight {
    hidden: yes
    type: number
    sql: ${TABLE}."MAINFREIGHT" ;;
  }

  dimension: other {
    hidden: yes
    type: number
    sql: ${TABLE}."OTHER" ;;
  }

  dimension: xpo {
    hidden: yes
    type: number
    sql: ${TABLE}."XPO" ;;
  }

  dimension: pilot {
    hidden: yes
    type: number
    sql: ${TABLE}."PILOT" ;;
  }

  measure: shipping_total {
    label: "Total Freight"
    description: "This is the total shipping charges incurred across all shipping partners for any individual order/item combo."
    view_label: "zz Margin Calculations"
    value_format: "$#,##0"
    type: sum
    sql: case when ${mainfreight} > 0 then 5.24 else 0 end  + ${TABLE}."SHIPPING_TOTAL" ;;
  }

}
