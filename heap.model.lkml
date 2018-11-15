connection: "heap_redshift"

include: "*.view.lkml"                       # include all views in this project


#-------------------------------------------------------------------
#  All Events-----
#     \           \
#     Users      Sessions
#                    \
#                   City to Zip
#                      \
#                      DMA
#-------------------------------------------------------------------

explore: all_events {
  hidden: yes
  label: "All Events (heap)"
  group_label: "Marketing"
  description: "All Website Event Data from Heap Block"

  join: users {
    type: left_outer
    sql_on: ${all_events.user_id} = ${users.user_id} ;;
    relationship: many_to_one }

  join: sessions {
    type: left_outer
    sql_on: ${all_events.session_id} = ${sessions.session_id} ;;
    relationship: many_to_one }

  join: zip_codes_city {
    type: left_outer
    sql_on: ${sessions.city} = ${zip_codes_city.city} ;;
    relationship: one_to_one }

  join: dma {
    type:  left_outer
    sql_on: ${dma.zip} = ${zip_codes_city.city_zip} ;;
    relationship: one_to_one
  }
}
