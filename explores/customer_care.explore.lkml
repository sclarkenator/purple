#-------------------------------------------------------------------
#
# Customer Care Explores
#
#-------------------------------------------------------------------
include: "/views/**/*.view"
include: "/dashboards/**/*.dashboard"

#####################################################################
#####################################################################
## AGENT ATTENDANCE cj

explore:agent_attendance {

  view_label: "Agent Data"
  view_name: agent_data
  hidden: yes
  sql_always_where: ${agent_data.incontact_id} is not null
    and ${agent_data.incontact_id} <> '2612383' ;;

  join: agent_current_warning_level {
    view_label: "Attendance Data"
    fields: [agent_current_warning_level.warning_level, agent_current_warning_level.current_points]
    type: left_outer
    sql_on: ${agent_data.incontact_id} = ${agent_current_warning_level.incontact_id} ;;
    relationship: one_to_one
  }

  join: attendance_data {
    view_label: "Attendance Data"
    from: cc_agent_attendance
    type: left_outer
    sql_on: ${agent_data.incontact_id} = ${attendance_data.incontact_id} ;;
    relationship: one_to_many
  }

  join: agent_team_history {
    view_label: "Agent Data"
    # from: agent_team_history
    type: left_outer
    sql_on:  ${agent_data.incontact_id} = ${agent_team_history.incontact_id}
      and ${attendance_data.event_date_date} between ${agent_team_history.start_date} and ${agent_team_history.end_date}  ;;
    relationship: many_to_one
  }
}

#####################################################################
#####################################################################
# AGENT STATE cj

explore: agent_state {
  view_label: "Agent States"
  hidden: yes

  join: agent_data {
    view_label: "Agent Data"
    type: left_outer
    sql_on: ${agent_state.agent_id} = ${agent_data.incontact_id} ;;
    # and cast(${agent_state.state_start_ts_mst_date} as date) between ${agent_data.team_begin_date} and ${agent_data.team_end_date} ;;
    relationship: many_to_one
  }

  join: agent_team_history {
    view_label: "Agent Data"
    # from: agent_team_history
    type: left_outer
    sql_on:  ${agent_data.incontact_id} = ${agent_team_history.incontact_id}
      and ${agent_state.state_start_ts_mst_date} between ${agent_team_history.start_date} and ${agent_team_history.end_date}  ;;
    relationship: many_to_one
  }
}

#####################################################################
#####################################################################
## CC_KPIs cj

explore: CC_KPIs {

  label: "CC KPIs"
  view_name: agent_lkp
  view_label: "Agent Data"
  hidden: yes

  join: zendesk_ticket {
    view_label: "Zendesk Tickets"
    type: left_outer
    sql_on: ${agent_lkp.zendesk_id} = ${zendesk_ticket.assignee_id} ;;
    relationship: many_to_one
  }

  join: zendesk_chat_engagements {
    view_label: "Chat Engagement"
    type: left_outer
    sql_on: ${zendesk_ticket.ticket_id} = ${zendesk_chat_engagements.ticket_id} ;;
    relationship: many_to_one
  }
}

#####################################################################
#####################################################################
## CONTACT HISTORY cj

explore: contact_history {
  view_label: "Contact History"
  hidden:yes

  join: agent_data {
    view_label: "Agent Data"
    type: left_outer
    sql_on: ${contact_history.agent_id} = ${agent_data.incontact_id} ;;
    relationship: many_to_one
  }

  # join: agent_team_history {
  #   view_label: "Agent Data"
  #   # from: agent_team_history
  #   type: left_outer
  #   sql_on:  ${contact_history.agent_id}.incontact_id} = ${agent_team_history.incontact_id}
  #     and ${contact_history.start_ts_date} between ${agent_team_history.start_date} and ${agent_team_history.end_date}  ;;
  #   relationship: many_to_one
  # }
}

#####################################################################
#####################################################################
## HEADCOUNT V2 cj

explore: cc_headcount_v2 {
  from: cc_headcount_bydate
  hidden: yes
  group_label: "Customer Care"
  view_label: "Agent Info"
  join: team_lead_name {
    view_label: "Team Lead"
    fields: [team_lead_name.incontact_id, team_lead_name.start_date, team_lead_name.end_date, team_lead_name.team_lead_id]
    type: left_outer
    sql_on: ${team_lead_name.incontact_id} = ${cc_headcount_v2.incontact_id}
        and ${cc_headcount_v2.by_date} between cast(${team_lead_name.start_date} as date) and cast(${team_lead_name.end_date} as date)  ;;
    relationship: many_to_one
  }
  join: agent_data {
    view_label: "Team Lead"
    type: left_outer
    sql_on: ${team_lead_name.incontact_id} = ${agent_data.incontact_id} ;;
    relationship: many_to_one
  }
}

