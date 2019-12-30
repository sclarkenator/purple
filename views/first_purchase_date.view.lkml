view: first_purchase_date {
    derived_table: {
      sql: select email,
                  min(to_date(created)) as first_order_date
                  from sales_order
                  group by email

        dimension: pk {
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
          sql: ${TABLE}.first_order_date ;;
        }
      }
