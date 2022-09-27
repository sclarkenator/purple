#-------------------------------------------------------------------
#
# Customer Care Explores
#
#-------------------------------------------------------------------

include: "/views/**/*.view"
include: "/dashboards/**/*.dashboard"

# explore: agent_data {from:  employee_lkp group_label: "Customer Care"} #cj
# explore: cc_call_service_level_csl { description: "Calculated service levels" hidden: yes group_label: "Customer Care" }
# explore: combined_activities {hidden:yes} #cj
# explore: rpt_service_levels { hidden: yes group_label:"Customer Care" description: "Incontact servive level by campaign"}
# explore: shopify_refund {hidden:yes}
# explore: wfh_comparisons {hidden: yes} #cj
# explore: v_missing_customer_deposit {hidden: yes}
# explore: v_retail_orders_without_showroom {hidden:yes}
# explore: v_shopify_refund_status { hidden: yes group_label:"Customer Care" }
# explore: v_zendesk_articles {hidden: yes}
# explore: zendesk_macros {hidden:yes}
# explore: zendesk_sell {hidden:yes} #cj

#####################################################################
#####################################################################
## WFM WEEKLY PERFORMANCE - consolidates performance fields cj

explore: wfm_weekly_performance {
  label: "WFM Weekly Performance Summary"
  group_label: "Customer Care"
  view_label: "Summary Data"
  from: warehouse_date_table
  hidden: yes

  fields: [
    wfm_weekly_performance.default_fields*,
    employee_lkp.agents_minimal_grouping*,
    incontact_phone.performance_summary*,
    zendesk_ticket_v2.ticket_count,
    agent_state.working_rate,
    agent_state.unavailable_pct,
    liveperson_conversation.conversations_ended_count
  ]

  join: employee_lkp {
    view_label: "Employee Lookup"
    type: cross
    relationship: many_to_many
  }

  join: incontact_phone {
    view_label: "Summary Data"
    type: left_outer
    sql_on: ${wfm_weekly_performance.date_date} = ${incontact_phone.start_ts_mst_date}
      and ${employee_lkp.incontact_id} = ${incontact_phone.agent_id} ;;
    relationship: one_to_many
  }

  join: zendesk_ticket_v2 {
    view_label: "Summary Data"
    type: left_outer
    sql_on: ${wfm_weekly_performance.date_date} = ${zendesk_ticket_v2.tkt_created_date}
      and ${employee_lkp.incontact_id} = ${zendesk_ticket_v2.assignee_id}
      and ${zendesk_ticket_v2.channel} in ('email', 'web', 'facebook') ;;
    relationship: one_to_many
  }

  join: agent_state {
    view_label: "Summary Data"
    type: left_outer
    sql_on: ${wfm_weekly_performance.date_date} = ${agent_state.state_start_ts_mst_date}
      and ${employee_lkp.incontact_id} = ${agent_state.agent_id} ;;
    relationship: one_to_many
  }

  join: liveperson_conversation {
    view_label: "Summary Data"
    type: left_outer
    sql_on: ${wfm_weekly_performance.date_date} = ${liveperson_conversation.ended_date}
      and ${employee_lkp.incontact_id} = ${liveperson_conversation.last_agent_id};;
    relationship: one_to_many
  }
}

#####################################################################
#####################################################################
## LIVEPERSON CONVERSATION cj

explore: liveperson_conversations {
  label: "LivePerson Conversations"

  view_label: "Agent Data"
  from: liveperson_agent
  fields: [liveperson_conversations.default_liveperson_agent_linked*,
    liveperson_conversation*
    ]
  hidden: yes

  join: agent_data {
    view_label: "Agent Data"
    type: full_outer
    # fields: [agent_data.agents_minimal_grouping*, -agent_data.agent_name, -agent_data.team_type, -agent_data.team_group]
    sql_on: ${liveperson_conversations.employee_id} = ${agent_data.zendesk_id} ;;
    relationship: one_to_one
  }

  join: liveperson_conversation {
    view_label: "Conversations"
    type: full_outer
    sql_on: ${liveperson_conversations.agent_id} = ${liveperson_conversation.last_agent_id} ;;
    relationship: many_to_one
  }

  # join: liveperson_campaign {
  #   view_label: "Conversations"
  #   type: full_outer
  #   # fields: [liveperson_campaign.campaign_default*]
  #   sql_on: ${liveperson_conversation.campaign_id} = ${liveperson_campaign.campaign_id}
  #     and ${liveperson_conversation.conversation_id} = ${liveperson_campaign.conversation_id};;
  #   relationship: one_to_one
  # }
}

