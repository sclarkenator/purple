view: logan_fulfillment {
  derived_table: {
    sql:
    select
      f.fulfillment_id, f.tranid, f.item_id, i.sku_id, i.product_description, f.order_id, ch.channel_name as channel, i.product_line_name,
      o.tranid as order_tranid, f.fulfilled, f.quantity, f.bundle_quantity
    from analytics.sales.fulfillment f
      join analytics.sales.item i on f.item_id = i.item_id
      join analytics.sales.sales_order o on f.order_id = o.order_id
      join analytics_stage.netsuite.channel ch on o.channel_id = ch.channel_id ;;  }

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
    sql: ${TABLE}."TRANID" ;;  }

  dimension: item_id {
    label: "Item ID"
    type: number
    description: "The internal ID for the product that was fulfilled"
    group_label: "Fulfillments"
    sql: ${TABLE}."ITEM_ID" ;;  }

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
    sql: ${TABLE}.quantity ;; }

}
