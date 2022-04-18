#-------------------------------------------------------------------
# Owner - Scott Clark
# Fulfillment
#-------------------------------------------------------------------

view: fulfillment {
  sql_table_name: SALES.FULFILLMENT ;;

  dimension: PK {
    primary_key: yes
    hidden: yes
    type: string
    sql:  NVL(${TABLE}.FULFILLMENT_ID,'0') || NVL(${TABLE}.system,'0') || NVL(${TABLE}.item_id,'0') || NVL(${TABLE}.parent_item_id,'0') ;;
    }

  dimension: fulfillment_id {
    hidden: no
    group_label: " Advanced"
    label: "Fulfillment ID"
    description: "Netsuite Internal Fulillment ID. Source: netsuite.fulfillment"
    link: {
      label: "Netsuite"
      url: "https://4651144.app.netsuite.com/app/accounting/transactions/itemship.nl?id={{value}}&whence="
      icon_url: "https://www.google.com/s2/favicons?domain=www.netsuite.com"
    }
    type: string
    sql: ${TABLE}.FULFILLMENT_ID ;; }

  dimension: COGS_DIRECT_MATERIAL_AMT {
    hidden: yes
    type: string
    sql: ${TABLE}.COGS_DIRECT_MATERIAL_AMT ;; }

  measure: total_COGS_DIRECT_MATERIAL_AMT {
    hidden: yes
    type: sum
    sql: ${TABLE}.COGS_DIRECT_MATERIAL_AMT ;; }

  dimension: status {
    hidden: yes
    type: string
    sql: ${TABLE}.status ;; }

  dimension: carrier {
    group_label: " Advanced"
    label: "Carrier (actual)"
    hidden: yes
    description: "Shipping provider was used to fulfill this part of the order. Source:netsuite.fulfillment"
    type: string
    sql: ${TABLE}.carrier ;;  }

  dimension: carrier_grouped {
    view_label: "Carrier Grouped"
    type: string
    hidden: yes
    sql: case when ${TABLE}.carrier = 'Carry Out' then 'Carry Out'
          when ${TABLE}.carrier = 'Will Call' then 'Will Call'
          else 'Shipped' end ;; }

  dimension_group: created {
    label: "Fulfilled Created Date"
    hidden: yes
    type: time
    timeframes: [raw, date, day_of_week, day_of_month, week, week_of_year, month, month_name, quarter, quarter_of_year, year]
    sql: ${TABLE}.created ;; }

  dimension_group: left_purple {
    label: "Left Purple"
    description: "Date the item left purple.Source:netsuite.fulfillment"
    #hidden: yes
    type: time
    timeframes: [raw, date, hour_of_day, day_of_week, day_of_month, week, week_of_year, month, month_name, quarter, quarter_of_year, year]
    sql: coalesce(${TABLE}.PURPLE_SLA, ${fulfilled_F_raw})::date ;; }

  dimension_group: in_hand {
    label: "In Hand"
    description: "Date the customer recieved the item. Source: netsuite.fulfillment"
    #hidden: yes
    type: time
    timeframes: [raw, date, hour_of_day, day_of_week, day_of_month, week, week_of_year, month, month_name, quarter, quarter_of_year, year]
    sql: coalesce(${TABLE}.IN_HAND_SLA, ${fulfilled_F_raw}) ;;
   ## sql: CASE WHEN ${fedex_tracking.fedex_status_code} IS NOT NULL AND ${fedex_tracking.completed} then  ${fedex_tracking.status_ts_time}
   ##          WHEN ${fedex_tracking.fedex_status_code} IS NOT NULL AND ${fedex_tracking.completed} = 'No' then null
   ##        ELSE ${fulfilled_F_raw} END ;; --Pending better fedex join. 9-27-21
    }

  dimension_group: fulfilled_F {
    hidden: yes
    type: time
    timeframes: [raw, date, day_of_week, day_of_month, week, week_of_year, month, month_name, quarter, quarter_of_year, year]
    convert_tz: no
    datatype: timestamp
    sql:to_timestamp_ntz(${TABLE}.fulfilled) ;;  }

  parameter: timeframe_picker{
    hidden: yes
    label: "Date Granularity Fulfillment"
    type: string
    allowed_value: { value: "Date"}
    allowed_value: { value: "Week"}
    allowed_value: { value: "Month"}
    default_value: "Date"  }

  dimension: dynamic_timeframe {
    hidden:yes
    type: date
    allow_fill: no
    sql:
      CASE When {% parameter timeframe_picker %} = 'Date' Then ${fulfilled_F_date}
        When {% parameter timeframe_picker %} = 'Week' Then ${fulfilled_F_week}
        When {% parameter timeframe_picker %} = 'Month' Then ${fulfilled_F_month}||'-01'
      END;;  }

  dimension_group: insert_ts {
    hidden: yes
    type: time
    timeframes: [date, day_of_week, day_of_month, week, week_of_year, month, month_name, quarter, quarter_of_year, year]
    sql: ${TABLE}.insert_ts ;; }

  dimension: item_id {
    hidden: yes
    type: string
    sql: case when ${TABLE}.parent_item_id = 0 or ${TABLE}.parent_item_id is null then ${TABLE}.item_id else ${TABLE}.parent_item_id end ;; }

  dimension: item_id_raw {
    hidden: yes
    type: string
    sql: ${TABLE}.item_id ;; }

  dimension: order_id {
    hidden: yes
    type: number
    sql: ${TABLE}.order_id ;; }

  dimension: parent_item_id {
    hidden: yes
    type: number
    sql: ${TABLE}.parent_item_id ;; }

  measure: Fulfillment_record_quantity {
    hidden: yes
    type: sum
    sql: ${TABLE}.quantity ;; }

  dimension: fulfillment_record_quantity_dim {
    type: number
    hidden: yes
    sql: ${TABLE}.quantity ;; }

  dimension: bundle_quantity_dim {
    type: number
    hidden: yes
    sql: ${TABLE}.BUNDLE_QUANTITY ;;
  }

  dimension: shipping {
    hidden: yes
    type: number
    sql: ${TABLE}.shipping ;; }

  dimension: system {
    hidden: yes
    type: string
    sql: ${TABLE}.system ;; }

  dimension: tranid {
    hidden: yes
    type: number
    value_format_name: id
    sql: ${TABLE}.tranid ;; }

  dimension_group: update_ts {
    hidden: yes
    type: time
    timeframes: [date, day_of_week, day_of_month, week, week_of_year, month, month_name, quarter, quarter_of_year, year]
    sql: ${TABLE}.update_ts ;; }

  dimension: tracking_numbers {
    group_label: " Advanced"
    label: "Tracking Numbers"
    description: "Carrier tracking numbers. Source:netsuite.fulfillment"
    type: string
    sql: ${TABLE}.tracking_numbers ;;}

  measure: count {
    group_label: " Advanced"
    label: "Units Fulfilled"
    description: "Count of items fulfilled. Source:netsuite.fulfillment"
    #hidden: yes
    type: sum
    drill_fields: [sales_order_line.fulfillment_details*]
    sql_distinct_key: NVL(${sales_order.order_system},'0')||NVL(${sales_order_line.item_order},'0')||NVL(${PK},'0') ;;
    sql: case when ${sales_order.transaction_type} = 'Cash Sale' or ${sales_order.source} in ('Amazon-FBA-US','Amazon-FBA-CA') then ${sales_order_line.total_units_raw}
      when nvl(${TABLE}.BUNDLE_QUANTITY,0) > 0 then ${TABLE}.BUNDLE_QUANTITY
      else ${TABLE}.quantity END ;;}

  measure: bundle_count {
    group_label: " Advanced"
    label: "Bundeled Units Fulfilled"
    description: "Count of bundles fulfilled, if an item was fullfiled without a bundle the value is the fulfilled units. Source:looker calculation"
    #hidden: yes
    type: sum
    sql_distinct_key: NVL(${sales_order.order_system},'0')||NVL(${sales_order_line.item_order},'0')||NVL(${PK},'0') ;;
    sql: case when ${sales_order.transaction_type} = 'Cash Sale' or ${sales_order.source} in ('Amazon-FBA-US','Amazon-FBA-CA') then ${sales_order_line.total_units_raw}
      when nvl(${TABLE}.BUNDLE_QUANTITY,0) = 0 then ${TABLE}.quantity
      else ${TABLE}.BUNDLE_QUANTITY end  ;;}

  measure: bundle_quantity {
    type: sum
    hidden: yes
    sql: ${TABLE}.BUNDLE_QUANTITY ;;
  }

#BUNDLE_QUANTITY

  measure: total_shipping {
    group_label: " Advanced"
    label: "Total Direct Shipping Costs"
    #hidden: yes
    sql_distinct_key: NVL(${sales_order.order_system},'0')||NVL(${sales_order_line.item_order},'0')||NVL(${PK},'0') ;;
    description: "Direct shipping costs incurred, not including last-mile or other transfer costs. Source: netsuite.fulfillment"
    type: sum
    sql: ${TABLE}.shipping ;; }

}