#####################################################################
#####################################################################
## AGENT TEAM HISTORY cj

explore:agent_team_history {
  view_label: "Agent Team History"
  group_label: "Historic Data"
  view_name: agent_team_history
  hidden: yes
  fields: [employee_lkp.name, agent_team_history.incontact_id, agent_team_history.current_team_flag, agent_team_history.start_date, agent_team_history.end_date, agent_team_history.team_name, agent_team_history.team_email]

  join: employee_lkp {
    view_label: "Agent Team History"
    from: employee_lkp
    type: inner
    sql_on: ${agent_team_history.incontact_id} = ${employee_lkp.incontact_id} ;;
    relationship: one_to_many
  }
  }

#####################################################################
#####################################################################
## AGENT ATTENDANCE cj

explore:agent_attendance {
  label: "Agent Attendance"
  view_label: "Agent Data"
  view_name: employee_lkp
  hidden: yes

  join: agent_attendance {
    view_label: "Attendance Data"
    from: cc_agent_attendance
    type: left_outer
    sql_on: ${employee_lkp.incontact_id} = ${agent_attendance.incontact_id} ;;
    sql_where: ${agent_attendance.added_by} is not null ;;
    relationship: one_to_many
  }

  join: agent_current_warning_level {
    view_label: "Attendance Data"
    fields: [agent_current_warning_level.warning_level, agent_current_warning_level.current_points]
    type: left_outer
    sql_on: ${employee_lkp.incontact_id} = ${agent_current_warning_level.incontact_id}
      and ${employee_lkp.incontact_id} is not null
      and ${employee_lkp.incontact_id} <> '2612383' ;;
    relationship: one_to_one
  }

  join: agent_team_history {
    view_label: "Agent Data"
    # from: agent_team_history
    type: left_outer
    sql_on:  ${employee_lkp.incontact_id} = ${agent_team_history.incontact_id}
      and ${agent_attendance.event_date_date} between ${agent_team_history.start_date} and ${agent_team_history.end_date} ;;
    fields: [agent_team_history.start_date, agent_team_history.end_date, agent_team_history.team_email, agent_team_history.team_name, agent_team_history.current_team_flag]
    relationship: many_to_one
  }
}

#####################################################################
#####################################################################
# AGENT STATE cj

# explore: agent_state {
#   view_label: "Agent States"
#   hidden: yes

#   join: employee_lkp {
#     view_label: "Agent Data"
#     type: left_outer
#     sql_on: ${agent_state.agent_id} = ${employee_lkp.incontact_id} ;;
#     # and cast(${agent_state.state_start_ts_mst_date} as date) between ${agent_data.team_begin_date} and ${agent_data.team_end_date} ;;
#     relationship: many_to_one
#   }

#   join: agent_team_history {
#     view_label: "Agent Data"
#     # from: agent_team_history
#     type: left_outer
#     sql_on:  ${employee_lkp.incontact_id} = ${agent_team_history.incontact_id}
#       and ${agent_state.state_start_ts_mst_date} between ${agent_team_history.start_date} and ${agent_team_history.end_date}  ;;
#     relationship: many_to_one
#   }
# }

#####################################################################
#####################################################################
## CONTACT HISTORY cj

explore: contact_history {
   view_label: "Contact History"
   hidden:yes

   join: employee_lkp {
     view_label: "Agent Data"
     type: left_outer
     sql_on: ${contact_history.agent_id} = ${employee_lkp.incontact_id} ;;
     relationship: many_to_one
   }

 join: agent_state {
   view_label: "Agent State"
   # from: agent_team_history
   type: left_outer
   sql_on:  ${contact_history.agent_id} = ${agent_state.agent_id} ;;
   relationship: many_to_one
 }
}

#####################################################################
#####################################################################
# HEADCOUNT V2 cj

explore: headcount_v2 {
  view_label: "Headcount"
  view_name: headcount
  hidden: yes

  join: agent_state {
    view_label: "Headcount"
    type: left_outer
    fields: [agent_state.state_percentage, working_rate]
    sql_on: ${headcount.incontact_id} = ${agent_state.agent_id}
      and cast(${headcount.date_date} as date) = cast(${agent_state.state_start_ts_utc_date} as date) ;;
    relationship: one_to_many
  }

  sql_always_where: ${headcount.team_group} <> 'Other' ;;
}

#####################################################################
#####################################################################
# INCONTACT PHONE cj

