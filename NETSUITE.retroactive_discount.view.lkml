view: retroactive_discount {
  sql_table_name: SALES.RETROACTIVE_DISCOUNT ;;

  measure: total_retro_discounts {
    label: "Total Discounts (retro)"
    description:  "Total of all applied retroactive discounts"
    type:  sum
    sql:  ${TABLE}.amount;; }

  dimension: item_order_refund{
    primary_key:  yes
    hidden:  yes
    sql: ${TABLE}.item_id||'-'||${TABLE}.order_id||'-'||${TABLE}.system ;; }

  dimension: amount {
    label:  "Discount Amount"
    description: "Discount amount applied at item-level"
    type: number
    sql: ${TABLE}.AMOUNT ;; }

  dimension: discount_amt_bucket {
    label: "Discount buckets"
    description: "Bucketing amount by 50, 100, 150, 200, 350, 500, 1000"
    type:  tier
    tiers: [50,100,150,200,350,500,1000]
    style: integer
    sql: ${TABLE}.AMOUNT ;; }

  dimension: yesterday_flag {
    hidden: yes
    label:  "Yesterday-discount"
    #view_label:  "x - report filters"
    type: yesno
    sql: ${created_date} = dateadd(d,-1,current_date) ;; }

  dimension_group: created {
    label:  "Discount Applied"
    description:  "Date discount was applied"
    type: time
    timeframes: [raw, date, day_of_week, day_of_month, week, week_of_year, month, month_name, quarter, quarter_of_year, year]
    convert_tz: no
    datatype: timestamp
    sql: ${TABLE}.CREATED ;; }

  dimension: discount_code_id {
    hidden: yes
    description: "Type of discount applied"
    type: number
    sql: ${TABLE}.DISCOUNT_CODE_ID ;; }

  dimension: etail_order_line_id {
    hidden: yes
    type: number
    sql: ${TABLE}.ETAIL_ORDER_LINE_ID ;; }

  dimension: insert_mst {
    hidden: yes
    type: string
    sql: ${TABLE}.INSERT_MST ;; }

  dimension: order_id {
    hidden: yes
    type: number
    sql: ${TABLE}.ORDER_ID ;; }

  dimension: product_line_id {
    hidden: yes
    type: number
    # hidden: yes
    sql: ${TABLE}.PRODUCT_LINE_ID ;; }

  dimension: refund_link_id {
    hidden: yes
    type: number
    sql: ${TABLE}.REFUND_LINK_ID ;; }

  dimension: refunded_amount {
    hidden: yes
    description: "Amount refunded, including tax"
    type: number
    sql: ${TABLE}.REFUNDED_AMOUNT ;; }

  dimension: retroactive_discount_line_id {
    hidden: yes
    type: number
    sql: ${TABLE}.RETROACTIVE_DISCOUNT_LINE_ID ;; }

  dimension: item_id {
    hidden: yes
    type: number
    sql: ${TABLE}.item_ID ;; }

  dimension: system {
    hidden: yes
    type: string
    sql: ${TABLE}.SYSTEM ;; }

  dimension: update_mst {
    hidden: yes
    type: string
    sql: ${TABLE}.UPDATE_MST ;; }

  measure: count {
    label: "Count of Discounts Applied"
    description: "Disintct Discounts Applied"
    type: count
    drill_fields: [product_line.product_line_id, discount_code.discount_code_id] }

}
