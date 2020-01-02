view: first_purchase_date {
    derived_table: {
      sql: select email,
                  min(to_date(created)) as first_order_date,
                  max(to_date(created)) as last_order_date
                  from sales_order
                  group by email ;;
    }
        dimension: email {
          description: "Primary key for order lookup"
          primary_key: yes
          hidden:  yes
          type: string
          sql: ${TABLE}.email ;;
        }

        dimension: first_order_date {
          label: "First Purchase Date"
          description: "Customers First Purchase Date"
          group_label: " Advanced"
          type: date
          sql: ${TABLE}.first_order_date ;; }

        dimension: last_order_date {
          label: "Last Purchase Date"
          description: "Customers Last Purchase Date"
          group_label: " Advanced"
          sql: ${TABLE}.last_order_date ;;  }

        dimension: customer_age_bucket {
          label: "Customer Age Bucket"
          description: "Customer Age by <12 mon, 12-18 mon, 18-24 mon, 24+ mon"
          group_label: " Advanced"
          type: string
          sql:  case
              when datediff(months, ${first_order_date}, current_date()) < 12 then '<12 mon'
              when datediff(months, ${first_order_date}, current_date()) >= 12 and datediff(months, ${first_order_date}, current_date()) < 18 then '12-18 mon'
              when datediff(months, ${first_order_date}, current_date()) >= 18 and datediff(months, ${first_order_date}, current_date()) < 24 then '18-24 mon'
              else '24+ mon'
              end ;;
  }
      }
