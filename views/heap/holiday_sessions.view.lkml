view: holiday_sessions {

   sql_table_name: heap.v_holiday_sessions ;;

  dimension: session_id {
    hidden: yes
    type: string
    sql: ${TABLE}.session_id ;;
  }

  dimension: referrer {
    hidden: yes
    label: " Referrer"
    description: "Source: HEAP.sessions"
    type: string
    sql: ${TABLE}.referrer_raw;;
  }

  dimension: referrer_2 {
    group_label: "Session details"
    label: " Referrer (grouped)"
    description: "Source: looker calculation"
    type: string
    sql: ${TABLE}.referrer ;;
  }

  dimension: utm_medium {
    group_label: "Session details"
    label: "UTM Medium"
    description: "Source: HEAP.sessions"
    type: string
    sql: ${TABLE}.utm_medium ;;
  }

  dimension: channel {
    type: string
    group_label: "Session details"
    hidden:  no
    label: " Channel"
    description: "Channel that current session came from. Source: looker calculation"
    sql: ${TABLE}.channel ;;
  }

  dimension: medium_bucket {
    label: "Medium"
    group_label: "Session details"
    description: "Source: looker calculation"
    type: string
    #hidden: yes
    sql: ${TABLE}.medium_bucket ;;
  }

  dimension: utm_source {
    hidden: no
    group_label: "Session details"
    label: "UTM Source"
    description: "Source: HEAP.sessions"
    type: string
    sql: ${TABLE}.utm_source ;;
  }

  dimension: source_bucket {
    label: "Source"
    group_label: "Session details"
    description: "Source: looker calculation"
    type: string
    #hidden: yes
    sql: ${TABLE}.source_bucket ;;
  }

}
