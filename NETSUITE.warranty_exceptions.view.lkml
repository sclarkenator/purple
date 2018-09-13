view: netsuite_warranty_exceptions {
  derived_table: {
    sql:
      with tmp as (
        select
          o.created, o.order_id as netsuite_order_id, o.tranid as transaction_number, o.related_tranid, o.etail_order_id as shopify_order_id,
          replace(replace(REGEXP_SUBSTR(replace(upper(MEMO),' ',''),'O#?\\d{4,7}'),'O',''),'#','') as original_order_number,upper(i.product_line_name) as category,
          replace(replace(replace(replace(upper(COALESCE(memo,'')),'RLP','RPL'),'DCS','DSC'),'NIS','NSI'),' ','') as memo
        from analytics.sales.sales_order o
          join analytics.sales.sales_order_line l on o.order_id = l.order_id
          join analytics.sales.item i on l.item_id = i.item_id
        where o.gross_amt = 0
            and source = 'Shopify - US'
      ), nr as (
        select created, netsuite_order_id, transaction_number, related_tranid, shopify_order_id, original_order_number, category, memo
        from tmp
        group by created, netsuite_order_id, transaction_number, related_tranid, shopify_order_id, original_order_number, category, memo
      )
      select
          nr.created, nr.transaction_number, nr.related_tranid, nr.shopify_order_id, nr.original_order_number, nr.category, nr.memo
      from nr
          join analytics_stage.shopify_us_ft."ORDER" sr on nr.shopify_order_id = sr.id
      where CASE
          WHEN memo like '%DSC%' THEN 0
          WHEN memo like '%NSI%' THEN 0
          WHEN memo like '%APOLOG%' THEN 0
          WHEN memo like '%SQUISH%' THEN 0
          WHEN REGEXP_SUBSTR(memo,'O#[NABCS]') is not null THEN 0
          WHEN memo like '%RPL%' and nr.original_order_number is not null THEN 0
          ELSE 1
        END = 1;;
  }

  dimension: created {
    description: "The created date of the warranty order."
    type: date
    sql: to_date(${TABLE}.created);;
    label: "Warranty Created"
  }

  dimension: transaction_number {
    description: "The NetSuite transaction number for this warranty"
    type: string
    sql: ${TABLE}.transaction_number ;;
    label: "Transaction Number"
  }

  dimension: related_tranid {
    description: "The Shopify order number for the warranty claim"
    type: string
    sql: ${TABLE}.related_tranid;;
    label: "Shopify Order Number"
  }

  dimension: shopify_order_id {
    description: "The Shopify order id for the warranty claim"
    type: string
    sql: ${TABLE}.shopify_order_id;;
    label: "Shopify Order ID"
  }

  dimension: original_order_number {
    description: "The Shopify order number associated with the original Shopify order that has a warranty claim"
    type: string
    sql: ${TABLE}.original_order_number;;
    label: "Original Order"
  }

  dimension: memo {
    description: "The order level notes for the replacement order"
    type: string
    sql: ${TABLE}.memo;;
    label: "Replacement Order Notes"
  }

  dimension: category {
    description: "The product category"
    type: string
    sql: ${TABLE}.category;;
    label: "Product category"
  }
}
