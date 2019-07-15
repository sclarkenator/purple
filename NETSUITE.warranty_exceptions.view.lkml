view: netsuite_warranty_exceptions {
  derived_table: {
    sql:
      with tmp as (
        select
          o.created, o.order_id as netsuite_order_id, o.tranid as transaction_number, o.related_tranid, o.etail_order_id as shopify_order_id,
          replace(replace(REGEXP_SUBSTR(replace(upper(o.MEMO),' ',''),'O#?\\d{4,7}'),'O',''),'#','') as original_order_number,upper(i.product_line_name_lkr) as category,
          replace(replace(replace(replace(upper(COALESCE(o.memo,'')),'RLP','RPL'),'DCS','DSC'),'NIS','NSI'),' ','') as order_memo,
          replace(replace(replace(replace(upper(COALESCE(l.memo,'')),'RLP','RPL'),'DCS','DSC'),'NIS','NSI'),' ','') as line_memo
        from analytics.sales.sales_order o
          join analytics.sales.sales_order_line l on o.order_id = l.order_id
          join analytics.sales.item i on l.item_id = i.item_id
        where o.gross_amt = 0
            and source = 'Shopify - US'
      ), nr as (
        select created, netsuite_order_id, transaction_number, related_tranid, shopify_order_id, original_order_number, category, order_memo, line_memo
        from tmp
        group by created, netsuite_order_id, transaction_number, related_tranid, shopify_order_id, original_order_number, category, order_memo, line_memo
      )
      select
          nr.created, nr.transaction_number, nr.related_tranid, nr.shopify_order_id, nr.original_order_number, nr.netsuite_order_id, nr.category, nr.order_memo, nr.line_memo
      from nr
          join analytics_stage.shopify_us_ft."ORDER" sr on nr.shopify_order_id = sr.id::text
      where CASE
          WHEN nr.order_memo like '%DSC%' THEN 0
          WHEN nr.order_memo like '%NSI%' THEN 0
          WHEN nr.order_memo like '%APOLOG%' THEN 0
          WHEN nr.order_memo like '%SQUISH%' THEN 0
          WHEN REGEXP_SUBSTR(upper(nr.order_memo),'O#[ABCS]') is not null THEN 0
          WHEN upper(nr.order_memo) like '%RPL%' and nr.original_order_number is not null THEN 0
          ELSE 1
        END = 1;;
  }

  dimension: created {
    label: "Warranty Created"
    description: "The created date of the warranty order."
    type: date
    sql: to_date(${TABLE}.created);; }

  dimension: transaction_number {
    label: "Transaction Number"
    description: "The NetSuite transaction number for this warranty"
    type: string
    sql: ${TABLE}.transaction_number ;; }

  dimension: related_tranid {
    label: "Shopify Order Number"
    description: "The Shopify order number for the warranty claim"
    type: string
    sql: ${TABLE}.related_tranid;; }

  dimension: shopify_order_id {
    label: "Shopify Order ID"
    description: "The Shopify order id for the warranty claim"
    type: string
    sql: ${TABLE}.shopify_order_id;; }

  dimension: original_order_number {
    label: "Original Order"
    description: "The Shopify order number associated with the original Shopify order that has a warranty claim"
    type: string
    sql: ${TABLE}.original_order_number;; }

  dimension: netsuite_order_id {
    label: "NetSuite Internal Order ID"
    description: "The NetSuite Internal Order ID associated with the original Shopify order for that warranty claim"
    type: string
    sql: ${TABLE}.netsuite_order_id;; }

  dimension: order_memo {
    label: "Replacement Order Notes"
    description: "The order level notes for the replacement order"
    type: string
    sql: ${TABLE}.order_memo;; }

  dimension: line_memo {
    label: "Replacement Order Line Notes"
    description: "The line, or item, level notes for the item"
    type: string
    sql: ${TABLE}.line_memo;; }

  dimension: category {
    label: "Product Category"
    description: "The product category"
    type: string
    sql: ${TABLE}.category;; }

}
