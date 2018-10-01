view: netsuite_orphaned_warranties {
  derived_table: {
    sql:
      with mc as (
        select
          SPLIT_PART(list_item_name, ' - ', 1) as mod_code,
          SPLIT_PART(list_item_name, ' - ', 3) as description
        from analytics_stage.netsuite.discount_code_list
        where list_item_name like 'RPL%'
      ), nr as (
        select
          replace(replace(REGEXP_SUBSTR(replace(upper(MEMO),' ',''),'O#?\\d{1,7}'),'O',''),'#','') as original_order_number,
          o.etail_order_id as replacement_order_id, o.related_tranid, o.created as replaced, i.product_description as product_name,
          i.product_line_name_lkr as category, REGEXP_SUBSTR(replace(upper(MEMO),'RLP','RPL'),'RPL\\d{2}') as mod_code,
          replace(o.memo,'\n',' ') as memo, o.tranid
        from analytics.sales.sales_order o
            join analytics.sales.sales_order_line l on o.order_id = l.order_id
            join analytics.sales.item i on l.item_id = i.item_id
        where o.gross_amt = 0
            and source = 'Shopify - US'
            and replace(upper(memo),'RLP','RPL') like '%RPL%'
      )
      select
          sr.customer_id, so.id as original_order_id, so.name as original_name, nr.replacement_order_id,
          nr.related_tranid as replacement_name, nr.tranid as netsuite_transaction_number, nr.product_name,
          nr.category, convert_timezone('America/Denver',so.created_at) as original_order_created,
          nr.replaced as warranty_created, mc.mod_code, mc.description as warranty_reason, nr.memo
      from nr
        join analytics_stage.shopify_us_ft."ORDER" sr on nr.replacement_order_id = sr.id
        left join analytics_stage.shopify_us_ft."ORDER" so on nr.original_order_number = so.order_number
        left join mc on nr.mod_code = mc.mod_code;;
  }

  dimension_group: warranty_created {
    description: "The timestamp that the warranty order was created, or in other words, when the original product was replaced."
    type: time
    timeframes: [
      year,
      month,
      date
    ]
    convert_tz: yes
    datatype: timestamp
    sql: ${TABLE}.warranty_created;;
    label: "Warranty Created"
  }

  dimension_group: original_order_created {
    description: "The timestamp that the original order was created"
    type: time
    timeframes: [
      year,
      month,
      date
    ]
    convert_tz: yes
    datatype: timestamp
    sql: ${TABLE}.original_order_created;;
    label: "Original Order Created"
  }

  dimension: customer_id {
    description: "Customer ID related to this warranty"
    type: number
    sql: ${TABLE}.customer_id ;;
    label: "Customer ID"
  }

  dimension: original_order_id {
    description: "The Shopify order id associated with the original order that has a warranty claim"
    type: number
    sql: ${TABLE}.original_order_id;;
    label: "Original Order ID"
  }

  dimension: original_name {
    description: "The Shopify order name associated with the original order that has a warranty claim"
    type: string
    sql: ${TABLE}.original_name;;
    label: "Original Order"
  }

  dimension: replacement_order_id {
    description: "The Shopify order id associated with the warranty replacement order"
    type: number
    sql: ${TABLE}.replacement_order_id;;
    label: "Replacement Order ID"
  }

  dimension: replacement_name {
    description: "The Shopify order name associated with the warranty replacement order"
    type: string
    sql: ${TABLE}.replacement_name;;
    label: "Replacement Order"
  }

  dimension: netsuite_transaction_number {
    description: "The NetSuite transaction number for the warranty replacement order"
    type: string
    sql: ${TABLE}.netsuite_transaction_number;;
    label: "Transaction Number"
  }

  dimension: category {
    description: "The category of the product being warrantied"
    type: string
    sql: ${TABLE}.category;;
    label: "Product Category"
  }

  dimension: product_name {
    description: "The name of the product being warrantied"
    type: string
    sql: ${TABLE}.product_name;;
    label: "Product Name"
  }

  dimension: mod_code {
    description: "The warranty reason code"
    type: string
    sql: ${TABLE}.mod_code;;
    label: "Warranty Code"
  }

  dimension: warranty_reason {
    description: "The warranty code description"
    type: string
    sql: ${TABLE}.warranty_reason;;
    label: "Warranty Reason"
  }

  dimension: memo {
    description: "The order level notes on the warranty order"
    type: string
    sql: ${TABLE}.memo;;
    label: "Order Notes"
  }
}
