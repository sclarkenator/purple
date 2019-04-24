view: first_order_flag {
   derived_table: {
     sql: select order_id
                  ,system
                  ,case when order_sequence = 1 then 'NEW' else 'REPEAT' end NEW_FLG
        from
        (select order_id
                ,system
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
          label: "New/Repeat Customer?"
          view_label: "Sales Header"
          description: "New or repeat for this email address?"
          type: string
          sql: ${TABLE}.new_Flg ;;
        }
}
