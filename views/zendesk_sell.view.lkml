view: zendesk_sell {
   derived_table: {
     sql:
select s.deal_id
, s.zendesk_sell_user_id user_id
, d.created_at
, s.order_id
, s.order_link
, s.RETAIL_AGENT
, s.fraud_risk
, s.zendesk_sell_user_id as zendesk_id
, d.draft_order_name
, nvl(lk.name,u.name) name
 from analytics.customer_care.inside_sales s
 left join analytics.customer_care.zendesk_sell_deal d on d.deal_id = s.deal_id
 left join analytics.customer_care.agent_lkp lk on coalesce(s.zendesk_sell_user_id,d.user_id) = lk.zendesk_sell_user_id
 left join analytics.customer_care.zendesk_sell_user u on s.zendesk_sell_user_id = u.user_id
 ;;
     }

  dimension: pending_draft_order{
    label: "    * Pending Draft Order"
    description: "Y/N; Yes if Order ID is null"
    type: yesno
    sql: ${TABLE}.order_id is null ;;
  }
 dimension: deal_id {
    type: string
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
    sql: ${TABLE}.created_at ;;
  }
  dimension: order_id {
    type: string
    primary_key: yes
    hidden: yes
    sql: ${TABLE}.order_id ;;
  }

  dimension: name {
    type: string
    label: "Agent Name"
    description: "Null if not linked to a deal"
    sql: case when ${TABLE}.name ilike '%Deleted%' then null
         else ${TABLE}.name
         end;;
  }

  dimension: draft_order_name {
    type: string
    label: "Draft Order Name"
    sql: ${TABLE}.draft_order_name;;
  }

  dimension: order_link {
    type: string
    label: "Order Link"
    sql: ${TABLE}.order_link;;
  }

  dimension: fraud_risk {
    type: string
    label: "Fraud Risk"
    sql: ${TABLE}.fraud_risk;;
  }

  dimension: inside_sales_order {
    label: "     * Is Inside Sales Order"
    description: "Order matched on related tranid, draft order, or email"
    type: yesno
    sql: ${TABLE}.order_id is not null ;;
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

  dimension: RETAIL_AGENT {
    type: yesno
    label: " * Is Retail Agent"
    description: "Yes if agent is a retail agent"
    sql: ${TABLE}.RETAIL_AGENT = 'TRUE' ;;
  }

  measure: count{
    type:  count
  }
}
