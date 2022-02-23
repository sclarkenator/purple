# The name of this view in Looker is "Slt Logistics"
view: slt_logistics {
  # The sql_table_name parameter indicates the underlying database table
  # to be used for all fields in this view.
  sql_table_name: "PRODUCTION"."SLT_LOGISTICS"
    ;;
  # No primary key is defined for this view. In order to join this view in an Explore,
  # define primary_key: yes on a dimension that has no repeated values.

  # Here's what a typical dimension looks like in LookML.
  # A dimension is a groupable field that can be used to filter query results.
  # This dimension will be called "Containers Arrived Pending Unload" in Explore.

  dimension: containers_arrived_pending_unload {
    hidden: yes
    type: number
    sql: ${TABLE}."CONTAINERS_ARRIVED_PENDING_UNLOAD" ;;
  }

  # A measure is a field that uses a SQL aggregate function. Here are defined sum and average
  # measures for this dimension, but you can also add measures of many different aggregates.
  # Click on the type parameter to see all the options in the Quick Help panel on the right.

  measure: total_containers_arrived_pending_unload {
    group_label: "Totals"
    label: "Containers Pending Unload"
    type: sum
    sql: ${containers_arrived_pending_unload} ;;
  }

  measure: average_containers_arrived_pending_unload {
    group_label: "Averages"
    label: "Containers Pending Unload"
    type: average
    sql: ${containers_arrived_pending_unload} ;;
  }

  dimension: containers_in_yard_with_oos {
    hidden: yes
    type: number
    sql: ${TABLE}."CONTAINERS_IN_YARD_WITH_OOS" ;;
  }

  measure: total_containers_in_yard_with_oos{
    group_label: "Totals"
    label: "Containers in Yard w/Out of Stock Items"
    type: sum
    sql: ${containers_in_yard_with_oos} ;;
  }

  measure: average_containers_in_yard_with_oos {
    group_label: "Averages"
    label: "Containers in Yard w/Out of Stock Items"
    type: average
    sql: ${containers_in_yard_with_oos} ;;
  }

  dimension: fedex_trailers_picked_up {
    hidden: yes
    type: number
    sql: ${TABLE}."FEDEX_TRAILERS_PICKED_UP" ;;
  }

  measure: total_fedex_trailers_picked_up {
    group_label: "Totals"
    label: "Fedex Trailers Picked Up"
    type: sum
    sql: ${fedex_trailers_picked_up} ;;
  }

  measure: average_fedex_trailers_picked_up {
    group_label: "Averages"
    label: "Fedex Trailers Picked Up"
    type: average
    sql: ${fedex_trailers_picked_up} ;;
  }

  dimension: inbound_shipments_departed {
    hidden: yes
    type: number
    sql: ${TABLE}."INBOUND_SHIPMENTS_DEPARTED" ;;
  }

  measure: total_inbound_shipments_departed {
    group_label: "Totals"
    label: "Inbound Shipments Departed"
    type: sum
    sql: ${inbound_shipments_departed} ;;
  }

  measure: average_inbound_shipments_departed {
    group_label: "Averages"
    label: "Inbound Shipments Departed"
    type: average
    sql: ${inbound_shipments_departed} ;;
  }

  # Dates and timestamps can be represented in Looker using a dimension group of type: time.
  # Looker converts dates and timestamps to the specified timeframes within the dimension group.

  dimension_group: insert_ts {
    hidden: yes
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: CAST(${TABLE}."INSERT_TS" AS TIMESTAMP_NTZ) ;;
  }

  dimension: oldest_container_in_yard_days {
    hidden:  yes
    type: number
    sql: ${TABLE}."OLDEST_CONTAINER_IN_YARD_DAYS" ;;
  }

  measure: total_oldest_container_in_yard_days {
    group_label: "Totals"
    label: "Oldest Container Age (days)"
    type: sum
    sql: ${oldest_container_in_yard_days} ;;
  }

  measure: average_oldest_container_in_yard_days {
    group_label: "Averages"
    label: "Oldest Container Age (days)"
    type: average
    sql: ${oldest_container_in_yard_days} ;;
  }

  dimension: oos_item {
    label: "Out of Stock Items"
    type: string
    sql: ${TABLE}."OOS_ITEM" ;;
  }

  dimension_group: report {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}."REPORT_DATE" ;;
  }

  dimension: site {
    label: "Site Name"
    type: string
    sql: ${TABLE}."SITE" ;;
  }

  dimension: to_ftl {
    hidden: yes
    type: number
    sql: ${TABLE}."TO_FTL" ;;
  }

  measure: total_to_ftl {
    group_label: "Totals"
    label: "TO FTLs"
    type: sum
    sql: ${to_ftl} ;;
  }

  measure: average_to_ftl {
    group_label: "Averages"
    label: "TO FTLs"
    type: average
    sql: ${to_ftl} ;;
  }

  dimension: to_ltl {
    hidden:  yes
    type: number
    sql: ${TABLE}."TO_LTL" ;;
  }

  measure: total_to_ltl {
    group_label: "Totals"
    label: "TO LTLs"
    type: sum
    sql: ${to_ltl} ;;
  }

  measure: average_to_ltl {
    group_label: "Averages"
    label: "TO LTLs"
    type: average
    sql: ${to_ltl} ;;
  }

  dimension: to_mattresses_shipped {
    hidden:  yes
    type: number
    sql: ${TABLE}."TO_MATTRESSES_SHIPPED" ;;
  }

  measure: total_to_mattresses_shipped {
    group_label: "Totals"
    label: "TO Mattresses Shipped"
    type: sum
    sql: ${to_mattresses_shipped} ;;
  }

  measure: average_to_mattresses_shipped {
    group_label: "Averages"
    label: "TO Mattresses Shipped"
    type: average
    sql: ${to_mattresses_shipped} ;;
  }

  dimension: inbound_loads {
    hidden: yes
    type: number
    sql: ${TABLE}."TOTAL_INBOUND_LOADS" ;;
  }

  measure: total_inbound_loads {
    group_label: "Totals"
    label: "Inbound Loads"
    type: sum
    sql: ${inbound_loads} ;;
  }

  measure: average_inbound_loads {
    group_label: "Averages"
    label: "Inbound Loads"
    type: average
    sql: ${inbound_loads} ;;
  }

  dimension: ups_trailers_picked_up {
    hidden: yes
    type: number
    sql: ${TABLE}."UPS_TRAILERS_PICKED_UP" ;;
  }

  measure: total_ups_trailers_picked_up {
    group_label: "Totals"
    label: "UPS Trailers Picked Up"
    type: sum
    sql: ${ups_trailers_picked_up} ;;
  }

  measure: average_ups_trailers_picked_up {
    group_label: "Averages"
    label: "UPS Trailers Picked Up"
    type: average
    sql: ${ups_trailers_picked_up} ;;
  }

  dimension: wholesale_ftl {
    hidden: yes
    type: number
    sql: ${TABLE}."WHOLESALE_FTL" ;;
  }

  measure: total_wholesale_ftl {
    group_label: "Totals"
    label: "Wholesale FTLs"
    type: sum
    sql: ${wholesale_ftl} ;;
  }

  measure: average_wholesale_ftl {
    group_label: "Averages"
    label: "Wholesale FTLs"
    type: average
    sql: ${wholesale_ftl} ;;
  }

  dimension: wholesale_ltl {
    hidden: yes
    type: number
    sql: ${TABLE}."WHOLESALE_LTL" ;;
  }

  measure: total_wholesale_ltl {
    group_label: "Totals"
    label: "Wholesale LTLs"
    type: sum
    sql: ${wholesale_ltl} ;;
  }

  measure: average_wholesale_ltl {
    group_label: "Averages"
    label: "Wholesale LTLs"
    type: average
    sql: ${wholesale_ltl} ;;
  }

  dimension: yard_moves {
    hidden: yes
    type: number
    sql: ${TABLE}."YARD_MOVES" ;;
  }

  measure: total_yard_moves {
    group_label: "Totals"
    label: "Yard Moves"
    type: sum
    sql: ${yard_moves} ;;
  }

  measure: average_yard_moves {
    group_label: "Averages"
    label: "Yard Moves"
    type: average
    sql: ${yard_moves} ;;
  }

  measure: count {
    hidden: yes
    type: count
    drill_fields: []
  }
}
