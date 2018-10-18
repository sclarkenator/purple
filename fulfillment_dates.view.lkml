view: fulfillment_dates {

  derived_table: {
    sql: -- calculating the difference in fulfillment dates from each other and order date
      SELECT
        order_id
        , datediff(day, order_date, first_ff) days_to_ff
        , datediff(day, first_ff, last_ff) days_between_ff
        , datediff(day, order_date, last_ff) days_to_last_ff
      FROM (
        -- aggregating sol to 1 row per order with dates
        SELECT order_id
          , MIN(order_date) order_date
          , MIN(fulfillment) first_ff
          , MAX(fulfillment) last_ff
        FROM sales_order_line sol
        GROUP BY order_id
      );;
    }

  measure: days_to_ff {
    label: "Days to Fulfillment"
    description: "A calculations between the order date and first item fulfilled"
    type:  sum   #sum??
    sql:${TABLE}.days_to_ff ;;
  }

  measure: days_between_ff {
    label: "Days between Fulfillment"
    description: "A calculations between the first item and last item fulfilled"
    type:  sum   #sum??
    sql:${TABLE}.days_between_ff ;;
  }

  measure: days_to_last_ff {
    label: "Days to the last Fulfilled item"
    description: "A calculations between the order date and last item fulfilled"
    type:  sum   #sum??
    sql:${TABLE}.days_to_last_ff ;;
  }

  dimension: order_id {
    primary_key: yes
    hidden: yes
    type:  number
    sql: ${TABLE}.order_id ;;
  }

  dimension: days_to_ff_tier {
    label: "Tier for days between order date and first item fulfilled"
    description: "Bucketing the caclulation between order date and first item fulfilled"
    type: tier
    #style: integer
    tiers: [0,1,3,7,14,21,28]
    sql: ${TABLE}.days_to_ff;;
  }

  dimension: days_between_ff_tier {
    label: "Tier for days between first and last item fulfilled"
    description: "Bucketing the caclulation between the first and last item fulfilled"
    type: tier
    #style: integer
    tiers: [0,1,3,7,14,21,28]
    sql: ${TABLE}.days_between_ff_tier;;
  }

  dimension: days_to_last_ff_tier {
    label: "Tier for days between order date and last item fulfilled"
    description: "Bucketing the caclulation between the order date and last item fulfilled"
    type: tier
    #style: integer
    tiers: [0,1,3,7,14,21,28]
    sql: ${TABLE}.days_to_last_ff;;
  }

}