#####################################################################
#####################################################################
# INCONTACT PHONE cj

explore: incontact_phone {
  label: "InContact Phone"
  view_label: "Agent Data"
  description: "Tracks phone related contact data."
  view_name: agent_data
  hidden: yes

  join: incontact_phone {
    view_label: "Phone Calls"
    type: full_outer
    sql_on: ${agent_data.incontact_id} = ${incontact_phone.agent_id} ;;
    relationship: many_to_one
  }
}

#####################################################################
#####################################################################
## REFUSALS cj

explore: contact_refusals {
  view_label: "InContact Call Refusals"
  hidden: yes
  view_name: contact_history
  sql_always_where: ${contact_history.contact_state_name} = 'Refused' ;;

  join: agent_data {
    view_label: "Agent Data"
    type: left_outer
    sql_on: ${contact_history.agent_id} = ${agent_data.incontact_id} ;;
    relationship: many_to_one
  }
}




  explore: customer_satisfaction_survey {
    label: "Agent CSAT"
    group_label: "Customer Care"
    hidden: yes
    description: "Customer satisfaction of interactions with Customer Care agents"
    join: agent_lkp {
      type: left_outer
      sql_on: ${customer_satisfaction_survey.agent_id}=${agent_lkp.incontact_id} ;;
      relationship: many_to_one
    }
    join: team_lead_name {
      type:  left_outer
      sql_on:  ${team_lead_name.incontact_id}=${agent_lkp.incontact_id}
          AND ${team_lead_name.start_date}<=${customer_satisfaction_survey.created_date}
          AND ${team_lead_name.end_date}>=${customer_satisfaction_survey.created_date};;
      relationship: many_to_one
    }
    join: zendesk_ticket {
      type:  left_outer
      sql_on:  ${zendesk_ticket.ticket_id}=${customer_satisfaction_survey.ticket_id};;
      relationship: many_to_one
    }
  }

  explore: rpt_agent_stats {
    hidden: yes
    label: "InContact Agent Stats"
    group_label: "Customer Care"
    description: "From InContact Agent Stats Daily."
  }

  explore: refund_mismatch {
    label: "Refund Mismatch"
    group_label: "Customer Care"
    hidden: yes
    description: "NetSuite refunds missing in Shopify"
  }

  explore: shopify_coupon_code {
    label: "Shopify Coupon Code"
    group_label: "Customer Care"
    hidden: yes
    description: "Shopify Orders with Coupon Code"
  }

  explore: shopify_net_payment {
    label: "Shopify Net Payment"
    group_label: "Customer Care"
    hidden: yes
    description: "Shopify Orders with Customer's Net Payment Under $10"
  }

  explore: amazon_orphan_orders {
    label: "Amazon Orphan Orders"
    group_label: "Customer Care"
    hidden: yes
    description: "Amazon orders not showing up in Netsuite"
  }

  explore: rma_status_log {
    label: "RMA Status Log"
    group_label: "Customer Care"
    description: "Log of RMA status change"
    join: item {
      type: left_outer
      sql_on: ${rma_status_log.item_id} = ${item.item_id} ;;
      relationship: many_to_one}
  }

  explore: zendesk_chats {
    label: "Zendesk Website Chats"
    group_label: "Customer Care"
    hidden: yes
    join: zendesk_chat_engagements {
      view_label: "Zendesk Chat Engagements"
      type: left_outer
      sql_on: ${zendesk_chats.chat_id} = ${zendesk_chat_engagements.chat_id} ;;
      relationship: one_to_many
      }
      join: agent_lkp {
        type: left_outer
        view_label: "Agent Lookup"
        sql_on: ${zendesk_chat_engagements.zendesk_id}=${agent_lkp.zendesk_id}  ;;
        relationship: many_to_one
      }
    join: team_lead_name {
      type:  left_outer
      view_label: "Agent Lookup"
      sql_on:  ${team_lead_name.incontact_id}=${agent_lkp.incontact_id}
        AND ${team_lead_name.start_date}<=${zendesk_chat_engagements.engagement_start_date}
        AND ${team_lead_name.end_date}>=${zendesk_chat_engagements.engagement_start_date};;
      relationship: many_to_one
      }
    }

  explore: zendesk_ticket {
    hidden: yes
    group_label: "Customer Care"
    label: "Zendesk Tickets"
    description: "Customer ticket details from Zendesk"
    join: group {
      type: full_outer
      sql_on: ${group.id} = ${zendesk_ticket.group_id} ;;
      relationship: many_to_one
    }
    join: user {
      view_label: "Assignee"
      type: left_outer
      sql_on: ${user.id} = ${zendesk_ticket.assignee_id} ;;
      relationship: many_to_one
    }
    join: zendesk_ticket_comment {
      view_label: "Ticket Comments"
      type: left_outer
      sql_on: ${zendesk_ticket.ticket_id} = ${zendesk_ticket_comment.ticket_id} ;;
      relationship: one_to_many
    }
  #     join: ticket_form_history {
  #       type: full_outer
  #       sql_on: ${group.id} = ${ticket.group_id} ;;
  #       relationship: many_to_one
  #     }
  join: agent_lkp {
    type: left_outer
    view_label: "Agent Lookup"
    sql_on: ${user.id}=${agent_lkp.zendesk_id} ;;
    relationship: many_to_one
  }
  join: team_lead_name {
    type:  left_outer
    view_label: "Agent Lookup"
    sql_on:  ${team_lead_name.incontact_id}=${agent_lkp.incontact_id}
        AND ${team_lead_name.start_date}<=${zendesk_ticket.created_date}
        AND ${team_lead_name.end_date}>=${zendesk_ticket.created_date};;
    relationship: many_to_one
  }
}

  explore: daily_disposition_counts {
    group_label: "Customer Care"
    description: "Count of tickets and calls by disposition"
    hidden: yes
  }

  explore: rpt_skill_with_disposition_count {
    label: "Inbound Calls"
    group_label: "Customer Care"
    description: "All inbound calls segmented by skill and disposition (rpt skills with dispositions)"
    join:  magazine_numbers {
      type: full_outer
      sql_on: ${magazine_numbers.phone_number}::text = ${rpt_skill_with_disposition_count.contact_info_to}::text
            --and  ${magazine_numbers.launch_date}::date >= ${rpt_skill_with_disposition_count.reported_date}::date
            ;;
      relationship: many_to_many}
    join: customer_table{
      type: left_outer
      relationship: many_to_many
      sql_on:case when ${rpt_skill_with_disposition_count.inbound_flag} = 'Yes' then ${rpt_skill_with_disposition_count.contact_info_from}::text
            else ${rpt_skill_with_disposition_count.contact_info_to}::text end
            = replace(replace(replace(replace(replace(replace(replace(${customer_table.phone}::text,'-',''),'1 ',''),'+81 ',''),'+',''),'(',''),')',''),' ','') ;;
    }
    join: sales_order {
      type: left_outer
      relationship: one_to_many
      sql_on: ${sales_order.customer_id}::text = ${customer_table.customer_id}::text and ${sales_order.created_date} >= ${rpt_skill_with_disposition_count.reported_date} ;;
    }
    join: sales_order_line_base {
      type: left_outer
      relationship: one_to_many
      sql_on: ${sales_order.order_id} = ${sales_order_line_base.order_id} and ${sales_order.system} = ${sales_order_line_base.system} ;;
    }
    join: item {
      view_label: "Product"
      type: left_outer
      sql_on: ${sales_order_line_base.item_id} = ${item.item_id} ;;
      relationship: many_to_one
    }
    join: v_wholesale_manager {
      view_label: "Customer"
      type:left_outer
      relationship:one_to_one
      sql_on: ${sales_order.order_id} = ${v_wholesale_manager.order_id} and ${sales_order.system} = ${v_wholesale_manager.system};;
    }
    join: agent_lkp {
      type: left_outer
      view_label: "Agent Lookup"
      sql_on: ${rpt_skill_with_disposition_count.agent_id}=${agent_lkp.incontact_id} ;;
      relationship: many_to_one
    }
    join: team_lead_name {
      type:  left_outer
      view_label: "Agent Lookup"
      sql_on:  ${team_lead_name.incontact_id}=${agent_lkp.incontact_id}
        AND ${team_lead_name.start_date}<=${rpt_skill_with_disposition_count.reported_date}
        AND ${team_lead_name.end_date}>=${rpt_skill_with_disposition_count.reported_date};;
      relationship: many_to_one
    }
  }

  explore: agent_lkp {
    hidden: yes
    label: "Agents"
    group_label: "Customer Care"
    join: agent_company_value {
      type: full_outer
      sql_on: ${agent_lkp.incontact_id} = ${agent_company_value.agent_id} ;;
      relationship: one_to_many}
    join: agent_evaluation {
      type: full_outer
      sql_on: ${agent_lkp.incontact_id} = ${agent_evaluation.evaluated_id} ;;
      relationship: one_to_many}
    join: rpt_agent_stats {
      type: full_outer
      sql_on: ${agent_lkp.incontact_id} = ${rpt_agent_stats.agent_id} ;;
      relationship: one_to_many}
    join: v_agent_state {
      type: full_outer
      sql_on: ${agent_lkp.incontact_id} = ${v_agent_state.agent_id} ;;
      relationship: one_to_many}
    join: agent_attendance{
      type: full_outer
      sql_on: ${agent_lkp.incontact_id} = ${agent_attendance.agent_id} ;;
      relationship: one_to_many}
    join: agent_draft_orders {
      type: left_outer
      sql_on: ${agent_lkp.shopify_id} = ${agent_draft_orders.user_id} ;;
      relationship: one_to_many}
    join: customer_satisfaction_survey {
      type: full_outer
      sql_on: ${agent_lkp.incontact_id}::string = ${customer_satisfaction_survey.agent_id}::string ;;
      relationship:  one_to_many
    }
    join: team_lead_name {
      type:  left_outer
      sql_on:  ${team_lead_name.incontact_id}=${agent_lkp.incontact_id}
          AND ${team_lead_name.start_date}<=${customer_satisfaction_survey.created_date}
          AND ${team_lead_name.end_date}>=${customer_satisfaction_survey.created_date};;
      relationship: many_to_one
    }
    required_access_grants: [is_customer_care_manager]
  }

  explore: cc_agent_data {
    hidden: yes
    from:  agent_lkp
    label: "CC Agent Data"
    group_label: "Customer Care"
    join: agent_company_value {
      type: full_outer
      sql_on: ${cc_agent_data.incontact_id} = ${agent_company_value.agent_id} ;;
      relationship: one_to_many}
    join: agent_evaluation {
      type: full_outer
      sql_on: ${cc_agent_data.incontact_id} = ${agent_evaluation.evaluated_id};;
      relationship: one_to_many}
    join: rpt_agent_stats {
      type: full_outer
      sql_on: ${cc_agent_data.incontact_id} = ${rpt_agent_stats.agent_id} ;;
      relationship: one_to_many}
    join: agent_attendance{
      type: full_outer
      sql_on: ${cc_agent_data.incontact_id} = ${agent_attendance.agent_id} ;;
      relationship: one_to_many}
    join: agent_draft_orders {
      type: left_outer
      sql_on: ${cc_agent_data.shopify_id} = ${agent_draft_orders.user_id} ;;
      relationship: one_to_many}
    join: v_agent_state {
      type: full_outer
      sql_on:  ${cc_agent_data.incontact_id}= ${v_agent_state.agent_id};;
      relationship:  one_to_many}
    join: customer_satisfaction_survey {
      type: left_outer
      sql_on: ${cc_agent_data.incontact_id} = ${customer_satisfaction_survey.agent_id}  ;;
      relationship:  one_to_many}
    join: team_lead_name {
      type:  left_outer
      sql_on:  ${team_lead_name.incontact_id}=${cc_agent_data.incontact_id}
        and  ${team_lead_name.end_date}::date > '2089-12-31'::date;;
      #and ${cc_agent_data.created_date}::date >= ${team_lead_name.start_date}::date;;
      relationship: one_to_one
    }
    join: agent_lkp_eval {
      from: agent_lkp
      relationship: many_to_one
      type: left_outer
      sql_on: ${agent_lkp_eval.incontact_id} = ${agent_evaluation.evaluator_id};;
      view_label: "Agent Evaluator"
      fields: [agent_lkp_eval.name, agent_lkp_eval.email, agent_lkp_eval.is_supervisor]
    }
    required_access_grants: [is_customer_care_manager]
  }

  explore: cc_deals {
    hidden: yes
    group_label: "Customer Care"
    join: sales_order {
      type:left_outer
      relationship: one_to_one
      sql_on: ${sales_order.order_id} = ${cc_deals.order_id} ;;
    }
    join: sales_order_line_base {
      type: left_outer
      relationship:one_to_many
      sql_on: ${sales_order.order_id} = ${sales_order_line_base.order_id} and ${sales_order.system} = ${sales_order_line_base.system} ;;}
    join: order_flag {
      type: left_outer
      relationship: one_to_one
      sql_on: ${order_flag.order_id} = ${sales_order.order_id} ;;
    }
    join: agent_name {
      type: left_outer
      relationship: many_to_one
      sql_on: ${agent_name.email_join} = ${cc_deals.agent_email} ;;
    }
    join: team_lead_name {
      type:  left_outer
      sql_on:  ${team_lead_name.incontact_id}=${agent_name.incontact_id}
        and  ${team_lead_name.end_date}::date > '2089-12-31'::date;;
      #and ${cc_agent_data.created_date}::date >= ${team_lead_name.start_date}::date;;
      relationship: one_to_one
    }
  }

  explore: cc_activities {hidden: yes group_label: "Customer Care"
    join: agent_lkp {
      type: left_outer
      view_label: "Agent Lookup"
      sql_on: lower(${cc_activities.agent_email})=lower(${agent_lkp.email}) ;;
      relationship: many_to_one
    }
    join: team_lead_name {
      type:  left_outer
      view_label: "Agent Lookup"
      sql_on:  ${team_lead_name.incontact_id}=${agent_lkp.incontact_id}
        and  ${team_lead_name.end_date}::date > '2089-12-31'::date;;
      relationship: many_to_one
    }}

  explore: exchange_items {hidden: yes
    join: item {
      type:  left_outer
      sql_on:  ${item.item_id} = ${exchange_items.original_order_item_id} ;;
      relationship: many_to_one
      view_label: "Original Item"}
    join: item_2 {
      from: item
      type:  left_outer
      sql_on:  ${item.item_id} = ${exchange_items.exchange_order_item_id} ;;
      relationship: many_to_one
      view_label: "Exchange Item"}
  }

  explore: cc_traffic { hidden: yes
    join:bridge_by_agent {
      type: left_outer
      relationship: many_to_one
      view_label: "Bridge Courses"
      sql_on: ${bridge_by_agent.email} = ${cc_traffic.agent_email};;
    }
  }

  explore: orphan_orders {
    hidden:  yes
    group_label: "Customer Care"
    label: "Orphan orders"
    description: "Orders that exist in Shopify that aren't yet in Netsuite"
  }

  explore: cc_headcount {
    from: cc_headcount_bydate
    hidden: yes
    group_label: "Customer Care"
    view_label: "Agent Info"
    join: team_lead_name {
      view_label: "Team Lead"
      fields: [team_lead_name.incontact_id, team_lead_name.start_date, team_lead_name.end_date, team_lead_name.team_lead_id]
      type: left_outer
      sql_on: ${team_lead_name.incontact_id} = ${cc_headcount.incontact_id}
        and ${team_lead_name.start_date} <= ${cc_headcount.by_date}
        and ${team_lead_name.end_date} >= ${cc_headcount.by_date};;
      relationship: many_to_one
    }
    join: agent_lkp {
      view_label: "Team Lead"
      type: left_outer
      sql_on: ${team_lead_name.incontact_id} = ${agent_lkp.incontact_id} ;;
      relationship: many_to_one
    }
  }

  explore: agent_data {hidden: yes} #cj
  explore: agent_current_warning_level {hidden: yes} #cj
  explore: shopify_refund {hidden:yes}
  explore: zendesk_macros {hidden:yes}
  explore: v_retail_orders_without_showroom {hidden:yes}
  #explore:  bridge_by_agent {}
  explore: agent_company_value {  hidden: yes  label: "Agent Company Value"  group_label: "Customer Care"}
  explore: agent_evaluation {  hidden: yes  label: "Agent Evaluation"  group_label: "Customer Care"}
  # explore: agent_attendance {  hidden: yes  label: "Agent Attendance"  group_label: "Customer Care"}
  explore: v_agent_state  { hidden:  yes  label: "Agent Time States"  group_label: "Customer Care"}
  explore: zendesk_sell_contact {hidden:yes group_label: "Customer Care"}
  explore: zendesk_sell_deal {hidden:yes group_label: "Customer Care"}
  explore: zendesk_sell_user {hidden:yes group_label: "Customer Care"}
  explore: cc_call_service_level_csl { description: "Calculated service levels" hidden: yes group_label: "Customer Care" }
  explore: v_mismatch_rma {hidden: yes group_label:"Customer Care" description:"This is used by the CSR team to find RMA number they need to fix on the return form."}
  explore: v_shopify_refund_status { hidden: yes group_label:"Customer Care" }
  explore: zendesk_sell_user_active {hidden:yes group_label:"Customer Care" description: "Compares Agents in Zendesk Sell and Zendesk."}
  explore: rpt_service_levels { hidden: yes group_label:"Customer Care" description: "Incontact servive level by campaign"}
  explore: v_zendesk_articles {hidden: yes}
  explore: v_invalid_rma {hidden: yes group_label:"Customer Care" description: "Invalid RMA Finder for Emily Heise"}
  explore: zendesk_ticket_v2 {hidden: yes  group_label:"Customer Care"  description: "Zendesk ticket data. Explore created June2021"}
