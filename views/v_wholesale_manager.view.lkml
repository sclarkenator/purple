view: v_wholesale_manager {
  sql_table_name: "SALES"."V_WHOLESALE_MANAGER"
    ;;

  dimension: account_manager {
    #hidden: yes
    group_label: "  Wholesale"
    label: "Account Manager"
    description: "Wholesale - Taking the account manager from the customer account.
      Source:netsuite.v_wholesale_manager"
    type: string
    sql:  ${TABLE}."ACCOUNT_MANAGER";;
  }

  dimension: customer_id {
    hidden: yes
    type: number
    sql: ${TABLE}."CUSTOMER_ID" ;;
  }

  dimension: order_id {
    primary_key: yes
    hidden: yes
    type: number
    sql: ${TABLE}."ORDER_ID" ;;
  }

  dimension: sales_manager {
    #hidden: yes
    group_label: "  Wholesale"
    label: "Sales Manager"
    description: "Wholesale - Taking the sales manager from the customer account.
      Source:netsuite.v_wholesale_manager"
    type: string
    sql: ${TABLE}."SALES_MANAGER";;
  }

  dimension: system {
    hidden: yes
    type: string
    sql: ${TABLE}."SYSTEM" ;;
  }

  measure: count {
    hidden: yes
    type: count
    drill_fields: []
  }
}