explore: incontact_phone {
  label: "InContact Phone"
  view_label: "Agent Data"
  description: "Tracks phone related contact data."
  view_name: employee_lkp
  hidden: yes

  join: incontact_phone {
    view_label: "Phone Calls"
    type: full_outer
    sql_on: ${employee_lkp.incontact_id} = ${incontact_phone.agent_id} ;;
    relationship: one_to_many
  }
}

#####################################################################
#####################################################################
## PERFECT ATTENDANCE cj

explore: perfect_attendance_calc {

  view_label: "Agent Attendance"
  view_name: cc_agent_attendance
  hidden: yes
  fields: [employee_lkp.name, employee_lkp.is_active, employee_lkp.retail, employee_lkp.inactive_date, employee_lkp.is_supervisor, employee_lkp.team_type, cc_agent_attendance.event_date_month, cc_agent_attendance.occurrence_count]

  join: employee_lkp {
    view_label: "Agent Attendance"
    from: employee_lkp
    type: inner
    sql_on: ${cc_agent_attendance.incontact_id} = ${employee_lkp.incontact_id} ;;
    relationship: one_to_many
  }
}

#####################################################################
#####################################################################

  explore: customer_satisfaction_survey {
    label: "Agent CSAT"
    group_label: "Customer Care"
    hidden: yes
    description: "Customer satisfaction of interactions with Customer Care agents"
    join: employee_lkp {
      type: left_outer
      sql_on: ${customer_satisfaction_survey.agent_id} = ${employee_lkp.incontact_id} ;;
      relationship: many_to_one
    }
    join: team_lead_name {
      type:  left_outer
      sql_on:  ${team_lead_name.incontact_id}=${employee_lkp.incontact_id}
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

#####################################################################
#####################################################################

  # explore: refund_mismatch {
  #   label: "Refund Mismatch"
  #   group_label: "Customer Care"
  #   hidden: yes
  #   description: "NetSuite refunds missing in Shopify"
  # }

#####################################################################
#####################################################################

  # explore: shopify_net_payment {
  #   label: "Shopify Net Payment"
  #   group_label: "Customer Care"
  #   hidden: yes
  #   description: "Shopify Orders with Customer's Net Payment Under $10"
  # }


#####################################################################
#####################################################################

  explore: rma_status_log {
    label: "RMA Status Log"
    group_label: "Customer Care"
    description: "Log of RMA status change"
    join: item {
      type: left_outer
      sql_on: ${rma_status_log.item_id} = ${item.item_id} ;;
      relationship: many_to_one}
  }


#####################################################################
#####################################################################

  # explore: zendesk_chats {
  #   label: "Zendesk Website Chats"
  #   group_label: "Customer Care"
  #   hidden: yes
  #   join: zendesk_chat_engagements {
  #     view_label: "Zendesk Chat Engagements"
  #     type: left_outer
  #     sql_on: ${zendesk_chats.chat_id} = ${zendesk_chat_engagements.chat_id} ;;
  #     relationship: one_to_many
  #     }
  #     join: employee_lkp {
  #       type: left_outer
  #       view_label: "Agent Lookup"
  #       sql_on: ${zendesk_chat_engagements.zendesk_id}=${employee_lkp.zendesk_id}  ;;
  #       relationship: many_to_one
  #     }
  #   join: team_lead_name {
  #     type:  left_outer
  #     view_label: "Agent Lookup"
  #     sql_on:  ${team_lead_name.incontact_id}=${employee_lkp.incontact_id}
  #       AND ${team_lead_name.start_date}<=${zendesk_chat_engagements.engagement_start_date}
  #       AND ${team_lead_name.end_date}>=${zendesk_chat_engagements.engagement_start_date};;
  #     relationship: many_to_one
  #     }
  #   }
#####################################################################
#####################################################################

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
  join: employee_lkp {
    type: left_outer
    view_label: "Agent Lookup"
    sql_on: ${user.id}=${employee_lkp.zendesk_id} ;;
    relationship: many_to_one
  }
  join: team_lead_name {
    type:  left_outer
    view_label: "Agent Lookup"
    sql_on:  ${team_lead_name.incontact_id}=${employee_lkp.incontact_id}
        AND ${team_lead_name.start_date}<=${zendesk_ticket.created_date}
        AND ${team_lead_name.end_date}>=${zendesk_ticket.created_date};;
    relationship: many_to_one
  }
}

#####################################################################
#####################################################################

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
    join: employee_lkp {
      type: left_outer
      view_label: "Agent Lookup"
      sql_on: ${rpt_skill_with_disposition_count.agent_id}=${employee_lkp.incontact_id} ;;
      relationship: many_to_one
    }
    join: team_lead_name {
      type:  left_outer
      view_label: "Agent Lookup"
      sql_on:  ${team_lead_name.incontact_id}=${employee_lkp.incontact_id}
        AND ${team_lead_name.start_date}<=${rpt_skill_with_disposition_count.reported_date}
        AND ${team_lead_name.end_date}>=${rpt_skill_with_disposition_count.reported_date};;
      relationship: many_to_one
    }
  }

