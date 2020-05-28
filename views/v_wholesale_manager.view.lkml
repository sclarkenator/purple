view: v_wholesale_manager {
  sql_table_name: "SALES"."V_WHOLESALE_MANAGER"
    ;;

  dimension: account_manager {
    label: "Account Manager"
    group_label: "Wholesale"
    #hidden: yes
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
    label: "Sales Manager"
    group_label: "Wholesale"
    #hidden: yes
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
