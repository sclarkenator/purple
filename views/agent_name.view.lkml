view: agent_name {
  sql_table_name: customer_care.agent_lkp ;;


dimension: incontact_id {
  description: "The InContact ID for this agent"
  type:  number
  hidden: yes
  sql: ${TABLE}.incontact_id ;;
  primary_key: yes
}

dimension: zendesk_id {
  description: "The ZenDesk ID for this agent"
  type:  number
  hidden: yes
  sql: ${TABLE}.zendesk_id ;;
}

dimension: shopify_id {
  description: "The Shopify ID for this agent"
  type:  number
  hidden: yes
  sql: ${TABLE}.shopify_id ;;
}

dimension: name {
  description: "The name of this agent"
  label: "CC Agent Name"
  group_label: " Advanced"
  type:  string
  sql: ${TABLE}.name ;;
}

  dimension: merged_name{
    description: "The name of this agent"
    label: "CC/ZD Agent Name"
    group_label: " Advanced"
    type:  string
    sql: nvl(${zendesk_sales.name},${TABLE}.name)  ;;
  }


}