#####################################################################
#####################################################################

  # explore: agent_lkp {
  #   view_name: employee_lkp
  #   hidden: yes
  #   label: "Agents"
  #   group_label: "Customer Care"
  #   join: agent_company_value {
  #     type: full_outer
  #     sql_on: ${employee_lkp.incontact_id} = ${agent_company_value.agent_id} ;;
  #     relationship: one_to_many}
  #   join: agent_evaluation {
  #     type: full_outer
  #     sql_on: ${employee_lkp.incontact_id} = ${agent_evaluation.evaluated_id} ;;
  #     relationship: one_to_many}
  #   join: rpt_agent_stats {
  #     type: full_outer
  #     sql_on: ${employee_lkp.incontact_id} = ${rpt_agent_stats.agent_id} ;;
  #     relationship: one_to_many}
  #   join: v_agent_state {
  #     type: full_outer
  #     sql_on: ${employee_lkp.incontact_id} = ${v_agent_state.agent_id} ;;
  #     relationship: one_to_many}
  #   join: agent_attendance{
  #     type: full_outer
  #     sql_on: ${employee_lkp.incontact_id} = ${agent_attendance.agent_id} ;;
  #     relationship: one_to_many}
  #   join: agent_draft_orders {
  #     type: left_outer
  #     sql_on: ${employee_lkp.shopify_id} = ${agent_draft_orders.user_id} ;;
  #     relationship: one_to_many}
  #   join: customer_satisfaction_survey {
  #     type: full_outer
  #     sql_on: ${employee_lkp.incontact_id}::string = ${customer_satisfaction_survey.agent_id}::string ;;
  #     relationship:  one_to_many
  #   }
  #   join: team_lead_name {
  #     type:  left_outer
  #     sql_on:  ${team_lead_name.incontact_id}=${employee_lkp.incontact_id}
  #         AND ${team_lead_name.start_date}<=${customer_satisfaction_survey.created_date}
  #         AND ${team_lead_name.end_date}>=${customer_satisfaction_survey.created_date};;
  #     relationship: many_to_one
  #   }
  #   required_access_grants: [is_customer_care_manager]
  # }

#####################################################################
#####################################################################

  # explore: cc_agent_data {
  #   hidden: yes
  #   from:  employee_lkp
  #   label: "CC Agent Data"
  #   group_label: "Customer Care"

  #   join: agent_company_value {
  #     type: full_outer
  #     sql_on: ${cc_agent_data.incontact_id} = ${agent_company_value.agent_id} ;;
  #     relationship: one_to_many}

  #   join: agent_evaluation {
  #     type: full_outer
  #     sql_on: ${cc_agent_data.incontact_id} = ${agent_evaluation.evaluated_id};;
  #     relationship: one_to_many}

  #   join: rpt_agent_stats {
  #     type: full_outer
  #     sql_on: ${cc_agent_data.incontact_id} = ${rpt_agent_stats.agent_id} ;;
  #     relationship: one_to_many}

  #   join: agent_attendance{
  #     type: full_outer
  #     sql_on: ${cc_agent_data.incontact_id} = ${agent_attendance.agent_id} ;;
  #     relationship: one_to_many}

  #   join: agent_draft_orders {
  #     type: left_outer
  #     sql_on: ${cc_agent_data.shopify_id} = ${agent_draft_orders.user_id} ;;
  #     relationship: one_to_many}

  #   join: v_agent_state {
  #     type: full_outer
  #     sql_on:  ${cc_agent_data.incontact_id}= ${v_agent_state.agent_id};;
  #     relationship:  one_to_many}

  #   join: customer_satisfaction_survey {
  #     type: left_outer
  #     sql_on: ${cc_agent_data.incontact_id} = ${customer_satisfaction_survey.agent_id}  ;;
  #     relationship:  one_to_many}

  #   join: team_lead_name {
  #     type:  left_outer
  #     sql_on:  ${team_lead_name.incontact_id}=${cc_agent_data.incontact_id}
  #       and  ${team_lead_name.end_date}::date > '2089-12-31'::date;;
  #     #and ${cc_agent_data.created_date}::date >= ${team_lead_name.start_date}::date;;
  #     relationship: one_to_one
  #   }
  #   join: agent_lkp_eval {
  #     from: employee_lkp
  #     relationship: many_to_one
  #     type: left_outer
  #     sql_on: ${agent_lkp_eval.incontact_id} = ${agent_evaluation.evaluator_id};;
  #     view_label: "Agent Evaluation Team"
  #     fields: [agent_lkp_eval.name, agent_lkp_eval.email, agent_lkp_eval.is_supervisor]
  #   }
  #   # join: agent_data {
  #   #   type: full_outer
  #   #   sql_on: ${cc_agent_data.incontact_id} = ${agent_data.incontact_id} ;;
  #   #   relationship: one_to_many
  #   # }
  #   join: agent_state {
  #     type:  full_outer
  #     sql_on: ${cc_agent_data.incontact_id} = ${agent_state.agent_id} ;;
  #     relationship: one_to_many
  #   }
  #   join: labor_hours {
  #     type: left_outer
  #     sql_on: ${cc_agent_data.workday_id} = ${labor_hours.employee_id} ;;
  #     relationship: one_to_many
  #   }
  #   required_access_grants: [is_customer_care_manager]
  # }

