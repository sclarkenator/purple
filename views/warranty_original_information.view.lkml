view: warranty_original_information {
    derived_table: {
      sql:
        SELECT
          wr.list_item_name AS return_reason
          , case when s.TRANSACTION_TYPE = 'Cash Sale' or s.SOURCE in ('Amazon FBA - US','Amazon-FBA')  then s.CREATED::date else f.fulfilled::date end fulfilled_date
          , i.ITEM_ID
          , i.sku_id
          , s.ORDER_ID
          , w.CREATED::date w_created_date
          , sol.Created::date s_created_date
          , coalesce(wso.order_id,w.REPLACEMENT_ORDER_ID) as REPLACEMENT_ORDER_ID
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
        LEFT JOIN analytics_stage.ns.UPDATE_WARRANTY_REASONS  AS wr ON w.WARRANTY_REASON_CODE_ID = wr.LIST_ID
        LEFT JOIN SALES.SALES_ORDER wso on s.related_tranid =
          case
            when length(replace(REGEXP_SUBSTR(replace(upper(wso.MEMO),' ',''),'[Oo]#?\\d{1,7}'),'O','')) = 4
              then replace(replace(REGEXP_SUBSTR(replace(upper(wso.MEMO),' ',''),'[Oo]#?\\d{1,3}(-\\d{1,7})(-\\d{1,7})'),'O',''),'#','')
            else replace(REGEXP_SUBSTR(replace(upper(wso.MEMO),' ',''),'[Oo]#?\\d{1,7}'),'O','')
          end ;;
    }
    dimension: key {
      hidden: yes
      sql: ${TABLE}.order_id || ${TABLE}.item_id ;;
    }
    dimension: return_reason {
      label: "Original Warranties Warranty Reason"
      group_label: " Advanced"
      description: "Original Reason customer gives for submitting warranty claim on that item. Source: netsuite.update_warranty_reasons"
      sql: upper(${TABLE}.return_reason) ;;
    }
    dimension: fulfilled_date {
      label: "Original Fulfillment"
      group_label: " Advanced"
      description: "Date item within order shipped for Fed-ex orders, date customer receives delivery from Manna or date order is on truck for wholesale. Source:looker.calculation"
      type: date
      sql: ${TABLE}.fulfilled_date ;;
    }
    dimension: total_gross_Amt_non_rounded {
      label: "Original Sales Order Line Gross Sales ($)"
      group_label: " Advanced"
      description: "Total the customer paid, excluding tax and freight, in $. Source:netsuite.sales_order_line"
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
  dimension: sku_id {
    hidden: yes
    type: number
    sql: ${TABLE}.sku_id ;;
  }
  dimension: sku_clean {
    type: string
    hidden: yes
    sql: case when left(${sku_id},3) = 'AC-' then right(${sku_id},11) else ${sku_id} end ;;
  }
  dimension: sku_merged {
    type: string
    hidden: yes
    sql: --OG Mattress
      case when ${sku_clean} = '10-21-23960' then '10-21-12960'
        when ${sku_clean} = '10-21-23620' then '10-21-12620'
        when ${sku_clean} = '10-21-23632' then '10-21-12632'
        when ${sku_clean} = '10-21-23625' then '10-21-12625'
        when ${sku_clean} = '10-21-23617' then '10-21-12617'
        when ${sku_clean} = '10-21-23618' then '10-21-12618'
        --Platforms
        when ${sku_clean} in ('10-38-82822','10-38-52822') then '10-38-12822'
        when ${sku_clean} in ('10-38-82815','10-38-92892','10-38-92892','10-38-52815') then '10-38-12815'
        when ${sku_clean} in ('10-38-82846','10-38-52846') then '10-38-12846'
        when ${sku_clean} in ('10-38-82893','10-38-82895','10-38-82895','10-38-52893') then '10-38-12893'
        when ${sku_clean} in ('10-38-82890','10-38-82890','10-38-82892','10-38-52892') then '10-38-12892'
        when ${sku_clean} in ('10-38-52891') then '10-38-82891'
        --Cushions
        when ${sku_clean} = '10-41-12571' then '10-41-12378'
        when ${sku_clean} = '10-41-12533' then '10-41-12573'
        when ${sku_clean} = '10-41-12574' then '10-41-12502'
        when ${sku_clean} in ('10-41-12572','10-41-12583') then '10-41-12496'
        when ${sku_clean} = '10-41-12576' then '10-41-12519'
        --Protectors
        when ${sku_clean} = '10-38-13917' then '10-38-12717'
        when ${sku_clean} = '10-38-13994' then '10-38-12694'
        when ${sku_clean} = '10-38-13900' then '10-38-12700'
        when ${sku_clean} in ('10-38-13748','10-38-12755') then '10-38-12748'
        when ${sku_clean} = '10-38-13924' then '10-38-12724'
        when ${sku_clean} = '10-38-13731' then '10-38-12731'
        --powerbases
        when ${sku_clean} in ('10-38-12946','10-38-12949') then '10-38-12953'
        when ${sku_clean} = '10-38-12939' then '10-38-12948'
        else ${sku_clean} end ;;  }

    dimension: order_id {
      group_label: " Advanced"
      description: "This is Netsuite's internal ID. This will be a hyperlink to the sales order in Netsuite. Source:netsuite.sales_order"
      type: number
      sql: ${TABLE}.order_id ;;
    }
    dimension: warranty_created_date {
      label: "Original Warranty Date"
      group_label: " Advanced"
      description: "Original Warranty Created. Source:netsuite.warranty_order"
      type: date
      sql: ${TABLE}.w_created_date ;;
    }
    dimension: sales_created_date {
      label: "Original Sales Order"
      group_label: " Advanced"
      description: "Time and date original order was placed. Source:netsuite.sales_order_line"
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
    description: "Original Channel. Source:netsuite.sales_order"
    type: string
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