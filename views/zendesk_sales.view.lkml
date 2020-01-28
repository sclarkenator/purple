view: zendesk_sales {
#  sql_table_name: customer_care.v_zendesk_sell_kpi ;;
   derived_table: {
     sql:
     select a.deal_id
 , a.contact_id
 , a.user_id
 , a.deal_created
 , a.draft_order_subtotal_amt
 , a.order_id
 , a.system
 , b.zendesk_id
 , d.draft_order_name
 , d.RELATED_TRANID
 , nvl(b.name,c.name) name
 from analytics.customer_care.v_zendesk_sell_kpi a
 left join analytics.customer_care.agent_lkp b on a.user_id = b.zendesk_sell_user_id
 left join analytics.customer_care.zendesk_sell_user c on a.user_id = c.user_id
 left join analytics.customer_care.zendesk_sell_deal d on a.user_id= d.user_id ;;
   }

 dimension:has_touch {
    label: "    * Has Touch"
    description: "Y/N; Yes if Zendesk Order ID matches Netsuite"
    sql: ${TABLE}.deal_id is not null;;
    type:yesno
  }
  dimension: pending_draft_order{
    label: "    * Pending Draft Order"
    description: "Y/N; Yes if Order ID is null"
    type: yesno
    sql: ${TABLE}.order_id is null ;;
  }
 dimension: deal_id {
    type: string
    primary_key: yes
    sql: ${TABLE}.deal_id ;;
  }
  dimension: contact_id {
    type: string
    hidden: yes
    sql: ${TABLE}.contact_id ;;
  }
  dimension: user_id {
    type: string
    hidden: yes
    sql: ${TABLE}.user_id ;;
  }
  dimension: deal_created {
    type: date
    label: "Created Date"
    description: "Date deal was created in Zendesk"
    sql: ${TABLE}.deal_created ;;
  }
  dimension: draft_amt {
    type: number
    hidden: yes
    sql: ${TABLE}.draft_order_subtotal_amt ;;
  }
  dimension: order_id {
    type: string
    hidden: yes
    sql: ${TABLE}.order_id ;;
  }

  dimension: system {
    type: string
    hidden: yes
    sql: ${TABLE}.system ;;
  }
  dimension: name {
    type: string
    label: "Agent Name"
    description: "Null if not linked to a deal"
    sql: ${TABLE}.name;;
  }

  dimension: draft_order_name {
    type: string
    label: "Draft Order Name"
    sql: ${TABLE}.draft_order_name;;
  }

  dimension: related_tranid {
    type: string
    label: "Related Tran ID"
    sql: ${TABLE}.RELATED_TRANID;;
  }

  dimension: zendesk_id {
    type: string
    sql: ${TABLE}.zendesk_id ;;
  }
  measure: count{
    type:  count
  }
  measure: total_draft_amount{
    type: sum
    sql: ${TABLE}.draft_order_subtotal_amt;;
    value_format: "$#,##0.00"
    }

}
