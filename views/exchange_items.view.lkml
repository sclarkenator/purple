view: exchange_items {
derived_table: {sql:
select
  eo.order_id as original_order_id,
  f.fulfillment_id as original_fulfilment_id,
  f.fulfilled as orginal_fulfilled,
  eo.exchange_order_id as rma_exchange_order_id,
  eo.replacement_order_id,
  eol.item_id as original_order_item_id,
  i.product_line_name_lkr as original_order_product_line_name_lkr,
  i.product_description_lkr as original_order_product_description_lkr,
  esol.item_id as exchange_order_item_id,
  ef.fulfillment_id as exchange_fulfillment_id,
  ef.fulfilled as exchange_fulfilled,
  ei.product_line_name_lkr as exchange_order_product_line_name_lkr,
  ei.product_description_lkr as exchange_order_product_description_lkr,
  ero.rma_return_type as exchange_return_type,
  ero.status as exchange_return_status,
  ero.created as exchange_return_initiated,
  ero.warranty_order as exchange_warranty_order,
  eoo.rma_return_type as original_return_type,
  eoo.status as original_return_status,
  eoo.created as original_return_initiated,
  eoo.warranty_order as original_warranty_order
  from analytics.sales.exchange_order eo
  left join analytics.sales.exchange_order_line eol on eo.exchange_order_id = eol.exchange_order_id and eo.replacement_order_id = eol.replacement_order_id and eo.system = eol.system
  left join analytics.sales.item i on eol.item_id = i.item_id
  left join analytics.sales.sales_order eso on eo.replacement_order_id = eso.order_id
  left join analytics.sales.sales_order_line esol on eso.order_id = esol.order_id and eso.system = esol.system
  left join analytics.sales.item ei on esol.item_id = ei.item_id and i.sub_category_name_lkr = ei.sub_category_name_lkr
  left join analytics.sales.fulfillment f on eo.order_id = f.order_id and eo.system = f.system and eol.item_id = case when f.parent_item_id is null or f.parent_item_id = 0 then f.item_id else f.parent_item_id end
  left join analytics.sales.fulfillment ef on eo.replacement_order_id = ef.order_id and eo.system = ef.system and esol.item_id = case when ef.parent_item_id is null or ef.parent_item_id = 0 then ef.item_id else ef.parent_item_id end
  left join analytics.sales.return_order ero on eo.exchange_order_id = ero.return_order_id
  left join analytics.sales.return_order eoo on eo.replacement_order_id = eoo.order_id
where ei.item_id is not null ;; }

dimension: original_order_id {
  label: "Order ID"
  hidden: yes
  description: "Original Order ID"
  type: number
  sql: ${TABLE}.original_order_id ;; }

  dimension: original_fulfilment_id {
    label: "Original Fulfillment ID"
    hidden: yes
    description: "Original Order Fulfillment ID"
    type: number
    sql: ${TABLE}.original_fulfilment_id ;; }

  dimension: orginal_fulfilled {
    label: "Original Fulfillment Date"
    hidden: yes
    description: "Original Order Fulfillment Date"
    type: date
    sql: ${TABLE}.orginal_fulfilled ;; }

  dimension: exchange_order_id {
    label: "Exchange Order ID"
    hidden: yes
    description: "Return Exchange Order ID"
    type: number
    sql: ${TABLE}.rma_exchange_order_id ;; }

  dimension: replacement_order_id {
    label: "Replacement Order ID"
    hidden: yes
    description: "Return Replacement Order ID"
    type: number
    sql: ${TABLE}.replacement_order_id ;; }

  dimension: original_order_item_id {
    label: "Original Item ID"
    hidden: yes
    description: "Original Order Item ID"
    type: number
    sql: ${TABLE}.original_order_item_id ;; }

  dimension: original_order_product_line_name_lkr {
    label: "Original Product Name"
    hidden: yes
    description: "Original Order Product Name"
    type: string
    sql: ${TABLE}.original_order_product_line_name_lkr ;; }

  dimension: original_order_product_description_lkr {
    label: "Original Product Description"
    hidden: yes
    description: "Original Order Product Description"
    type: string
    sql: ${TABLE}.original_order_product_description_lkr ;; }

  dimension: exchange_order_item_id {
    label: "Exchage Item ID"
    hidden: yes
    description: "Exchange Order Item ID"
    type: number
    sql: ${TABLE}.exchange_order_item_id ;; }

  dimension: exchange_fulfilment_id {
    label: "Exchange Fulfillment ID"
    hidden: yes
    description: "Exchange Order Fulfillment ID"
    type: number
    sql: ${TABLE}.exchange_fulfilment_id ;; }

  dimension: exchange_fulfilled {
    label: "Exchange Fulfillment Date"
    hidden: yes
    description: "Exchange Order Fulfillment Date"
    type: date
    sql: ${TABLE}.exchange_fulfilled ;; }

  dimension: exchange_order_product_line_name_lkr {
    label: "Exchange Product Name"
    hidden: yes
    description: "Exchange Order Product Name"
    type: string
    sql: ${TABLE}.exchange_order_product_line_name_lkr ;; }

  dimension: exchange_order_product_description_lkr {
    label: "Exchange Product Description"
    hidden: yes
    description: "Exchange Order Product Description"
    type: string
    sql: ${TABLE}.exchange_order_product_description_lkr ;; }

  dimension: exchange_return_type {
    label: "Exchange Order Return Type"
    hidden: yes
    description: "Excahnge Order Return Type (Trial vs Non-Trial)"
    type: string
    sql: ${TABLE}.exchange_return_type ;;  }

  dimension: exchange_return_status {
    label: "Exchange Order Return Status"
    hidden: yes
    description: "Exchange Order Return Status (Refunded, Closed, Cancelled, ect)"
    type: string
    sql: ${TABLE}.exchange_return_status ;;  }

  dimension: exchange_return_initiated {
    label: "Exchange Order Return Initiated Date"
    hidden: yes
    description: "Exchange Order Return Initiated Date"
    type: date
    sql: ${TABLE}.exchange_return_initiated ;;  }

  dimension: exchange_warranty_order {
    label: "Exchange Order Warranty "
    hidden: yes
    description: "Exchange Order Warranty (T vs F)"
    type: string
    sql: ${TABLE}.exchange_warranty_order ;;  }

  dimension: original_return_type {
    label: "Original Order Return Type"
    hidden: yes
    description: "Original Order Return Type (Trial vs Non-Trial)"
    type: string
    sql: ${TABLE}.original_return_type ;;  }

  dimension: original_return_status {
    label: "Original Order Return Status"
    hidden: yes
    description: "Original Order Return Status (Refunded, Closed, Cancelled, ect)"
    type: string
    sql: ${TABLE}.original_return_status ;;  }

  dimension: original_return_initiated {
    label: "Original Order Return Initiated Date"
    hidden: yes
    description: "Original Order Return Initiated Date"
    type: date
    sql: ${TABLE}.original_return_initiated ;;  }

  dimension: original_warranty_order {
    label: "Original Order Warranty "
    hidden: yes
    description: "Original Order Warranty (T vs F)"
    type: string
    sql: ${TABLE}.original_warranty_order ;;  }

  measure: count  {
    view_label: "Measures"
    type: count
  }

}
