view: customer_first_order {
   derived_table: {
     sql: with first as (select order_id
                          ,email
                  from sales_order
                  qualify row_number() over (partition by email order by created) = 1)

          select c.email
                  ,c.category
                  ,s.catmod
          from
          (select email
                ,category
          from
              (select first.email
                      ,i.category
                      ,sum(sl.gross_amt) total
              from sales_order_line sl
              join first on first.order_id = sl.order_id
              join item i on i.item_id = sl.item_id
              group by 1,2)
          qualify row_number() over (partition by email order by total desc)=1) c
          join
          (select email
                ,catmod
          from
              (select first.email
                      ,i.category||' | '||i.model catmod
                      ,sum(sl.gross_amt) total
              from sales_order_line sl
              join first on first.order_id = sl.order_id
              join item i on i.item_id = sl.item_id
              group by 1,2)
          qualify row_number() over (partition by email order by total desc)=1) s
          on s.email = c.email
        ;;   }

  dimension: email {
    hidden: yes
    primary_key: yes
    type: string
     sql: ${TABLE}.email ;;
 }

  dimension: first_category {
    label: "Initial Category"
    description: "The category the customer primarily purchased on their first order. If purchased multiple, the category with the highest initial $ value is used. Source: looker.calculation"
    view_label: "Customer"
    group_label: " Advanced"
    type: string
    sql: ${TABLE}.category ;;
  }
  dimension: first_category_model {
    label: "Initial Model"
    description: "The category and model the customer primarily purchased on their first order. If purchased multiple, the model with the highest initial $ value is used. Source: looker.calculation"
    view_label: "Customer"
    group_label: " Advanced"
    type: string
    sql: ${TABLE}.catmod ;;
  }


 }
