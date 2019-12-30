view: first_purchase_date {
    derived_table: {
      sql: select order_id
                  ,system
                  ,created as first_purchase_date
                  ,case when order_sequence = 1 then 'NEW' else 'REPEAT' end NEW_FLG
        from
        (select order_id
                ,system
                ,created
                ,rank() over (partition by email order by trandate) order_sequence
        from sales_order
        where channel_id = 1)  ;; }

        dimension: pk {
          description: "Primary key for order lookup"
          primary_key: yes
          hidden:  yes
          type: string
          sql: ${TABLE}.order_id||'-'||${TABLE}.system ;;
        }

        dimension: new_flg {
          label: "   New/Repeat Customer?"
          view_label: "Sales Order"
          description: "New or repeat for this email address?"
          type: string
          sql: ${TABLE}.new_Flg ;;
        }

        dimension: first_purchase_date {
          label: "First Purchase Date"
          view_label: "Customer"
          group_label: " Advanced"
          type: date
          sql: ${TABLE}.first_purchase_date ;;
        }
      }
