#-------------------------------------------------------------------
# Owner - Scott Clark
# Fulfillment
#-------------------------------------------------------------------

view: fulfillment {
  sql_table_name: SALES.FULFILLMENT ;;

  dimension: PK {
    primary_key: yes
    hidden: yes
    type: number
    sql: ${TABLE}."FULFILLMENT_ID"||'-'||${TABLE}.item_id||${TABLE}.parent_item_id ;;  }

  dimension: carrier {
    label: "Carrier (actual)"
    description: "Shipping provider was used to fulfill this part of the order"
    type: string
    sql: ${TABLE}.carrier ;;  }

  dimension_group: created {
    hidden: yes
    type: time
    timeframes: [date, day_of_week, day_of_month, week, week_of_year, month, month_name, quarter, quarter_of_year, year]
    sql: ${TABLE}.created ;; }

  dimension_group: fulfilled_F {
    hidden: yes
    type: time
    timeframes: [date, day_of_week, day_of_month, week, week_of_year, month, month_name, quarter, quarter_of_year, year]
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
    type: number
    sql: ${TABLE}.item_id ;; }

  dimension: order_id {
    hidden: yes
    type: number
    sql: ${TABLE}.order_id ;; }

  dimension: parent_item_id {
    hidden: yes
    type: number
    sql: ${TABLE}.parent_item_id ;; }

  dimension: quantity {
    hidden: yes
    type: number
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
    type: string
    sql: ${TABLE}.tracking_numbers ;;}

  measure: count {
    label: "Fulfilled Count"
    description: "Count of unique items fulfilled"
    #hidden: yes
    type: count}

  measure: total_shipping {
    label: "Total Direct Shipping Costs"
    hidden: yes
    description: "Direct shipping costs incurred, not including last-mile or other transfer costs"
    type: sum
    sql: ${TABLE}.shipping ;; }

}
