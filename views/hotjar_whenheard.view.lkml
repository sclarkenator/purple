#-------------------------------------------------------------------
# Owner - Scott Clark
# Hot Jar sends a survey to our customers on how they heard about us
#-------------------------------------------------------------------

view: hotjar_whenheard {
  sql_table_name: MARKETING.HOTJAR_WHENHEARD ;;

  dimension: first_heard {
    hidden:  yes
    type: string
    sql: ${TABLE}."FIRST_HEARD" ;; }

  dimension: first_hrd {
    description: "When did you first hear about Purple? (1w,2w,1m,2m,3m,6m,1yr,+)"
    label: "First Heard (buckets)"
    case: { when: { sql: ${TABLE}."FIRST_HEARD" = 'Today' ;;  label: "Today" }
      when: { sql: ${TABLE}."FIRST_HEARD" = 'Less than 1 week ago' ;; label: "<1 week" }
      when: { sql: ${TABLE}."FIRST_HEARD" = 'Less than 2 weeks ago' ;; label: "<2 weeks" }
      when: { sql: ${TABLE}."FIRST_HEARD" = 'Less than 1 month ago' ;; label: "<1 mo" }
      when: { sql: ${TABLE}."FIRST_HEARD" = 'Less than 2 months ago' ;; label: "<2 mo" }
      when: { sql: ${TABLE}."FIRST_HEARD" = 'Less than 3 months ago' ;; label: "<3 mo" }
      when: { sql: ${TABLE}."FIRST_HEARD" = 'Less than 6 months ago' ;; label: "<6 mo" }
      when: { sql: ${TABLE}."FIRST_HEARD" = 'Less than 1 year ago' ;; label: "<1 yr" }
      when: { sql: ${TABLE}."FIRST_HEARD" = 'More than 1 year ago' ;; label: "1+ yr" } } }

  dimension: how_time {
    hidden:  yes
    type: string
    sql: ${TABLE}."HOW_TIME" ;; }

  dimension: shop_time {
    description: "How long have you been shopping for this product? (1w,2w,1m,2m,3m,6m,1yr,+)"
    label: "Shop Time (buckets)"
    case: { when: { sql: ${TABLE}."HOW_TIME" = 'Today' ;; label: "Today" }
      when: { sql: ${TABLE}."HOW_TIME" = 'Less than 1 week' ;; label: "<1 week" }
      when: { sql: ${TABLE}."HOW_TIME" = 'Less than 2 weeks' ;; label: "<2 weeks" }
      when: { sql: ${TABLE}."HOW_TIME" = 'Less than 1 month' ;; label: "<1 mo" }
      when: { sql: ${TABLE}."HOW_TIME" = 'Less than 2 months' ;; label: "<2 mo" }
      when: { sql: ${TABLE}."HOW_TIME" = 'Less than 3 months' ;; label: "<3 mo" }
      when: { sql: ${TABLE}."HOW_TIME" = 'Less than 6 months' ;; label: "<6 mo" }
      when: { sql: ${TABLE}."HOW_TIME" = 'Less than 1 year' ;; label: "<1 yr" }
      when: { sql: ${TABLE}."HOW_TIME" = 'More than 1 year' ;; label: "1+ yr" } } }

  dimension: token {
    type: string
    hidden: yes
    primary_key: yes
    sql: ${TABLE}."TOKEN" ;; }

  measure: count {
    hidden: yes
    type: count }

}
