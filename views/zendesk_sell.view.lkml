view: zendesk_sell {
   derived_table: {
     sql:
select d.deal_id
 , d.contact_id
 , d.user_id
 , d.created_at
 , d.order_id
 , d.order_link
 , d.fraud_risk
 , lk.zendesk_id
 , d.draft_order_name
 , d.RELATED_TRANID
 , nvl(lk.name,u.name) name
 from analytics.customer_care.zendesk_sell_deal d
 left join analytics.customer_care.agent_lkp lk on d.user_id = lk.zendesk_sell_user_id
 left join analytics.customer_care.zendesk_sell_user u on d.user_id = u.user_id
 left join analytics.customer_care.zendesk_sell_contact c on d.contact_id = c.contact_id
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
    sql: ${TABLE}.created_at ;;
  }
  dimension: order_id {
    type: string
    hidden: yes
    sql: ${TABLE}.order_id ;;
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
}
