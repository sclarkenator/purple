#-------------------------------------------------------------------
# Owner - Jonathan Stratton
# Inventory both current and historical
#-------------------------------------------------------------------

view: inventory_snap {
  sql_table_name: PRODUCTION.INVENTORY_SNAP ;;

  measure: available {
    label: "Total Available"
    type: sum
    sql: ${TABLE}.available ;;  }

  measure: average_cost {
    label: "Total Average Cost"
    description: "Summing the average cost field"
    type: sum
    sql: ${TABLE}.average_cost ;; }

  measure: backordered {
    label: "Total Backordered"
    type: sum
    sql: ${TABLE}.backordered ;; }

  dimension_group: created {
    label: "Created"
    type: time
    timeframes: [ raw, hour_of_day, time, date, day_of_week, day_of_month, week, week_of_year, month, month_name, quarter, quarter_of_year, year]
    sql: ${TABLE}.created ;; }

  dimension: week_bucket{
    group_label: "Created Date"
    label: "z - Week Bucket"
    description: "Grouping by week, for comparing last week, to the week before, to last year"
    type: string
    sql: case when date_part('year', ${TABLE}.created::date) = date_part('year', current_date) and date_part('week',${TABLE}.created::date) = date_part('week', current_date) then 'Current Week'
        when date_part('year', ${TABLE}.created::date) = date_part('year', current_date) and date_part('week',${TABLE}.created::date) = date_part('week', current_date) -1 then 'Last Week'
        when date_part('year', ${TABLE}.created::date) = date_part('year', current_date) and date_part('week',${TABLE}.created::date) = date_part('week', current_date) -2 then 'Two Weeks Ago'
        when date_part('year', ${TABLE}.created::date) = date_part('year', current_date) -1 and date_part('week',${TABLE}.created::date) = date_part('week', current_date) then 'Current Week LY'
        when date_part('year', ${TABLE}.created::date) = date_part('year', current_date) -1 and date_part('week',${TABLE}.created::date) = date_part('week', current_date) -1 then 'Last Week LY'
        when date_part('year', ${TABLE}.created::date) = date_part('year', current_date) -1 and date_part('week',${TABLE}.created::date) = date_part('week', current_date) -2 then 'Two Weeks Ago LY'
        else 'Other' end;; }

  measure: inbound {
    label: "Total Inbound"
    type: sum
    sql: ${TABLE}.inbound ;; }

  dimension: item_id {
    label: "Item ID"
    description: "Internal Netsuite ID"
    type: number
    sql: ${TABLE}.item_id ;; }

  dimension: location_id {
    hidden: yes
    type: number
    sql: ${TABLE}.location_id ;; }

  measure: on_hand {
    label: "Total On Hand"
    type: sum
    sql: ${TABLE}.on_hand ;; }

  measure: on_order {
    label: "Total On Order"
    type: sum
    sql: ${TABLE}.on_order ;; }

  measure: outbound {
    label: "Total Outbound"
    type: sum
    sql: ${TABLE}.outbound ;; }

  dimension: preferred_stock_level {
    label: "Preferred Stock Level"
    type: number
    sql: ${TABLE}.preferred_stock_level ;; }

  dimension: primary_key {
    primary_key: yes
    sql: CONCAT(${TABLE}.location_id,${TABLE}.item_id,${TABLE}.on_hand, ${TABLE}.available) ;;
    #NOT STRICTLY UNIQUE, COULD BE DUPLICATES
  }

}
