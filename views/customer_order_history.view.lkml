view: customer_order_history {
   derived_table: {
#    persist_for: "6 hours"
    sql: select email
        ,min(trandate) first_order
        ,sum(case when gross_amt > 0 then 1 else 0 end) total_orders
from sales_order
group by 1
       ;;
   }

   dimension: email {
    view_label: "Customer"
    label: "Email"
    primary_key: yes
    hidden: yes
    description: "Customer email address"
    type: string
    sql: ${TABLE}.email ;;
   }

   dimension: lifetime_orders {
    view_label: "Customer"
    label: "# of orders"
    group_label: " Advanced"
    description: "The total number of non-zero-dollar orders for each customer"
    type: number
    sql: ${TABLE}.total_orders ;;
    }

   dimension_group: first_order {
    view_label: "Customer"
    label: " First order"
    description: "Date of customer's first order"
    type: time
    timeframes: [raw, hour_of_day, date, day_of_week, day_of_week_index, day_of_month, day_of_year, week, week_of_year, month, month_num, month_name, quarter, quarter_of_year, year]
    convert_tz: no
    datatype: timestamp
    sql: to_date(${TABLE}.first_order) ;;
   }

    dimension: months_from_first_order {
    label: "Mths since 1st"
    view_label: "Customer"
    group_label: " Advanced"
    description: "Number of months since this customer, identfied by email address, made their first purchase"
    type: number
    sql: datediff(month,${first_order_date},${sales_order.trandate}) ;;
  }

 }