#####################################################################
#####################################################################

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
    join: zendesk_sell {
      type: left_outer
      sql_on: ${agent_name.incontact_id}=${zendesk_sell.contact_id} ;;
      relationship: one_to_one
    }
  }

#####################################################################
#####################################################################

  # explore: cc_activities {hidden: yes group_label: "Customer Care"
  #   join: employee_lkp {
  #     type: left_outer
  #     view_label: "Agent Lookup"
  #     sql_on: ${cc_activities.incontact_id}=${employee_lkp.incontact_id} ;;
  #     relationship: many_to_one
  #   }
  #   join: team_lead_name {
  #     type:  left_outer
  #     view_label: "Agent Lookup"
  #     sql_on:  ${team_lead_name.incontact_id}=${employee_lkp.incontact_id}
  #       and  ${team_lead_name.end_date}::date > '2089-12-31'::date;;
  #     relationship: many_to_one
  #   }
  #   join: labor_hours {
  #     type: left_outer
  #     sql_on: ${employee_lkp.workday_id} = ${labor_hours.employee_id} ;;
  #     relationship: one_to_many
  #   }
  # }

#####################################################################
#####################################################################

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

#####################################################################
#####################################################################

  explore: cc_traffic { hidden: yes
    join:bridge_by_agent {
      type: left_outer
      relationship: many_to_one
      view_label: "Bridge Courses"
      sql_on: ${bridge_by_agent.email} = ${cc_traffic.agent_email};;
    }
  }

#####################################################################
#####################################################################

  explore: orphan_orders {
    hidden:  yes
    group_label: "Customer Care"
    label: "Orphan orders"
    description: "Orders that exist in Shopify that aren't yet in Netsuite"
  }

#####################################################################
#####################################################################

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
    join: employee_lkp {
      view_label: "Team Lead"
      type: left_outer
      sql_on: ${team_lead_name.incontact_id} = ${employee_lkp.incontact_id} ;;
      relationship: many_to_one
    }
  }


## DEPRECATED EXPLORES

  #explore: v_internal_order_form {hidden: yes}
  # explore: video_sales_drafts {hidden: yes} #cj
  # explore: liveperson_conversation_metrics {hidden:yes} #cj
  # explore: liveperson_consumer_participant {hidden:yes} #cj
  # explore: liveperson_profile {hidden: yes} #cj
  # explore: activities_all_sources {hidden: yes} #cj
  # explore: liveperson_agent {hidden: yes} #cj
  # explore: liveperson_skill {hidden: yes} #cj
  # explore: agent_current_warning_level {hidden: yes} #cj
  # explore:  bridge_by_agent {}
  # explore: agent_company_value {  hidden: yes  label: "Agent Company Value"  group_label: "Customer Care"}
  # explore: agent_evaluation {  hidden: yes  label: "Agent Evaluation"  group_label: "Customer Care"}
  # explore: agent_attendance {  hidden: yes  label: "Agent Attendance"  group_label: "Customer Care"}
  # explore: v_agent_state  { hidden:  yes  label: "Agent Time States"  group_label: "Customer Care"}
  # explore: zendesk_sell_contact {hidden:yes group_label: "Customer Care"}
  # explore: zendesk_sell_deal {hidden:yes group_label: "Customer Care"}
  # explore: zendesk_sell_user {hidden:yes group_label: "Customer Care"}
  # explore: v_mismatch_rma {hidden: yes group_label:"Customer Care" description:"This is used by the CSR team to find RMA number they need to fix on the return form."}
  # explore: zendesk_sell_user_active {hidden:yes group_label:"Customer Care" description: "Compares Agents in Zendesk Sell and Zendesk."}
  # explore: zendesk_sell_user_active {hidden:yes group_label:"Customer Care" description: "Compares Agents in Zendesk Sell and Zendesk."}
  # explore: zendesk_sell_user_active {hidden:yes group_label:"Customer Care" description: "Compares Agents in Zendesk Sell and Zendesk."}


