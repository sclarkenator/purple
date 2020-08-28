view: first_order_flag {
   derived_table: {
     sql: select order_id
                  ,system
                  ,case when order_sequence = 1 then 'NEW' else 'REPEAT' end NEW_FLG
        from
        (select order_id
                ,system
                ,rank() over (partition by email order by created) order_sequence
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
}
