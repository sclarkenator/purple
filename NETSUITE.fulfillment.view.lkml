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
    sql:  NVL(${TABLE}.FULFILLMENT_ID,'0') ||'-'|| NVL(${TABLE}.item_id,'0') || NVL(${TABLE}.parent_item_id,'0') ;;
    }

  dimension: fulfillment_id {
    hidden: yes
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
    label: "   Carrier (actual)"
    #hidden: yes
    description: "Shipping provider was used to fulfill this part of the order"
    type: string
    sql: ${TABLE}.carrier ;;  }

  dimension_group: created {
    label: "Fulfilled Date (V2)"
    #hidden: yes
    type: time
    timeframes: [raw, date, day_of_week, day_of_month, week, week_of_year, month, month_name, quarter, quarter_of_year, year]
    sql: ${TABLE}.created ;; }

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
    description: "Carrier tracking numbers"
    type: string
    sql: ${TABLE}.tracking_numbers ;;}

  measure: count {
    label: "Units fulfilled"
    description: "Count of items fulfilled"
    #hidden: yes
    type: sum
    sql: ${TABLE}.quantity ;;}

  measure: bundle_count {
    group_label: " Advanced"
    label: "Bundeled Units Fulfilled"
    description: "Count of bundles fulfilled, if an item was fullfiled without a bundle the value is the fulfilled units"
    #hidden: yes
    type: sum
    sql: case when ${TABLE}.BUNDLE_QUANTITY = 0 then ${TABLE}.quantity else ${TABLE}.BUNDLE_QUANTITY end  ;;}

#BUNDLE_QUANTITY

  measure: total_shipping {
    label: "Total Direct Shipping Costs"
    #hidden: yes
    description: "Direct shipping costs incurred, not including last-mile or other transfer costs"
    type: sum
    sql: ${TABLE}.shipping ;; }

}
