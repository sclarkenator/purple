include: "/views/_period_comparison.view.lkml"
view: email_crm {
  derived_table: {
    sql:  select distinct d.email,
                          d.order_id,
                          d.order_date,
                          c.subscribe_status,
                          c.action,
                          c.sent_date,
                          d.gross_amt as order_amt,
                          d.coupon_code,
                          sol.item_id,
                          case when d.mattress_count is null then 0 else mattress_count end as mattress_count,
                          case when d.premier_count is null then 0 else premier_count end as premier_count,
                          case when d.order_num = 1 then 'New' else 'Repeat' end as newcustflag,
                          case when c.email is null then 'No' else 'Yes' end as emailPurchase
          from datagrid.marketing.V_EMAILCRM_SALES_DETAIL as d
          left outer join datagrid.marketing.V_EMAILCRM_CUST_DETAIL as c
            on d.order_id = c.order_id
          left outer join analytics.sales.sales_order_line as sol
            on sol.order_id = d.order_id
          ;;
  }

  extends: [_period_comparison]

  dimension_group: event {
    hidden: yes
    type: time
    timeframes: [ raw,time,time_of_day,date,day_of_week,day_of_week_index,day_of_month,day_of_year,
      week,month,month_num,quarter,quarter_of_year,year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.order_date ;;
  }

  dimension: order_date {
    label: "Order Date"
    type: date
    sql: ${TABLE}.order_date ;;
  }

  dimension: order_id {
    label: "OrderID"
    type: string
    sql: ${TABLE}.order_id ;;
  }

  dimension: item_id {
    hidden: yes
    type: string
    sql: ${TABLE}.item_id ;;
  }

  dimension: email {
    label: "Email"
    #view_label: "Customer"
    type:  string
    sql: ${TABLE}.email ;;
  }

  dimension: email_purchase {
    label: "Email Purchase"
    type: yesno
    sql: case when ${TABLE}.emailPurchase = "Yes" then 1 else 0 end ;;
  }

  dimension: subscribe_status {
    label: "Cordial Subscribe Status"
    #view_label: "Customer"
    type: string
    sql: ${TABLE}.subscribe_status ;;
  }

  dimension: cordial_send_date {
    label: "Cordial Activity Date"
    type: date
    sql: ${TABLE}.sent_date ;;
  }

  dimension: new_flag {
    label: "New/Repeat Customer"
    #view_label: "Customer"
    type:  string
    sql:${TABLE}.newcustflag ;;
  }

  dimension: order_amt {
    label: "Order Amt"
    type: number
    value_format: "$#,##0"
    sql: ${TABLE}.order_amt ;;
  }

  dimension: contains_mattress {
    label: "Order contains mattress?"
    type: yesno
    sql: case when ${TABLE}.mattress_count > 0 then 1 else 0 end  ;;
  }

  dimension: coupon_code {
    label: "Coupon Code"
    type: string
    sql: ${TABLE}.coupon_code ;;
  }

  dimension: cordial_action {
    label: "Cordial Action"
    type: string
    sql: ${TABLE}.action ;;
  }

  dimension: mattress_count {
    label: "# of Mattresses in order"
    type: number
    sql: ${TABLE}.mattress_count ;;
  }

  dimension: premier_mattress_count {
    label: "# of Premier Mattresses in order"
    type: number
    sql: ${TABLE}.premier_count ;;
  }

  dimension: category {
    label: "Category name"
    type: string
    sql:  ;;
  }


  measure: gross_amt {
    label: "Gross Amount $"
    value_format: "$#,##0"
    type: sum
    sql: ${TABLE}.order_amt;;
  }

  measure: amov {
    label: "AMOV"
    description: "Average Mattress Order Value (mattress orders: gross sales/orders)"
    value_format: "$#,##0"
    type: number
    sql: sum(${TABLE}.order_amt *
         case when ${mattress_count} > 0 then 1 else 0 end)
       / sum(case when ${mattress_count} > 0 then 1 else 0 end) ;;
    }

  measure: units_sold {
    label: "Mattress Units Sold"
    type: number
    sql: sum(${TABLE}.mattress_count) ;;
  }

  measure: premier_units_sold {
    label: "Premier Mattress Units Sold"
    type: number
    sql: sum(${TABLE}.premier_count) ;;
  }

  measure: total_orders {
    label: "Total Orders"
    type:  number
    sql: count distinct (${TABLE}.order_id) ;;
  }

  }

view: email_crm_product {
  derived_table: {
    sql:  select distinct d.order_id,
                          sol.item_id
          from datagrid.marketing.V_EMAILCRM_SALES_DETAIL as d
          left outer join datagrid.marketing.V_EMAILCRM_CUST_DETAIL as c
            on d.order_id = c.order_id
          left outer join analytics.sales.sales_order_line as sol
            on sol.order_id = d.order_id
          ;;
  }

  dimension: item_id {
    hidden: yes
    sql: ${TABLE}.item_id ;;
  }

  dimension: order_id {
    hidden: yes
    sql: ${TABLE}.order_id ;;
  }

}
