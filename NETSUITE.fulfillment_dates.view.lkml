#-------------------------------------------------------------------
# Owner - Tim Schultz
# Calculating difference in dates with orders, fulfillment and
#   fulfillment of first and last items in an order.
#-------------------------------------------------------------------

view: fulfillment_dates {

  derived_table: {
    sql: -- calculating the difference in fulfillment dates from each other and order date
      SELECT
        order_id
        --, nullif(datediff(day, order_date, first_ff),0) days_to_ff
        --, nullif(datediff(day, first_ff, last_ff),0) days_between_ff
        --, nullif(datediff(day, order_date, last_ff),0) days_to_last_ff
        , datediff(day, order_date, first_ff) days_to_ff
        , datediff(day, first_ff, last_ff) days_between_ff
        , datediff(day, order_date, last_ff) days_to_last_ff
      FROM (
        -- aggregating sol to 1 row per order with dates
        SELECT sol.order_id
          , MIN(sol.created) order_date
          , MIN(coalesce(sol.fulfilled, co.cancelled, current_date())) first_ff
          , MAX(coalesce(sol.fulfilled, co.cancelled, current_date())) last_ff
        FROM sales.sales_order_line sol
        LEFT JOIN sales.cancelled_order co on co.order_id = sol.order_id and co.item_id = sol.order_id and co.system = sol.system
        GROUP BY sol.order_id
      );;
    }

  measure: days_to_ff {
    group_label: "Average Days Between"
    label: "Order to Fulfillment"
    description: "A calculations between the order date and first item fulfilled"
    type:  average   #sum??
    value_format: "#,##0.00"
    sql:${TABLE}.days_to_ff ;; }

  measure: days_between_ff {
    group_label: "Average Days Between"
    label: "First and Last Fulfillment"
    description: "A calculations between the first item and last item fulfilled"
    type:  average   #sum??
    sql:${TABLE}.days_between_ff ;; }

  measure: days_to_last_ff {
    group_label: "Average Days Between"
    label: "Order to Last Fulfilled Item"
    description: "A calculations between the order date and last item fulfilled"
    type:  average   #sum??
    sql:${TABLE}.days_to_last_ff ;; }

  dimension: order_id {
    primary_key: yes
    hidden: yes
    type:  number
    sql: ${TABLE}.order_id ;;  }

  dimension: days_to_ff_dimension {
    group_label: "Difference in Days"
    label: "Order to Fulfillment"
    description: "A calculations between the order date and first item fulfilled"
    type:  number
    sql:${TABLE}.days_to_ff ;; }

  dimension: days_between_ff_dimension {
    group_label: "Difference in Days"
    label: "First to Last Fulfillment"
    description: "A calculations between the first item and last item fulfilled"
    type:  number
    sql:${TABLE}.days_between_ff ;; }

  dimension: days_to_last_ff_dimension {
    group_label: "Difference in Days"
    label: "Order to last Fulfilled item"
    description: "A calculations between the order date and last item fulfilled"
    type:  number
    sql:${TABLE}.days_to_last_ff ;; }

  dimension: days_between_ff_sla {
    group_label: "Difference in Days"
    label: "3 Day Fulfillment SLA"
    description: "More than 3 Days between fulfillment of first and last item"
    type:  yesno
    sql: NVL(${TABLE}.days_between_ff,0) <= 3 ;; }


  dimension: days_to_ff_sla {
    group_label: "Difference in Days"
    label: "14 Day Fulfillment SLA"
    description: "More than 14 days between order date and the first fulfilled item"
    hidden: yes
    type:  yesno
    sql: NVL(${TABLE}.days_to_ff,0) <= 14 ;; }

  dimension: days_to_ff_tier {
    group_label: "Difference in Days"
    label: "Order and First Item Fulfilled (buckets)"
    description: "Bucketing the caclulation between order date and first item fulfilled (0,1,3,7,14,21,28)"
    type: tier
    style: integer
    tiers: [0,1,3,7,14,21,28]
    sql: ${TABLE}.days_to_ff;; }

  dimension: days_between_ff_tier {
    group_label: "Difference in Days"
    label: "First and Last Item Fulfilled (buckets)"
    description: "Bucketing the caclulation between the first and last item fulfilled (0,1,3,7,14,21,28)"
    type: tier
    style: integer
    tiers: [0,1,3,7,14,21,28]
    sql: ${TABLE}.days_to_ff;;  }

  dimension: days_to_last_ff_tier {
    group_label: "Difference in Days"
    label: "Order and Last Item Fulfilled (buckets)"
    description: "Bucketing the caclulation between the order date and last item fulfilled (0,1,3,7,14,21,28)"
    type: tier
    style: integer
    tiers: [0,1,2,3,4,7,14,21,28]
    sql: ${TABLE}.days_between_ff;;  }

}
