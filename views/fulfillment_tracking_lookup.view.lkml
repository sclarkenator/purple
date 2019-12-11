view: fulfillment_tracking_lookup {
  # Or, you could make this view a derived table, like this:
  derived_table: {
    sql: select order_id, item_id, trim(tr.value)::string as tracking_number
        from analytics.sales.fulfillment,
        lateral flatten(input=>split(tracking_numbers, ',')) tr ;;
  }

  # Define your dimensions and measures here, like this:
  dimension: order_id {
    type: string
    sql: ${TABLE}.order_id ;;
    primary_key: yes
  }

  dimension: item_id {
    type: string
    sql: ${TABLE}.item_id ;;
  }

  dimension: tracking_number {
    type: string
    sql: ${TABLE}.tracking_number ;;
  }


}
