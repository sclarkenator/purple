#-------------------------------------------------------------------
#
# Retail Care Explores
#
#-------------------------------------------------------------------
include: "/views/**/*.view"
include: "/dashboards/**/*.dashboard"



  # explore: owned_retail_target_by_location {hidden: yes }
  explore: store_four_wall {hidden:yes}
  # explore: retail_goal {hidden:yes description:"Owened Retail Sales and Mattress Unit Goals by date and location"}
  # explore: beds_per_door {hidden: yes description:"Temporary Explore created for discovery and prototyping beds per door exploration"}
  # explore: showroom_pnl {hidden:yes description:"Temporary Explore created for prototyping Showroom PNL views"}

 explore: retail_base  {
    hidden: yes
    join:  sales_order {
      view_label: "Sales"
      type: left_outer
      sql_on: ${retail_base.date_date}=${sales_order.created_date} AND ${retail_base.store_id}=${sales_order.store_id};;
      relationship:one_to_many
      }
    join: order_flag {
      view_label: "Sales Order"
      type: left_outer
      sql_on: ${sales_order.order_id} = ${order_flag.order_id} ;;
      relationship:  one_to_one
    }
    join: retail_order_flag {
      view_label: "Retail Order Flag"
      type: left_outer
      sql_on: ${sales_order.etail_order_id} = ${retail_order_flag.order_id} ;;
      relationship:  one_to_one
    }
    join: sales_order_line_base {
      view_label: "Sales Order Line"
      type:  left_outer
      sql_on: ${sales_order.order_id} = ${sales_order_line_base.order_id} ;;
      relationship: one_to_many
    }
    join: sales_order_line {
      view_label: "Sales Order Line"
      type: left_outer
      sql_on: ${sales_order.order_id} = ${sales_order_line.order_id} and ${sales_order.system} = ${sales_order_line.system} ;;
      relationship:one_to_many
      fields: [sales_order_line.asp_mattress,sales_order_line.asp_gross_amt_mattress,sales_order_line.asp_total_units_mattress,sales_order_line.free_item,sales_order_line.gross_amt]
      }
   join: item {
      view_label: "Product"
      type: left_outer
      sql_on: ${sales_order_line_base.item_id} = ${item.item_id} ;;
      relationship: many_to_one
    }
    join: shopify_orders {
      view_label: "Sales Order Line"
      type:  left_outer
      fields: [shopify_orders.call_in_order_Flag]
      sql_on: ${shopify_orders.order_ref} = ${sales_order.related_tranid} ;;
      relationship:  one_to_one
    }
    join: agent_name {
      view_label: "Sales Order"
      type: left_outer
      sql_on: ${agent_name.shopify_id}=${shopify_orders.user_id} ;;
      relationship: many_to_one
      fields: [agent_name.shopify_id,agent_name.associate_name,agent_name.primary_location]
    }
    join: aura_vision_traffic {
      view_label: "Owned Retail"
      type:  left_outer
      sql_on: ${retail_base.store_id} = ${aura_vision_traffic.showroom_name} and ${retail_base.date_date} = ${aura_vision_traffic.created_date};;
      relationship: one_to_many
    }
    join: paycom_labor_hours {
      type: left_outer
      #sql_on:${agent_name.email_join} = ${paycom_labor_hours.email_join} and ${sales_order.created_date} = ${paycom_labor_hours.clocked_in_or_date} AND ${paycom_labor_hours.punch_type}!='HR';;
      sql_on: ${agent_name.email_join} = ${paycom_labor_hours.email_join} AND ${retail_base.date_date}= ${paycom_labor_hours.clocked_in_or_date} AND ${paycom_labor_hours.punch_type}!='HR' ;;
      relationship: many_to_many
      fields: [paycom_labor_hours.clocked_in_or_date,paycom_labor_hours.clocked_in_or_month,paycom_labor_hours.clocked_in_or_week,paycom_labor_hours.department_filter,paycom_labor_hours.hours_or,paycom_labor_hours.department_filter,paycom_labor_hours.location_code_or]
    }
    join: v_purple_showroom {
      view_label: "Showroom"
      type:  left_outer
      sql_on: ${sales_order.store_id} = ${v_purple_showroom.purple_showroom_name};;
      relationship: one_to_one
    }



  }
