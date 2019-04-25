view: logan_fulfillment {
  derived_table: {
    sql:
      select
        f.fulfillment_id, f.tranid, f.item_id, i.classification as item_class, i.sku_id,
        i.product_description, f.order_id, ch.channel_name as channel, i.product_line_name,
        o.tranid as order_tranid, f.fulfilled, f.quantity, f.bundle_quantity, o.source, sum(ol.gross_amt) as amount
      from analytics.sales.fulfillment f
        join analytics.sales.item i on f.item_id = i.item_id
        join analytics.sales.sales_order o on f.order_id = o.order_id
        join analytics.sales.sales_order_line ol on o.order_id = ol.order_id and f.item_id = ol.item_id
        join analytics_stage.netsuite.channel ch on o.channel_id = ch.channel_id
      group by 1,2,3,4,5,6,7,8,9,10,11,12,13,14
      UNION
      select
        f.fulfillment_id, f.tranid, f.item_id, i.classification as item_class, i.sku_id,
        i.product_description, f.order_id, ch.channel_name as channel, i.product_line_name,
        o.tranid as order_tranid, f.fulfilled, f.quantity, f.bundle_quantity, o.source, sum(ol.gross_amt) as amount
      from analytics.sales.fulfillment f
        join analytics.sales.item i on f.item_id = i.item_id
        join analytics.sales.sales_order o on f.order_id = o.order_id
        join analytics.sales.sales_order_line ol on o.order_id = ol.order_id and f.parent_item_id = ol.item_id
        join analytics_stage.netsuite.channel ch on o.channel_id = ch.channel_id
      where f.parent_item_id <> 0
      group by 1,2,3,4,5,6,7,8,9,10,11,12,13,14 ;;  }

  dimension: fulfillment_id {
    label: "Fulfillment Internal ID"
    type: number
    description: "The internal ID for the 'Item Fulfillment' transaction record in NetSuite, and can be used in the URL within NetSuite"
    group_label: "Fulfillments"
    sql: ${TABLE}."FULFILLMENT_ID" ;;  }

  dimension: order_id {
    label: "Order Internal ID"
    type: number
    description: "The internal ID for the 'Sales Order' transaction record in NetSuite, and can be used in the URL within NetSuite to find the originating order for this fulfillment"
    group_label: "Fulfillments"
    sql: ${TABLE}."ORDER_ID" ;;  }

  dimension: tranid {
    label: "Fulfillment Transaction Number"
    type: string
    description: "The tranid, or transaction number, for the fulfillment record in NetSuite.  Can be used to search for the fulfillment within the NetSuite app"
    group_label: "Fulfillments"
    sql: ${TABLE}."TRANID" ;;  }

  dimension: order_tranid {
    label: "Order Transaction Number"
    type: string
    description: "The tranid, or transaction number, for the originating sales order transaction in NetSuite.  Can be used to search for the Sales Order within the NetSuite app"
    group_label: "Fulfillments"
    sql: ${TABLE}."ORDER_TRANID" ;;  }

  dimension: item_id {
    label: "Item ID"
    type: number
    description: "The internal ID for the product that was fulfilled"
    group_label: "Fulfillments"
    sql: ${TABLE}."ITEM_ID" ;;  }

  dimension: item_class {
    label: "Item Classification"
    type: string
    description: "The classification of the product (e.g. Finished Good)"
    group_label: "Fulfillments"
    sql: ${TABLE}."ITEM_CLASS" ;;  }

  dimension: sku_id {
    label: "SKU"
    type: string
    description: "The product SKU that was fulfilled"
    group_label: "Fulfillments"
    sql: ${TABLE}."SKU_ID" ;;  }

  dimension: product_description {
    label: "Product"
    type: string
    description: "The product description for the SKU that was fulfilled"
    group_label: "Fulfillments"
    sql: ${TABLE}."PRODUCT_DESCRIPTION" ;;  }

  dimension: product_line_name {
    label: "Product Line"
    type: string
    description: "The product line for the product that was fulfilled"
    group_label: "Fulfillments"
    sql: ${TABLE}."PRODUCT_LINE_NAME" ;;  }

  dimension: channel {
    label: "Channel"
    type: string
    description: "The sales channel that this fulfillment applies to"
    group_label: "Fulfillments"
    sql: ${TABLE}."CHANNEL" ;;  }

  dimension: source {
    label: "Source"
    type: string
    description: "The source of the sales order (e.g. Shopify vs Amazon)"
    group_label: "Fulfillments"
    sql: ${TABLE}."SOURCE" ;;  }

  dimension_group: fulfilled {
    label: "Fulfilled"
    description: "The date the item was fulfilled"
    type: time
    timeframes: [raw, date, month, month_name, year]
    convert_tz: no
    datatype: date
    sql: to_date(${TABLE}.fulfilled) ;; }

  measure: quantity {
    label: "Units Fulfilled"
    description: "The quantity, or count, of fulfilled items on this fulfillment"
    type: sum
    sql: ${TABLE}.quantity ;; }

  measure: bundle_quantity {
    label: "Bundles Fulfilled"
    description: "The quantity, or count, of this bundle on this fulfillment, or zero if the item is not part of a bundle"
    type: sum
    sql: ${TABLE}.bundle_quantity ;; }

  measure: amount {
    label: "Amount"
    description: "The amount of the item"
    type: sum
    sql: ${TABLE}.amount ;; }

}