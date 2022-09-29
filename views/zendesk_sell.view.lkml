view: zendesk_sell {
  sql_table_name: customer_care.v_zendesk_sell ;;
#    derived_table: {
#      sql:
#       select s.deal_id
#       , s.zendesk_sell_user_id user_id
#       , d.created_at
#       , s.order_id
#       , s.order_link
#       , s.RETAIL_AGENT
#       , s.fraud_risk
#       --, s.zendesk_sell_user_id as zendesk_id
#       , lk.zendesk_id
#       , d.draft_order_name
#       , nvl(lk.name,u.name) name
#        from analytics.customer_care.inside_sales s
#        left join analytics.customer_care.zendesk_sell_deal d on d.deal_id = s.deal_id
#        left join analytics.customer_care.agent_lkp lk on coalesce(s.zendesk_sell_user_id,d.user_id) = lk.zendesk_sell_user_id
#        left join analytics.customer_care.zendesk_sell_user u on s.zendesk_sell_user_id = u.user_id
#
#  ;;
#      }

  dimension: pending_draft_order{
    group_label: "Advanced - Sell"
    label: "    * Is Pending Draft Order (Yes/No)"
    description: "Yes if Order ID is null. Source: looker calculation"
    type: yesno
    sql: ${TABLE}.order_id is null ;;
  }
 dimension: deal_id {
    type: string
    group_label: "Advanced - Sell"
    description: "Source: zendesk_sell.inside_sales"
    sql: ${TABLE}.deal_id ;;
  }
  dimension: contact_id {
    type: string
    hidden: yes
    group_label: "Advanced - Sell"
    sql: ${TABLE}.contact_id ;;
  }
  dimension: user_id {
    type: string
    hidden: yes
    group_label: "Advanced - Sell"
    description: "Agents Zendesk Sell ID. Source: zendesk_sell.inside_sales"
    sql: ${TABLE}.user_id ;;
  }
  dimension: deal_created {
    type: date
    group_label: "Advanced - Sell"
    label: "Created Date"
    description: "Date deal was created in Zendesk  Source: zendesk_sell.zendesk_sell_deal"
    sql: ${TABLE}.created_at ;;
  }
  dimension: order_id {
    type: string
    primary_key: yes
    hidden: yes
    group_label: "Advanced - Sell"
    sql: ${TABLE}.order_id ;;
  }

  dimension: name {
    type: string
    group_label: "Advanced - Sell"
    label: "Agent Name"
    description: "Null if not linked to a deal. Source: incontact.agent_lkp"
    sql: case when ${TABLE}.name ilike '%Deleted%' then null
         else ${TABLE}.name
         end;;
  }

  dimension: email {
    type: string
    hidden: yes
    sql:  upper(${TABLE}.email) ;;
  }

  dimension: draft_order_name {
    type: string
    group_label: "Advanced - Sell"
    label: "Draft Order Name"
    description: "Source: zendesk_sell.zendesk_sell_deal"
    sql: ${TABLE}.draft_order_name;;
  }

  dimension: order_link {
    type: string
    group_label: "Advanced - Sell"
    label: "Order Link"
    description: "How the order was linked to the Inside Sales Agent. Source: zendesk_sell.inside_sales"
    sql: ${TABLE}.order_link;;
  }

  dimension: fraud_risk {
    type: string
    group_label: "Advanced - Sell"
    label: "Fraud Risk"
    description: "Source: zendesk_sell.inside_sales"
    sql: ${TABLE}.fraud_risk;;
  }

  dimension: inside_sales_order {
    view_label: "Sales Order"
    label: "     * Is Inside Sales Order"
    description: "Order linked to Inside Sales Agent on Shopify created by, related tranid, draft order, or email. Source: inside_sales_model.inside_sales"
    type: yesno
    sql: ${TABLE}.order_id is not null ;;
  }

  # dimension: related_tranid {
  #   type: string
  #   group_label: "Advanced - Sell"
  #   label: "Related Tran ID"
  #   description: "Source: zendesk_sell.inside_sales"
  #   sql: ${TABLE}.draft_order_name;;
  # }

  dimension: zendesk_id {
    type: number
    group_label: "Advanced - Sell"
    description: "Source: incontact.agent_lkp"
    sql: ${TABLE}.zendesk_id ;;
  }

  dimension: RETAIL_AGENT {
    type: yesno
    hidden:  yes
    group_label: "Advanced - Sell"
    label: " * Is Retail Agent"
    description: "Yes if agent is a retail agent. Source: zendesk_sell.inside_sales"
    sql: ${TABLE}.RETAIL_AGENT = 'TRUE' ;;
  }

  measure: count{
    group_label: "Advanced - Sell"
    description: "Source: looker calculation"
    type:  count
  }
}
