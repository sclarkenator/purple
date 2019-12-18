view: zendesk_sales {
  derived_table: {
    sql:
    select a.deal_id
, a.contact_id
, a.user_id
, a.deal_created
, a.draft_order_subtotal_amt
, a.order_id
, a.system
, b.name
, b.email
, b.team_name
, b.zendesk_id
from analytics.customer_care.v_zendesk_sell_kpi a
left join analytics.customer_care.zendesk_sell_user b on a.user_id = b.user_id
where order_id is not null;;
  }

 dimension:has_touch {
    label: "    * Has Touch"
    description: "Y/N; Yes if Zendesk Order ID matches Netsuite"
    sql: ${TABLE}.deal_id is not null;;
    type:yesno
  }

 dimension: deal_id {
    type: string
    hidden: yes
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
    sql: ${TABLE}.name ;;
  }
  dimension: team_name{
    type: string
    sql: ${TABLE}.team_name ;;
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
