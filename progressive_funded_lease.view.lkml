view: progressive_funded_lease {
  sql_table_name: FINANCE.progressive_funded_lease ;;

  dimension: lease_id {
    primary_key: yes
    type: number
    sql: ${TABLE}.LEASE_ID ;;
  }

  dimension: first_name {
    type: string
    sql: ${TABLE}.first_name ;;
  }

  dimension: last_name {
    type: string
    sql: ${TABLE}.last_name ;;
  }


  dimension: invoice_number {
    type: string
    sql: ${TABLE}.invoice_number ;;
  }

  dimension: term_dim {
    type: string
    sql: ${TABLE}.term ;;
  }

  dimension: paid {
    type: date
    sql: ${TABLE}.paid ;;
  }

  dimension: delivery {
    type: date
    sql: ${TABLE}.delivery ;;
  }


  measure: count {
    type: count
    drill_fields: []
  }

  measure: invoice_amount {
    #label:  "?"
    #description:  "?"
    type: sum
    sql:  ${TABLE}.invoice_amount ;;
  }

  measure: initial_payment {
    #label:  "?"
    #description:  "?"
    type: sum
    sql:  ${TABLE}.initial_payment ;;
  }

  measure: initial_payment_tax {
    #label:  "?"
    #description:  "?"
    type: sum
    sql:  ${TABLE}.initial_payment_tax ;;
  }

  measure: discount {
    #label:  "?"
    #description:  "?"
    type: sum
    sql:  ${TABLE}.discount ;;
  }

  measure: net_funded {
    #label:  "?"
    #description:  "?"
    type: sum
    sql:  ${TABLE}.net_funded ;;
  }

  measure: term {
    #label:  "?"
    #description:  "?"
    type: sum
    sql:  ${TABLE}.term ;;
  }

}