#####################################################################
#####################################################################
## LIVEPERSON AGENT STATUS cj

# explore: lp_agent_status {
#   label: "LivePerson Agent Status"
#   view_label: "Agent Data"
#   group_label: "Customer Care"
#   hidden: yes
#   from: agent_data
#   fields: [lp_agent_status.agents_minimal_grouping*,
#     liveperson_agent_status.default_agent_status*,
#     liveperson_agent_status.agent_count,
#     liveperson_agent_status_type*,
#     liveperson_agent_status_subtype*,
#     liveperson_agent_status.agent_status_count]

#   join: liveperson_agent_status {
#     view_label: "Agent Status"
#     from: liveperson_agent_status
#     type: left_outer
#     sql_on: ${lp_agent_status.liveperson_id} = ${liveperson_agent_status.agent_id} ;;
#     relationship: one_to_many
#   }

#   # join: liveperson_agent_status_type {
#   #   view_label: "Agent Status"
#   #   type: left_outer
#   #   sql_on: ${liveperson_agent_status.type_id} = ${liveperson_agent_status_type.type_id};;
#   #   relationship: many_to_one
#   # }

#   # join: liveperson_agent_status_subtype {
#   #   view_label: "Agent Status"
#   #   type: left_outer
#   #   sql_on: ${liveperson_agent_status.subtype_id} = ${liveperson_agent_status_subtype.subtype_id};;
#   #   relationship: many_to_one
#   # }
# }

#####################################################################
#####################################################################
## LIVEPERSON COMBINED cj

# explore: liveperson_combined {
#   description: "Combined LivePerson data"
#   hidden: yes

#   join: agent_data {
#     view_label: "Conversation Last Agent Data"
#     type: left_outer
#     sql_on: ${liveperson_combined.last_agent_id} = ${agent_data.liveperson_id} ;;
#     relationship: many_to_one
#   }

#   join: liveperson_conversation_metrics {
#     view_label: "Conversation Data"
#     type: full_outer
#     sql_on: ${liveperson_combined.conversation_id} = ${liveperson_conversation_metrics.conversation_id} ;;
#     relationship: one_to_one
#   }

#   # join: liveperson_message {
#   #   view_label: "Message Data"
#   #   type: full_outer
#   #   sql_on: ${liveperson_combined.conversation_id} = ${liveperson_message.conversation_id}
#   #       and ${liveperson_combined.conversation_dates_date} = ${liveperson_message.created_ts_date_date}
#   #       ;;
#   #   relationship: one_to_many
#   # }

#   # join: liveperson_agent_status?
# }

