#-------------------------------------------------------------------
# Owner - Tim Schultz
# Recreating the Heap Block so we can join addtional data
#-------------------------------------------------------------------

view: event_facts {
  sql_table_name: analytics.heap.event_facts ;;
  # derived_table: {
  #   sql:  analytics.heap.event_facts ;;
#     sql: WITH
#         event_count AS (
#             SELECT
#               event_table_name
#               , COUNT(*) AS cardinality
#             FROM heap.all_events
#             WHERE TIME > DATEADD('day', - 30, current_date())
#             GROUP BY 1
#         )
#         , all_events AS (
#             SELECT
#               DISTINCT all_events.event_id
#               , all_events.user_id AS user_id
#               , all_events.session_id
#               , all_events.event_table_name AS event_name
#               , all_events.TIME AS occurred_at
#               , event_count.cardinality
#             FROM heap.all_events AS all_events
#             LEFT JOIN event_count
#               ON all_events.event_table_name = event_count.event_table_name
#         )
#         , events AS (
#             SELECT
#                all_events.event_id
#               , all_events.event_name
#               , ROW_NUMBER() OVER(PARTITION BY all_events.session_id, all_events.user_id ORDER BY all_events.occurred_at) AS sequence_number_for_event_flow
#             FROM all_events
#             INNER JOIN (
#                   SELECT
#                     event_id
#                     , user_id
#                     , MIN(cardinality) AS cardinality
#                   FROM all_events
#                   GROUP BY 1,2
#             ) AS event
#                 ON all_events.cardinality = event.cardinality
#                 AND all_events.event_id = event.event_id
#                 AND all_events.user_id = event.user_id
#         )
#       SELECT a.event_id
#             , a.event_table_name AS event_name
#             , a.event_id || '-' || a.event_table_name AS unique_event_id
#             , a.user_id
#             , a.session_id
#             , events.sequence_number_for_event_flow AS sequence_number_for_event_flow
#             , ROW_NUMBER() OVER(PARTITION BY a.session_id, a.user_id ORDER BY a."TIME") AS event_sequence_number
#       FROM heap.all_events AS a
#       LEFT JOIN events
#         ON events.event_id = a.event_id
#         AND events.event_name = a.event_table_name
#        ;;
#      datagroup_trigger: pdt_refresh_6am
    # }


  measure: count {
    type: count
    drill_fields: [event_name, count] }

  dimension: unique_event_id {
    hidden:  yes
    primary_key: yes
    sql: ${TABLE}.unique_event_id ;; }

  dimension: event_id {
    hidden: yes
    type: number
    sql: ${TABLE}.event_id ;; }

  dimension: event_name {
    label: "Event Name"
    type: string
    sql: ${TABLE}.event_name ;; }

  dimension: user_id {
    hidden: yes
    type: number
    sql: ${TABLE}.user_id ;; }

  dimension: session_id {
    hidden: yes
    type: number
    sql: ${TABLE}.session_id ;; }

  dimension: event_sequence_number {
    label: "Event Sequence Number"
    type: number
    sql: ${TABLE}.event_sequence_number ;; }

  dimension: sequence_number_for_event_flow {
    hidden: yes
    type: number
    sql: ${TABLE}.sequence_number_for_event_flow ;; }

}
