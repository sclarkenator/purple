# If necessary, uncomment the line below to include explore_source.

#include: "main.model.lkml"

view: item_return_rate {
  derived_table: {
    sql:
      select trim(i.sku_id,'AC-') sku_id
              ,nvl(sum(returns),0)/sum(sales) return_rate
      from
      (
      select sol.item_id
              ,sum(returns) returns
              ,sum(sol.gross_amt) sales
      from sales.sales_order_line sol
      left join sales.sales_order so on sol.order_id = so.order_id and sol.system = so.system
      left join
            (select rl.order_id
                    ,rl.item_id
                    ,rl.system
                    ,sum(rl.gross_amt) returns
             from sales.return_order_line rl
             join sales.return_order ro on ro.return_order_id = rl.return_order_id
             where ro.status = 'Refunded'
             and rl.closed > '2019-10-01'
             group by 1,2,3
             order by 4 desc) r
          on r.order_id = sol.order_id and r.item_id = sol.item_id and r.system = sol.system
      where datediff(d,sol.fulfilled,current_date)>130 and datediff(d,sol.fulfilled,current_date)<=220
      and so.channel_id = 1
      group by 1
      having sum(sol.gross_amt)>0) s
      join sales.item i on i.item_id = s.item_id
      group by 1;;
  }

  measure: return_rate {
    label: "Return rate"
    view_label: "zz Margin Calculations"
    hidden: yes
    type: sum
    value_format: "0.00%"
    sql: ${TABLE}.return_rate ;;
  }

  dimension: return_rate_dim {
    hidden: yes
    type: number
    sql: ${TABLE}.return_rate ;;
  }

  dimension: sku_id {
    label: "Product SKU ID"
    primary_key: yes
    hidden: yes
    description: "Internal Netsuite ID"
    type: number
    sql:  ${TABLE}.sku_id ;;
  }
}