#####################################################################
#####################################################################
## LIVEPERSON COMBINED DATA cj OLD

  # explore: liveperson_combined_data {
  #   label: "LivePerson"
  #   group_label: "Customer Care"
  #   description: "Combined LivePerson data"
  #   view_label: "Agent Data (Conversation Level)"
  #   from: liveperson_agent
  #   hidden: yes

  #   fields: [liveperson_combined_data.default_liveperson_agent_linked*,
  #     warehouse_date_table.default_fields*,
  #     # liveperson_message*,
  #     # liveperson_agent_message.default_liveperson_agent_linked*,
  #     # liveperson_agent_status*,
  #     # -liveperson_message.created_ts_date,
  #     # -liveperson_message.created_ts_day_of_week,
  #     # -liveperson_message.created_ts_month,
  #     # -liveperson_message.created_ts_quarter,
  #     # -liveperson_message.created_ts_week,
  #     # -liveperson_message.created_ts_year
  #     liveperson_conversation*
  #   ]

  #   join: warehouse_date_table {
  #     view_label: "* Dates"
  #     type: cross
  #     sql_where: ${warehouse_date_table.date_date} >= '2021-08-01' ;; # Liveperson rollout/testing started 8/5/2021
  #     relationship: many_to_many
  #   }

  #   join: agent_data {
  #     view_label: "Agent Data (Conversations Level)"
  #     type: full_outer
  #     sql_on: ${liveperson_combined_data.employee_id} = ${agent_data.zendesk_id} ;;
  #     relationship: one_to_one
  #   }

  #   # join: liveperson_agent_status {
  #   #   view_label: "Agent Status"
  #   #   type: full_outer
  #   #   sql_on: ${warehouse_date_table.date_date}::date = ${liveperson_agent_status.status_change_date}::date
  #   #       and ${agent_data.liveperson_id} = ${liveperson_agent_status.agent_id} ;;
  #   #   relationship: one_to_many
  #   # }

  #   join: liveperson_conversation {
  #     view_label: "Conversations"
  #     type: full_outer
  #     sql_on: ${liveperson_combined_data.agent_id} = ${liveperson_conversation.last_agent_id}
  #         and ${warehouse_date_table.date_date}::date >= ${liveperson_conversation.started_date}
  #           and (${warehouse_date_table.date_date}::date <= ${liveperson_conversation.ended_date}
  #             or ${liveperson_conversation.ended_date} is null) ;;
  #     relationship: many_to_one
  #   }

  #   # join: liveperson_message {
  #   #   view_label: "Messages"
  #   #   type: full_outer
  #   #   sql_on: ${liveperson_conversation.conversation_id} = ${liveperson_message.conversation_id}
  #   #       and ${liveperson_conversation.conversation_dates_date}::date = ${liveperson_message.created_ts_date}::date ;;
  #   #   relationship: many_to_many
  #   # }

  #   # join: liveperson_agent_message {
  #   #   view_label: "Agent Data (Messages Level)"
  #   #   from: liveperson_agent
  #   #   type: full_outer
  #   #   sql_on: ${liveperson_agent_message.agent_id} = ${liveperson_agent_message.agent_id} ;;
  #   #   relationship: many_to_one
  #   # }
  # }

  # explore: agent_stats_w_agent{ #cj
  #   hidden: yes
  #   label: "Agent Stats w/ Agent Data"
  #   view_label: "Agent Data"
  #   group_label: "Customer Care"
  #   description: "From InContact Agent Stats Daily."
  #   from: agent_data

  #   join: rpt_agent_stats {
  #     view_label: "Agent Stats"
  #     sql_on: ${agent_stats_w_agent.incontact_id} = ${rpt_agent_stats.agent_id} ;;
  #     type: left_outer
  #     relationship: one_to_many
  #   }
  # }

  # explore: conversion_wfh {
  #   view_label: "Date Table"
  #   hidden: yes
  #   from: warehouse_date_table

  #   join: cc_activities {
  #     view_label: "CC Activities"
  #     type: left_outer
  #     relationship: many_to_one
  #     sql_on: ${conversion_wfh.date_date} = ${cc_activities.activity_date} ;;
  #   }

  #   join: agent_data {
  #     view_label: "Agent Data"
  #     type: left_outer
  #     relationship: many_to_one
  #     sql_on: ${cc_activities.incontact_id} = ${agent_data.incontact_id} ;;
  #   }

  #   join: cc_deals {
  #     view_label: "cc_deals"
  #     type: left_outer
  #     relationship: one_to_many
  #     sql_on: ${conversion_wfh.date_date} = ${cc_deals.created_date}
  #       and ${agent_data.zendesk_sell_id} = ${cc_deals.user_id} ;;
  #   }

  #   join: zendesk_sell {
  #     view_label: "Zendesk Sell"
  #     type: left_outer
  #     relationship: one_to_many
  #     sql_on: ${conversion_wfh.date_date} = ${zendesk_sell.deal_created}
  #       and ${agent_data.zendesk_sell_id} = ${zendesk_sell.user_id} ;;
  #     sql_where: ${zendesk_sell.inside_sales_order} = true ;;
  #   }

  #   join: sales_order {
  #     view_label: "Sales Order"
  #     type: left_outer
  #     relationship: one_to_one

  #     sql_on: ${zendesk_sell.order_id}=${sales_order.order_id}
  #       and ${sales_order.system}='NETSUITE'
  #       and ${sales_order.is_exchange_upgrade_warranty} = false;;
  #     # sql_on: ${conversion_wfh.date_date} = ${sales_order.created_date}
  #     #   and ${zendesk_sell.zendesk_id} = ${sales_order.created_by_id} ;;
  #     # sql_where: ${sales_order.is_exchange_upgrade_warranty} = false;;
  #     }

  #   # join: sales_order_line {
  #   #   view_label: "Sales Order Line"
  #   #   type: left_outer
  #   #   relationship: one_to_many
  #   #   sql_on: ${sales_order.order_id} = ${sales_order_line.order_id} ;;
  #   # }
  # }

  # explore: liveperson_conversation_transfer{
  #   hidden: yes

  #   join: agent_data {
  #     type: left_outer
  #     view_label: "Agent Data"
  #     sql_on: ${liveperson_conversation_transfer.transfered_by_id}=${agent_data.liveperson_id} ;;
  #     relationship: many_to_one
  #   }
  # }

  ## cj
  # explore: sales_draft_data {
  #   hidden: yes
  #   from:  agent_data
  #   view_label: "Agent Data"
  #   group_label: "Customer Care"
  #   fields: [sales_draft_data.agents_minimal_grouping*,
  #     agent_draft_orders*]

  #   join: agent_draft_orders {
  #     view_label: "Draft Orders"
  #     type: full_outer
  #     sql_on: ${sales_draft_data.shopify_id} = ${agent_draft_orders.user_id} ;;
  #     relationship: one_to_many}

  #   required_access_grants: [is_customer_care_manager]
  # }

  # explore: contact_refusals {
  #   view_label: "InContact Call Refusals"
  #   hidden: yes
  #   view_name: contact_history
  #   sql_always_where: ${contact_history.contact_state_name} = 'Refused' ;;

  #   join: agent_data {
  #     view_label: "Agent Data"
  #     type: left_outer
  #     sql_on: ${contact_history.agent_id} = ${agent_data.incontact_id} ;;
  #     relationship: many_to_one
  #   }
  # }


  # explore: rpt_agent_stats {
  #   hidden: yes
  #   label: "InContact Agent Stats"
  #   group_label: "Customer Care"
  #   description: "From InContact Agent Stats Daily."
  # }

    # explore: shopify_coupon_code {
  #   label: "Shopify Coupon Code"
  #   group_label: "Customer Care"
  #   hidden: yes
  #   description: "Shopify Orders with Coupon Code"
  # }

