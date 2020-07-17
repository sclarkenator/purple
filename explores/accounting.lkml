#-------------------------------------------------------------------
#
# Accounting Explores
#
#-------------------------------------------------------------------
include: "/views/**/*.view"
include: "/dashboards/**/*.dashboard"

  explore: finance_bill{
    hidden: yes
    group_label: "Accounting"
    label: "Finance Bill Items"
    description: "A joined view of finance bill headers and bill line items"
    join: finance_bill_line {
      type: left_outer
      sql_on: ${finance_bill.bill_id}=${finance_bill_line.bill_id} ;;
      relationship: one_to_many
    }
    join: finance_bill_payment {
      type:  inner
      sql_on: ${finance_bill.bill_id}=${finance_bill_payment.bill_payment_id} ;;
      relationship: one_to_one
    }
    join: finance_bill_payment_line {
      type: full_outer
      sql_on: ${finance_bill.bill_id}=${finance_bill_payment_line.bill_payment_id} ;;
      relationship:  one_to_many
    }
  }

  explore: v_fit {hidden: yes group_label: "Accounting"}
  explore: fit_problem {hidden: yes group_label: "Accounting"}
  explore: v_fit_affirm {hidden: yes group_label: "Accounting"}
  explore: v_fit_amazon {hidden: yes group_label: "Accounting"}
  explore: v_fit_axomo { hidden: yes group_label: "Accounting"}
  explore: v_fit_braintree {hidden: yes group_label: "Accounting"}
  explore: v_fit_first_data {hidden: yes group_label: "Accounting"}
  explore: v_fit_paypal {hidden: yes group_label: "Accounting"}
  explore: v_fit_shopify_payment {hidden: yes group_label: "Accounting"}
  explore: v_fit_stripe {hidden: yes group_label: "Accounting"}
