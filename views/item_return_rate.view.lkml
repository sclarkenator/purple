# If necessary, uncomment the line below to include explore_source.

# this messy table brought to you by Scott Clark. Don't ask me to try and explain it, because I won't remember...

view: item_return_rate {
  derived_table: {
    sql:
with returns_exchanges as
((select rol.order_id
        ,rol.item_id
        ,rol.closed
        ,rol.return_qty
        ,ro.rma_return_type
        ,ro.status
        ,ro.created date
        ,'RETURN' as type
from return_order_line rol join return_order ro on rol.return_order_id = ro.return_order_id
where status = 'Refunded'
and rma_return_type = 'Trial'
MINUS
select eol.order_id
        ,eol.item_id
        ,eol.closed
        ,eol.quantity
        ,'Trial' EXCHANGE_TYPE
        ,eo.status
        ,eo.created
        ,'RETURN' as type
from exchange_order_line eol join exchange_order eo on eol.exchange_order_id = eo.exchange_order_id
where status='Refunded')
 UNION
select eol.order_id
        ,eol.item_id
        ,eol.closed
        ,eol.quantity
        ,'Exchange' EXCHANGE_TYPE
        ,eo.status
        ,eo.created
        ,'EXCHANGE' as type
from exchange_order_line eol join exchange_order eo on eol.exchange_order_id = eo.exchange_order_id
where status='Refunded')
,
GWP_return as (
select order_id
        ,sum(case when return_qty = total_qty and is_gift_with_purchase = 'F' then 0 else 1 end) non_GWP_return  -- chose 0 here for multiplier
from (
    select sol.is_gift_with_purchase
            ,sol.order_id
            ,return_qty
            ,sum(return_qty) over (partition by sol.order_id) total_qty
    from sales_order_line sol join returns_exchanges re on sol.item_id = re.item_id and sol.order_id = re.order_id)
group by 1)
,
sub as (
select case when channel_id = 5 then 'Retail'
            WHEN zendesk_sell.order_id is not null  THEN 'Inside sales' else 'Web' end channel
        ,so.order_id
        ,sol.item_id
        ,sol.gross_amt
        ,sol.adjusted_gross_amt
        ,sol.ordered_qty
        ,sol.discount_amt
        ,sol.adjusted_discount_amt
        ,f.fulfilled
        ,re.return_qty
        ,is_gift_with_purchase line_GWP
        ,so.has_gwp order_GWP
        ,gr.non_gwp_return
        ,case when reo.order_id is not null then 1 else 0 end gwp_return
        ,case when re.return_qty is null and so.has_gwp = 'T' and sol.is_gift_with_purchase = 'T' and reo.order_id is not null then 1 else 0 end ret_adj_flg
        ,case when return_qty > 0 then 1 else 0 end * adjusted_gross_amt return_amt
        ,ret_adj_flg*(adjusted_gross_amt-sol.gross_amt)*non_gwp_return return_adj
from sales_order_line sol join sales_order so on sol.order_id = so.order_id and so.system = sol.system
join sales.fulfillment f on f.order_id = so.order_id and f.item_id = sol.item_id and f.system = sol.system
left join returns_exchanges re on re.order_id = sol.order_id and re.item_id = sol.item_id
left join GWP_return gr on gr.order_id = so.order_id
left join (select distinct order_id from returns_exchanges) reo on reo.order_id = so.order_id
FULL OUTER JOIN customer_care.v_zendesk_sell  AS zendesk_sell ON zendesk_sell.order_id=so.order_id and so.SYSTEM='NETSUITE'
where so.channel_id in (1,5)
and datediff(d,f.fulfilled,current_date())<230
and datediff(d,f.fulfilled,current_date())>140
)
,main as (
  select distinct channel
        ,trim(i.sku_id,'AC-') sku_id
        ,i.description
        ,sum(return_amt) over (partition by sku_id) total_return_dollars
        ,sum(return_adj) over (partition by sku_id) total_return_adj
        ,sum(adjusted_gross_amt) over (partition by sku_id) total_adj_gross
        ,sum(ordered_qty) over (partition by sku_id, channel) channel_units
        ,sum(return_amt) over (partition by sku_id,channel) channel_return_dollars
        ,sum(return_adj) over (partition by sku_id,channel) channel_return_adj
        ,sum(adjusted_gross_amt) over (partition by sku_id,channel) channel_adj_gross
from sub join item i on i.item_id = sub.item_id)
,channel_level as (
select channel
        ,sku_id
        ,sum(case when channel_units < 75 then total_return_dollars else channel_return_dollars end) return_amt
        ,sum(case when channel_units < 75 then total_return_adj else channel_return_adj end) return_adj
        ,sum(case when channel_units < 75 then total_adj_gross else channel_adj_gross end) adjusted_gross_amt
        ,nvl(round(return_amt/nullif(adjusted_gross_amt,0),4),0) adj_ret_rate
        ,nvl(round(return_adj/nullif(adjusted_gross_amt,0),4),0) return_clawback_rate
from main
group by 1,2)
select distinct case when channel_id = 5 then 'Retail'
            WHEN zendesk_sell.order_id is not null  THEN 'Inside sales' else 'Web' end channel
        ,so.order_id
        ,trim(i.sku_id,'AC-') sku_id
        ,row_number() over (partition by so.order_id, i.sku_id order by i.sku_id) pk_row
        ,is_gift_with_purchase line_GWP
        ,so.has_gwp order_GWP
        ,gr.non_gwp_return
        ,case when reo.order_id is not null then 1 else 0 end gwp_return
        ,case when re.return_qty is null and so.has_gwp = 'T' and sol.is_gift_with_purchase = 'T' and reo.order_id is not null then 1 else 0 end ret_adj_flg
        ,case when datediff(d,f.fulfilled,current_date())>140 AND return_qty > 0 then 1 when datediff(d,f.fulfilled,current_date())>140 AND nvl(return_qty,0) =0 then 0 else cl.adj_ret_rate end * sol.adjusted_gross_amt adj_return_amt
        ,case when datediff(d,f.fulfilled,current_date())>140 then ret_adj_flg*(sol.adjusted_gross_amt-sol.gross_amt)*non_gwp_return else sol.adjusted_gross_amt * nvl(return_clawback_rate,0) end adj_ret_clawback
from sales_order_line sol join sales_order so on sol.order_id = so.order_id and so.system = sol.system
join sales.fulfillment f on f.order_id = so.order_id and f.item_id = sol.item_id and f.system = sol.system
left join item i on i.item_id = sol.item_id
left join returns_exchanges re on re.order_id = sol.order_id and re.item_id = sol.item_id
left join GWP_return gr on gr.order_id = so.order_id
left join (select distinct order_id from returns_exchanges) reo on reo.order_id = so.order_id
FULL OUTER JOIN customer_care.v_zendesk_sell  AS zendesk_sell ON zendesk_sell.order_id=so.order_id and so.SYSTEM='NETSUITE'
left join channel_level cl on case when so.channel_id = 5 then 'Retail'
            WHEN zendesk_sell.order_id is not null  THEN 'Inside sales' else 'Web' end = cl.channel and trim(i.sku_id,'AC-') = cl.sku_id
where so.channel_id in (1,5)

      ;;
    datagroup_trigger: pdt_refresh_6am

  }

  measure: adj_return_amt {
    label: " 7 - $ Returns"
    view_label: "zz Margin Calculations"
    description: "Actual returns (adjusted for GWP) when fulfilled 140+ days ago, modeled value using most recent complete 90-day window"
    hidden: no
    type: sum
    value_format: "$#,##0"
    sql: ${TABLE}.adj_return_amt ;;
  }

  measure: adj_return_clawback {
    label: " 7a - Return clawbacks"
    view_label: "zz Margin Calculations"
    description: "Contra-sales for GWP item when main item returned. Based in adjusted gross sales dollars. Actuals when fulfilled 140+ days ago, modeled value using most recent complete 90-day window"
    hidden: no
    type:sum
    value_format: "$#,##0"
    sql: ${TABLE}.adj_ret_clawback ;;
  }

  dimension: return_rate_dim {
    hidden: yes
    type: number
    sql: ${TABLE}.adj_ret_rate ;;
  }

  dimension: sku_id {
    label: "Product SKU ID"
    hidden: yes
    description: "Internal Netsuite ID"
    type: number
    sql:  ${TABLE}.sku_id ;;
  }

  dimension: pk {
    label: "Primary key"
    hidden: yes
    primary_key: yes
    type: string
    sql:  ${TABLE}.order_id||'-'||${TABLE}.channel||'-'||${TABLE}.sku_id||'-'||${TABLE}.pk_row;;
  }

  dimension: order_id {
    label: "order_ID"
    hidden: yes
    description: "This channel is just for joining item returns to sales order line"
    type: string
    sql:  ${TABLE}.order_id ;;
  }

  dimension: channel {
    label: "channel for join"
    hidden: yes
    description: "This channel is just for joining item returns to sales order line"
    type: string
    sql:  ${TABLE}.channel ;;
  }


}
