view: warranty_original_information {
    derived_table: {
      sql:
        SELECT
          wr.list_item_name AS return_reason
          , case when s.TRANSACTION_TYPE = 'Cash Sale' or s.SOURCE in ('Amazon FBA - US','Amazon-FBA')  then s.CREATED::date else f.fulfilled::date end fulfilled_date
          , i.ITEM_ID
          , s.ORDER_ID
          , w.CREATED::date w_created_date
          , sol.Created::date s_created_date
          , w.REPLACEMENT_ORDER_ID
            , case when s.CHANNEL_id = 1 then 'DTC'
               when s.CHANNEL_id = 2 then 'Wholesale'
               when s.CHANNEL_id = 3 then 'General'
               when s.CHANNEL_id = 4 then 'Employee Store'
               when s.CHANNEL_id = 5 then 'Owned Retail'
              else 'Other' end as channel
          , sol.gross_amt as total_gross_Amt_non_rounded
        FROM sales.sales_order_line sol
        LEFT JOIN SALES.ITEM  AS i ON sol.ITEM_ID = i.ITEM_ID
        LEFT JOIN SALES.FULFILLMENT  AS f ON (sol.item_id||'-'||sol.order_id||'-'||sol.system) = (case when f.parent_item_id = 0 or f.parent_item_id is null then f.item_id else f.parent_item_id end)||'-'||f.order_id||'-'||f.system and f.status = 'Shipped'
        LEFT JOIN SALES.SALES_ORDER  AS s ON (sol.order_id||'-'||sol.system) = (s.order_id||'-'||s.system)
        FULL OUTER JOIN SALES.WARRANTY_ORDER  AS w ON s.ORDER_ID = w.ORDER_ID and s.SYSTEM = w.ORIGINAL_SYSTEM
        LEFT JOIN ANALYTICS_STAGE.netsuite.UPDATE_WARRANTY_REASONS  AS wr ON w.WARRANTY_REASON_CODE_ID = wr.LIST_ID ;;
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

  dimension: channel {
    label: "Original Channel"
    group_label: " Advanced"
    description: "Original Channel"
    type: date
    sql: ${TABLE}.channel ;;
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
