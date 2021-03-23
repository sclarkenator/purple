view: first_order_flag {
   derived_table: {
     sql:
      select
        order_id,
        c.email,
        system,
        case when row_number () over (partition by c.email order by so.created) = 1 then 'NEW' else 'REPEAT' end NEW_FLG
      from sales.sales_order so
      left join analytics_stage.ns.CUSTOMERS c on c.customer_id=so.customer_id
      where (so.channel_id = 1 OR so.channel_id = 5)
      ;;
   }

  dimension: pk {
    description: "Primary key for order lookup"
    primary_key: yes
    hidden:  yes
    type: string
    sql: ${TABLE}.order_id||'-'||${TABLE}.system ;;
  }

  dimension: new_flg {
    label: "     * New/Repeat Customer?"
    view_label: "Customer"
    description: "New or repeat for this email address? Source: looker.calculation"
    type: string
    sql: ${TABLE}.new_Flg ;;
  }
  measure: new_customer {
    view_label: "Customer"
    sql: ${pk};;
    filters: [new_flg: "NEW"]
    type: count_distinct
    value_format: "#,##0"
    hidden: yes
  }

  measure: repeat_customer {
    view_label: "Customer"
    sql: ${pk};;
    filters: [new_flg: "REPEAT"]
    type: count_distinct
    value_format: "#,##0"
    hidden: yes
  }

  dimension: email {
    view_label: "Email Address"
    description: "Email address of customer"
    sql: ${TABLE}.email ;;
    hidden: yes
  }
}
