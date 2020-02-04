
  view: heap_all_events_subset {
    #This view contains only the information related to the heap events: add to cart, purchase, and email capture
    derived_table: {
      sql:
      select *
      from analytics.heap.all_events
      where event_table_name in ('checkout_submit_customer_info','cart_add_to_cart','cart_mattress_add_to_cart','product_detail_page_pdp_add_to_cart','purchase') ;;
    }

    dimension: event_id {
      description: "ID number for each event"
      view_label: "Sessions"
      group_label: "Events"
      type: string
      sql: ${TABLE}.event_id ;;
    }

    dimension: time {
      description: "Date Time of event"
      view_label: "Sessions"
      group_label: "Events"
      type: date_time
      sql: ${TABLE}.time ;;
    }

    dimension: user_id {
      description: "ID number for each user"
      view_label: "Sessions"
      group_label: "Events"
      type: string
      sql: ${TABLE}.user_id ;;
    }

    dimension: session_id {
      description: "ID number for the session the event occured in"
      view_label: "Sessions"
      group_label: "Events"
      type: string
      sql: ${TABLE}.session_id ;;
    }

    dimension: event_table_name {
      description: "Name of event"
      view_label: "Sessions"
      group_label: "Events"
      type: string
      sql: ${TABLE}.event_table_name ;;
    }


  }
