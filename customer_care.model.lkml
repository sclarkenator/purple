#-------------------------------------------------------------------
# Model Header Information
#-------------------------------------------------------------------



connection: "analytics_warehouse"

include: "*.view.lkml"                       # include all views in this project
include: "customer_care.model.lkml"
#include: "my_dashboard.dashboard.lookml"   # include a LookML dashboard called my_dashboard

week_start_day: sunday



#-------------------------------------------------------------------
# Customer Care [CC] explores
#-------------------------------------------------------------------

explore: customer_satisfaction_survey {
  label: "Agent CSAT"
  group_label: "Customer Care"
  hidden: yes
  description: "Customer satisfaction of interactions with Customer Care agents"
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

explore: ticket {
  hidden: yes
  group_label: "Customer Care"
  label: "Zendesk Tickets"
  description: "Customer ticket details from Zendesk"
  join: group {
    type: full_outer
    sql_on: ${group.id} = ${ticket.group_id} ;;
    relationship: many_to_one
  }
  join: user {
    view_label: "Assignee"
    type: left_outer
    sql_on: ${user.id} = ${ticket.assignee_id} ;;
    relationship: many_to_one
  }
#     join: ticket_form_history {
#       type: full_outer
#       sql_on: ${group.id} = ${ticket.group_id} ;;
#       relationship: many_to_one
#     }
}

explore: daily_disposition_counts {
  group_label: "Customer Care"
  description: "Count of tickets and calls by disposition"
  hidden: yes
}

explore: agent_lkp {
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
  join: agent_attendance{
    type: full_outer
    sql_on: ${agent_lkp.incontact_id} = ${agent_attendance.agent_id} ;;
    relationship: one_to_many}
  join: agent_draft_orders {
    type: left_outer
    sql_on: ${agent_lkp.shopify_id} = ${agent_draft_orders.user_id} ;;
    relationship: one_to_many}
  required_access_grants: [is_customer_care_manager]
}

access_grant: is_customer_care_manager{
  user_attribute: is_customer_care_manager
  allowed_values: [ "yes" ]
}


explore: cc_agent_data {
  from:  agent_lkp
  label: "CC Agent Data"
  group_label: "Customer Care"

  join: agent_company_value {
    type: full_outer
    sql_on: ${cc_agent_data.incontact_id} = ${agent_company_value.agent_id} ;;
    relationship: one_to_many}
  join: agent_evaluation {
    type: full_outer
    sql_on: ${cc_agent_data.incontact_id} = ${agent_evaluation.evaluated_id} ;;
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
    sql_on:  ${cc_agent_data.incontact_id}= ${v_agent_state.AGENT_ID};;
    relationship:  one_to_many
  }
  required_access_grants: [is_customer_care_manager]
}

explore: agent_company_value {
  hidden: yes
  label: "Agent Company Value"
  group_label: "Customer Care"
}

explore: agent_evaluation {
  hidden: yes
  label: "Agent Evaluation"
  group_label: "Customer Care"
}

explore: agent_attendance {
  hidden: yes
  label: "Agent Attendance"
  group_label: "Customer Care"
}

explore: v_agent_state  {
  hidden:  yes
  label: "Agent Time States"
  group_label: "Customer Care"
}


#    explore: rpt_skill_with_disposition_count {
#      #hidden: yes
#      group_label: "Customer Care"
#      label: "Disposition Volume"
#      description: "Call and ticket volume by disposition from Zendesk and InContact"
#      join: ticket {
#        type: full_outer
#        relationship: many_to_many
#        sql_on: lower(${rpt_skill_with_disposition_count.disposition}) = lower(${ticket.custom_disposition})
#                and ${rpt_skill_with_disposition_count.reported_date} = ${ticket.created_at_date};;
#      }
#      join: group {
#        type: full_outer
#        required_joins: [ticket]
#        sql_on: ${group.id} = ${ticket.group_id} ;;
#        relationship: many_to_one
#      }
#    }







# # Select the views that should be a part of this model,
# # and define the joins that connect them together.
#
# explore: order_items {
#   join: orders {
#     relationship: many_to_one
#     sql_on: ${orders.id} = ${order_items.order_id} ;;
#   }
#
#   join: users {
#     relationship: many_to_one
#     sql_on: ${users.id} = ${orders.user_id} ;;
#   }
# }
