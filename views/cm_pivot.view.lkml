view: cm_pivot {
  sql_table_name: SALES.CM_PIVOT ;;

  dimension: contribution_pk {
    type: string
    primary_key:  yes
    hidden:  yes
    sql: NVL(${TABLE}.item_id,0)||'-'|| NVL(${TABLE}.order_id,0)||'-'||${TABLE}.system||'-'||${TABLE}.category ;;
  }

  dimension: item_id {
    hidden: yes
    type: string
    sql: ${TABLE}."ITEM_ID" ;;
  }

  dimension: order_id {
    type: string
    hidden: yes
    sql: ${TABLE}."ORDER_ID" ;;
  }

  dimension: system {
    type: string
    hidden: yes
    sql: ${TABLE}."SYSTEM" ;;
  }

  measure: amount {
    hidden:  yes
    label: "$ amount (old)"
    description: "Dollar amount of each category"
    value_format: "#,##0"
    type: sum
    sql: ${TABLE}."AMOUNT" ;;
  }

  dimension: category {
    hidden: yes
    label: "CM components (old)"
    description: "List of CM components"
    type: string
    case: {
      when: { sql: lower(${TABLE}."CATEGORY") = 'gross_sales' ;; label: "gross sales" }
      when: { sql: lower(${TABLE}."CATEGORY") = 'cancelled_amt' ;; label: "cancellations" }
      when: { sql: lower(${TABLE}."CATEGORY") = 'return_amt' ;; label: "returns" }
      when: { sql: lower(${TABLE}."CATEGORY") = 'retro_discount_amt' ;; label: "retro discounts" }
      when: { sql: lower(${TABLE}."CATEGORY") = 'cogs' ;; label: "cogs" }
      when: { sql: lower(${TABLE}."CATEGORY") = 'labor' ;; label: "direct labor" }
      when: { sql: lower(${TABLE}."CATEGORY") = 'freight_in' ;; label: "freight-in" }
      when: { sql: lower(${TABLE}."CATEGORY") = 'warranty' ;; label: "warranty" }
      when: { sql: lower(${TABLE}."CATEGORY") = 'merchant_fees' ;; label: "merchant fees" }
      when: { sql: lower(${TABLE}."CATEGORY") = 'freight' ;; label: "shipping" }
      when: { sql: lower(${TABLE}."CATEGORY") = 'affiliate_fees' ;; label: "affiliate fees" }
      else: "other"
      }
  }
}
