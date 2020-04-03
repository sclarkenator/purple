view: item_price {
  sql_table_name: ANALYTICS.sales.item_price ;;

  dimension: PK {
    hidden: yes
    type: string
    primary_key: yes
    sql: ${TABLE}.id||'_'||${start_date}||'_'||${end_date}||'_'||${MSRP} ;; }

  dimension: item_id {
    type: number
    hidden:  yes
    sql: ${TABLE}.item_id ;; }

  dimension: sku {
    hidden:  yes
    type: string
    sql: ${TABLE}.sku ;; }

  dimension: MSRP {
    label: "MSRP"
    group_label: "Advanced"
    description: "Full retail price, as listed in Shopify. These are date-specific prices and can change for individual items."
    type: number
    sql: ${TABLE}.price ;; }

  measure: MSRP_1 {
    description: "MSRP of each item"
    label: "MSRP"
    view_label: "Sales Order Line"
    group_label: "Product"
    type: number
    sql: ${TABLE}.price ;;
  }
  dimension: has_had_price_test {
    type: yesno
    hidden:  yes
    sql: ${TABLE}.price_test ;; }

  dimension: start_date {
    type: date
    hidden:  yes
    sql: ${TABLE}.start_date ;; }

  dimension: end_date {
    hidden:  yes
    type: date
    sql: ${TABLE}.end_date ;; }


}
