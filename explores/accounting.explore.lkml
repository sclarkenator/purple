#-------------------------------------------------------------------
#
# Accounting Explores
#
#-------------------------------------------------------------------
include: "/views/**/*.view"
include: "/dashboards/**/*.dashboard"

  # It appears this explore doesn't have the underlying views. Disabling it on 6/14/22
  # explore: finance_bill{
  #   hidden: yes
  #   group_label: "Accounting"
  #   label: "Finance Bill Items"
  #   description: "A joined view of finance bill headers and bill line items"
  #   join: finance_bill_line {
  #     type: left_outer
  #     sql_on: ${finance_bill.bill_id}=${finance_bill_line.bill_id} ;;
  #     relationship: one_to_many
  #   }
  #   join: finance_bill_payment {
  #     type:  inner
  #     sql_on: ${finance_bill.bill_id}=${finance_bill_payment.bill_payment_id} ;;
  #     relationship: one_to_one
  #   }
  #   join: finance_bill_payment_line {
  #     type: full_outer
  #     sql_on: ${finance_bill.bill_id}=${finance_bill_payment_line.bill_payment_id} ;;
  #     relationship:  one_to_many
  #   }
  #   join: account {
  #     view_label: "Account"
  #     type: left_outer
  #     sql_on: ${finance_bill_line.account_id} = ${account.account_id};;
  #     relationship:  many_to_one
  #   }
  #   join: accounting_period {
  #     view_label: "Accounting Period"
  #     type: left_outer
  #     sql_on: ${finance_bill.accounting_period_id} = ${accounting_period.accounting_period_id} ;;
  #     relationship:  many_to_one
  #   }
  #   join: entity {
  #     view_label: "Entity"
  #     type: left_outer
  #     sql_on: ${finance_bill.entity_id} = ${entity.entity_id} ;;
  #     relationship: many_to_many
  #   }
  # }

  # explore: v_gift_card {
  #   label: "Gift Card Transactions"
  #   group_label: "Accounting"
  #   hidden:yes
  #   join: sales_order {
  #     type: left_outer
  #     sql_on:  ${sales_order.related_tranid} = ${v_gift_card.order_number} ;;
  #     relationship: one_to_one}
  # }

  # explore: warranty_timeline {
  #   label: "Warranty Timeline"
  #   group_label: "Accounting"
  #   hidden:yes
  #   join: item {
  #     view_label: "Item"
  #     type:  left_outer
  #     sql_on: ${item.item_id} = ${warranty_timeline.item_id};;
  #     relationship: many_to_one}
  # }

  explore: affirm_daily_lto_funnel {hidden:yes group_label: "Accounting"}
  # explore: v_affirm_order_num {label: "Affirm Order Numbers" group_label: "Accounting" hidden:yes}
  # explore: v_amazon_order_num {label: "Amazon Order Numbers" group_label: "Accounting" hidden:yes}
  # explore: v_affirm_to_netsuite {label: "Affirm to Netsuite" group_label: "Accounting" hidden:yes}
  # explore: v_shopify_payment_to_netsuite {label: "Shopify Payment to Netsuite" group_label: "Accounting" hidden:yes}
  # explore: v_amazon_pay_to_netsuite {label: "Amazon Pay to Netsuite" group_label: "Accounting" hidden:yes}
  # explore: v_stripe_to_netsuite {label: "Amazon Pay to Netsuite" group_label: "Accounting" hidden:yes}
  # explore: v_shopify_gift_card {label: "Shopify Gift Card Transactions" group_label: "Accounting" hidden:yes}
  # explore: v_scc_sales {label: "Sleep Country Canada Sales" group_label: "Accounting" hidden:yes}
  # explore: v_paypal {hidden: yes group_label: "Accounting"}
  # explore: v_fit_paypal {hidden: yes group_label: "Accounting"}
  # explore: v_firstdata {label: "FirstData" group_label: "Accounting" hidden:yes}
  # explore: v_fit_first_data {hidden: yes group_label: "Accounting"}
  # explore: v_fit_amazon {hidden: yes group_label: "Accounting"}
  # explore: v_fit_axomo { hidden: yes group_label: "Accounting"}
  # explore: v_fit_shopify_payment {hidden: yes group_label: "Accounting"}
  # explore: v_fit_stripe {hidden: yes group_label: "Accounting"}
  # explore: v_splitit {hidden: yes group_label: "Accounting"}
  explore: splitit {hidden: yes group_label: "Accounting" description:"The date filter will change the date range in the SQL query."}
  # explore: fit_first_data {hidden: yes group_label: "Accounting"}
  # explore: katapult {hidden: yes group_label: "Accounting"}

  explore: v_fit_affirm {hidden: yes group_label: "Accounting"
    join: v_fit_affirm_details {
      view_label: "Affirm Details"
      type: left_outer
      relationship: one_to_many
      sql_on: ${v_fit_affirm.affirm_id} = ${v_fit_affirm_details.h_id} ;;
    }
    join: v_fit_affirm_ns_details {
      view_label: "Netsuite Details"
      type: left_outer
      relationship: one_to_many
      sql_on: ${v_fit_affirm.order_number} = ${v_fit_affirm_ns_details.order_number} ;;
    }
  }



#-------------------------------------------------------------------
#
# Netsuite by Fivetran Explores
# https://looker.com/platform/blocks/source/netsuite-by-fivetran
# Created by Blake Walton 2020-11-30
#-------------------------------------------------------------------

# fiscal_month_offset:0   #customize based on your company's fiscal calendar set up

  # explore: balance_sheet {
  #   group_label: "Accounting"
  #   label: "Balance Sheet"
  #   hidden: yes
  # }

  # explore: income_statement {
  #   group_label: "Accounting"
  #   label: "Income Statement"
  #   hidden: yes
  # }

  # explore: transaction_details {
  #   group_label: "Accounting"
  #   label: "Transaction Details"
  #   hidden: yes
  # }
