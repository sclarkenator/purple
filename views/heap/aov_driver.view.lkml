view: aov_driver {
   derived_table: {
      sql: select session_id
        ,user_id
        ,chose_aov_Driver
      from HEAP_DATA.HEAP.CART_ADD_TO_CART ;;
    persist_for: "12 hours"   }

   dimension: user_id {
    hidden: yes
    description: "Unique ID for each user that has ordered"
    type: number
    sql: ${TABLE}.user_id ;; }

    dimension: session_id {
      hidden: yes
      description: "session ID for site visit"
      type: number
      sql: ${TABLE}.session_id ;; }

   dimension: chose_aov_driver {
     description: "Were items added from AOV driver section"
     type: yesno
     sql: ${TABLE}.chose_aov_driver ;; }

  dimension: pk {
    primary_key: yes
    hidden: yes
    sql: ${TABLE}.pk ;; }
 }
