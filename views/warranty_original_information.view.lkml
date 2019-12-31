view: warranty_original_information {
    derived_table: {
      explore_source: sales_order_line {
        column: return_reason { field: warranty_reason.return_reason }
        column: fulfilled_date {}
        column: total_gross_Amt_non_rounded {}
        column: item_id { field: item.item_id }
        column: order_id { field: sales_order.order_id }
        column: w_created_date { field: warranty_order.created_date }
        column: s_created_date {field: sales_order_line.created_date}
        column: replacement_order_id {field: warranty_order.replacement_order_id}
      }
    }
    dimension: key {
      hidden: yes
      sql: ${TABLE}.order_id || ${TABLE}.item_id ;;
    }
    dimension: return_reason {
      label: "Original Warranties Warranty Reason"
      group_label: " Advanced"
      description: "Original Reason customer gives for submitting warranty claim on that item"
      sql: ${TABLE}.return_reason ;;
    }
    dimension: fulfilled_date {
      label: "Original Fulfillment"
      group_label: " Advanced"
      description: "Date item within order shipped for Fed-ex orders, date customer receives delivery from Manna or date order is on truck for wholesale"
      type: date
      sql: ${TABLE}.fulfilled_date ;;
    }
    dimension: total_gross_Amt_non_rounded {
      label: "Original Sales Order Line Gross Sales ($)"
      group_label: " Advanced"
      description: "Total the customer paid, excluding tax and freight, in $"
      value_format: "$#,##0"
      type: number
      sql: ${TABLE}.total_gross_Amt_non_rounded ;;
    }
    dimension: item_id {
      label: "Original Product Item ID"
      group_label: " Advanced"
      hidden: yes
      description: "Original Internal Netsuite ID"
      type: number
      sql: ${TABLE}.item_id ;;
    }
    dimension: order_id {
      group_label: " Advanced"
      description: "This is Netsuite's internal ID. This will be a hyperlink to the sales order in Netsuite."
      type: number
      sql: ${TABLE}.order_id ;;
    }
    dimension: warranty_created_date {
      label: "Original Warranty Date"
      group_label: " Advanced"
      description: "Original Warranty Created"
      type: date
      sql: ${TABLE}.w_created_date ;;
    }
    dimension: sales_created_date {
      label: "Original Sales Order"
      group_label: " Advanced"
      description: "Time and date original order was placed"
      type: date
      sql: ${TABLE}.s_created_date ;;
    }
  dimension: replacement_order_id {
    hidden: yes
    type: number
    sql: ${TABLE}.replacement_order_id ;;
  }

 dimension: bucketed_item_id {
      hidden: yes
      type: string
      sql: case when ${TABLE}.ITEM_ID = '3797' then '1668'
            when ${TABLE}.ITEM_ID = '3800' then '2991'
            when ${TABLE}.ITEM_ID = '4410' then '4409'
            when ${TABLE}.ITEM_ID = '3798' then '1667'
            when ${TABLE}.ITEM_ID = '3799' then '1666'
            when ${TABLE}.ITEM_ID = '3802' then '3715'
            when ${TABLE}.ITEM_ID = '3801' then '1665'
            else ${TABLE}.ITEM_ID
            end ;; }
  }