#####################################################################
#####################################################################
## CC_KPIs cj

# explore: CC_KPIs {

#   label: "CC KPIs"
#   view_name: employee_lkp
#   view_label: "Agent Data"
#   hidden: yes

#   join: zendesk_ticket {
#     view_label: "Zendesk Tickets"
#     type: left_outer
#     sql_on: ${employee_lkp.zendesk_id} = ${zendesk_ticket.assignee_id} ;;
#     relationship: many_to_one
#   }

#   join: zendesk_chat_engagements {
#     view_label: "Chat Engagement"
#     type: left_outer
#     sql_on: ${zendesk_ticket.ticket_id} = ${zendesk_chat_engagements.ticket_id} ;;
#     relationship: many_to_one
#   }
# }

  # explore: amazon_orphan_orders {
  #   label: "Amazon Orphan Orders"
  #   group_label: "Customer Care"
  #   hidden: yes
  #   description: "Amazon orders not showing up in Netsuite"
  # }

    # explore: daily_disposition_counts {
  #   group_label: "Customer Care"
  #   description: "Count of tickets and calls by disposition"
  #   hidden: yes
  # }

#####################################################################
#####################################################################
## LIVEPERSON MESSAGES cj

# explore: liveperson_messages {
#   label: "LivePerson Message"
#   view_label: "Agent Data"
#   from: liveperson_agent
#   hidden: yes
#   fields: [
#     # liveperson_messages.agent_name_cc_lp
#     # ,liveperson_messages.agent_name
#     agent_data*
#     ,liveperson_message*]

#   join: agent_data {
#     view_label: "Agent Data"
#     type: left_outer
#     sql_on: ${liveperson_message.liveperson_id} = ${agent_data.liveperson_id} ;;
#     relationship: one_to_one
#     fields: [agents_minimal_grouping*, -agent_name]
#   }

#   join: liveperson_message {
#     view_label: "Messages"
#     type: full_outer
#     sql_on: len(${liveperson_message.participant_id}) = 10
#       and ${liveperson_messages.agent_id}::text = ${liveperson_message.liveperson_id} ;;
#     relationship: one_to_many
#     # fields: [*]
#   }
# }
