view: agent_name {
  sql_table_name: customer_care.agent_lkp ;;


dimension: incontact_id {
  description: "The InContact ID for this agent. Source: incontact.agent_lkp"
  type:  number
  hidden: yes
  sql: ${TABLE}.incontact_id ;;
  primary_key: yes
}

dimension: zendesk_id {
  description: "The ZenDesk ID for this agent. Source: incontact.agent_lkp"
  type:  number
  hidden: yes
  sql: ${TABLE}.zendesk_id ;;
}

dimension: shopify_id {
  description: "The Shopify ID for this agent. Source: incontact.agent_lkp"
  type:  number
  hidden: yes
  sql: coalesce(${TABLE}.shopify_id_pos,${TABLE}.shopify_id) ;;
}

dimension: shopify_id_us {
  description: "The Shopify ID for this agent. Source: incontact.agent_lkp"
  type:  number
  hidden: yes
  sql: ${TABLE}.shopify_id ;;
}

dimension: shopify_id_pos {
  description: "The Shopify POS ID for this agent. Source: shopify_pos.agent_lkp"
  type:  number
  hidden: yes
  sql: ${TABLE}.shopify_id_pos ;;
}

  dimension: retail {
    hidden: no
    label: " * Is Retail Agent"
    type:  yesno
    sql: ${TABLE}.retail ;;
  }

dimension: name {
  label: "CC Agent Name"
  group_label: " Advanced"
  description: "The name of this agent. Source:incontact.agent_lkp"
  type:  string
  sql: ${TABLE}.name ;;
}

  dimension: merged_name{
    group_label: " Advanced"
    label: "CC/ZD Agent Name"
    description: "The name of this agent. Source:incontact.agent_lkp"
    type:  string
    sql: nvl(${zendesk_sell.name},${TABLE}.name)  ;;
  }

  dimension: email_join {
    description: "The email address for this agent"
    type:  string
    hidden: yes
    sql: lower(${TABLE}.email) ;;
  }


}
