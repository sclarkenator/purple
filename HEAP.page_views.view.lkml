#-------------------------------------------------------------------
# Owner - Tim Schultz
# Recreating the Heap Block so we can join addtional data
#-------------------------------------------------------------------

view: heap_page_views {
  derived_table: {
    sql:
      select session_id,
        count(event_id) as pages_viewed
      from analytics.heap.pageviews
      --where time::date >=  '2019-06-16' and time::date <=  '2019-06-22'
      group by session_id ;;
  }

  dimension: session_id {
    primary_key: yes
    hidden: yes
    sql: ${TABLE}.session_id ;; }


  dimension: pages_viewed {
    label: "Pages Viewed"
    description: "Pages viewed per session"
    view_label: "Sessions"
    type: number
    sql: ${TABLE}.pages_viewed ;;}

  dimension: bounced {
    label: "Bounced"
    description: "Only viewed 1 page"
    view_label: "Sessions"
    type: yesno
    sql: ${TABLE}.pages_viewed < 2 ;;}

  dimension: query {
    label: "Query - tag string"
    description: "The whole tag string after purple.com."
    view_label: "Sessions"
    type: string
    sql: ${TABLE}.query;;}

#query
}
