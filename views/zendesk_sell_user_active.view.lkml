 view: zendesk_sell_user_active {
   derived_table: {
     sql:
      select zsu.user_id,zsu.name,zsu.email,a.zendesk_id,a.zendesk_sell_user_id
      from analytics.customer_care.zendesk_sell_user zsu
          left join analytics.customer_care.agent_lkp a on lower(zsu.email) = lower(a.email)
      where zsu.zendesk_sell_status = 'active'
          and zsu.email <> 'intel@purple.com'
          and a.inactive is null
       ;;
   }

   dimension: user_id {
    label: "Zendesk Sell User ID"
     description: "Zendesk Sell User ID Source: zendesk_sell.zendesk_sell_user"
     type: number
     sql: ${TABLE}.user_id ;;
   }

   dimension: name {
    label: "Agent Name"
     description: "Agents Name Source: zendesk_sell.zendesk_sell_user"
     type: string
     sql: ${TABLE}.name ;;
   }

  dimension: email {
    label: "Agent Email"
    description: "Agent's Email Source: zendesk_sell.zendesk_sell_user"
    type: string
    sql: ${TABLE}.email ;;
  }

  dimension: zendesk_id {
    label: "Agent_lkp Zendesk User ID"
    description: "Zendesk ID Source: incontact.agent_lkp"
    type: number
    sql: ${TABLE}.zendesk_id ;;
  }

  dimension: zendesk_sell_user_id {
    label: "Agent_lkp Zendesk Sell User ID"
    description: "Zendesk Sell ID Source: incontact.agent_lkp"
    type: number
    sql: ${TABLE}.zendesk_sell_user_id ;;
  }

 }
