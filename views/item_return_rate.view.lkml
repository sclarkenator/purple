# If necessary, uncomment the line below to include explore_source.

# this messy table brought to you by Scott Clark. Don't ask me to try and explain it, because I won't remember...

view: item_return_rate {
  sql_table_name: analytics.sales.item_return_rate ;;

  measure: adj_return_amt {
    label: " 7 - $ Returns"
    view_label: "zz Margin Calculations"
    description: "Actual returns (adjusted for GWP) when fulfilled 140+ days ago, modeled value using most recent complete 90-day window"
    hidden: no
    type: sum
    value_format: "$#,##0"
    sql: ${TABLE}.adj_return_amt ;;  }

  measure: adj_return_clawback {
    label: " 7a - Return clawbacks"
    view_label: "zz Margin Calculations"
    description: "Contra-sales for GWP item when main item returned. Based in adjusted gross sales dollars. Actuals when fulfilled 140+ days ago, modeled value using most recent complete 90-day window"
    hidden: no
    type:sum
    value_format: "$#,##0"
    sql: ${TABLE}.adj_ret_clawback ;;  }

  dimension: return_rate_dim {
    hidden: yes
    type: number
    sql: ${TABLE}.adj_ret_rate ;;  }

  dimension: sku_id {
    label: "Product SKU ID"
    hidden: yes
    description: "Internal Netsuite ID"
    type: number
    sql:  ${TABLE}.sku_id ;;  }

  dimension: pk {
    label: "Primary key"
    hidden: yes
    primary_key: yes
    type: string
    sql:  ${TABLE}.order_id||'-'||${TABLE}.channel||'-'||${TABLE}.sku_id||'-'||${TABLE}.pk_row;;  }

  dimension: order_id {
    label: "order_ID"
    hidden: yes
    description: "This channel is just for joining item returns to sales order line"
    type: string
    sql:  ${TABLE}.order_id ;;  }

  dimension: channel {
    label: "channel for join"
    hidden: yes
    description: "This channel is just for joining item returns to sales order line"
    type: string
    sql:  ${TABLE}.channel ;;  }

}
