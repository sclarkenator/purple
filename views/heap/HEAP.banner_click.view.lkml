# view: heap_banner_click {
#   # You can specify the table name if it's different from the view name:
#   sql_table_name: heap_data.heap.carousel_banner_home_hero_click_hero_cta ;;

#   dimension: PK {
#     group_label: "Hero Banner"
#     type: string
#     primary_key: yes
#     hidden: yes
#     sql:  ${TABLE}.user_id||${TABLE}.session_id||${TABLE}.event_id;;
#   }

#   dimension: user_id {
#     group_label: "Hero Banner"
#     description: "Unique ID for each user that has ordered"
#     type: number
#     hidden: yes
#     sql: ${TABLE}.user_id ;;
#   }

#   dimension: event_id {
#     group_label: "Hero Banner"
#     hidden: yes
#     type: number
#     sql: ${TABLE}.event_id ;;
#   }

#   dimension: session_id {
#     group_label: "Hero Banner"
#     hidden:yes
#     type: number
#     sql: ${TABLE}.session_id ;;
#   }

#   dimension_group: time {
#     group_label: "Hero Banner"
#     hidden: yes
#     type: time
#     timeframes: [date, week, month, year]
#     sql: ${TABLE}.time ;;
#   }
#   dimension: banner_heading_click {
#     hidden: yes
#     group_label: "Hero Banner"
#     description: "Click event: clicked HERO banner, CTA (Call to Action) Source: heap.carousel_banner_home_ hero_click_hero_cta"
#     type: string
#     sql: ${TABLE}.banner_heading ;;
#   }

#   measure: banner_clicks {
#     group_label: "Hero Banner"
#     description: "Count Click event: clicked HERO banner, CTA (Call to Action) Source: heap.carousel_banner_home_ hero_click_hero_cta"
#     type: count_distinct
#     sql: ${banner_heading_click} ;;
#   }

# }
