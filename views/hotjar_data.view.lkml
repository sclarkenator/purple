#-------------------------------------------------------------------
# Owner - Scott Clark
# Hot Jar sends a survey to our customers on how they heard about us
#-------------------------------------------------------------------

view: hotjar_data {
  sql_table_name: marketing.hotjar_data ;;

  dimension: pk_hotjar {
    label: "Primary Key - Hotjar"
    primary_key: yes
    hidden: yes
    type:  string
    sql: ${TABLE}.token || ${TABLE}.how_heard ;;  }

  dimension: token {
    label: "Token"
    description: "checkout token from shopify"
    hidden:  yes
    type:  string
    sql: ${TABLE}.token ;;  }

  dimension_group: created {
    type: time
    timeframes: [date, day_of_week, day_of_month, week, week_of_year, month, month_name, quarter, quarter_of_year, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.created ;;  }

  dimension: Before_today{
    group_label: "Created Date"
    label: "z - Is Before Today (mtd)"
    description: "This field is for formatting on (week/month/quarter/year) to date reports"
    type: yesno
    sql: ${TABLE}.created < current_date;; }

  dimension: last_30{
    group_label: "Created Date"
    label: "z - Last 30 Days"
    type: yesno
    sql: ${TABLE}.created > dateadd(day,-30,current_date);; }

  dimension: current_week_num{
    group_label: "Created Date"
    label: "z - Before Current Week"
    type: yesno
    sql: date_trunc(week, ${TABLE}.created::date) = date_trunc(week, current_date) ;;}

  dimension: prev_week{
    group_label: "Created Date"
    label: "z - Previous Week"
    type: yesno
    sql:  date_trunc(week, ${TABLE}.created::date) = dateadd(week, -1, date_trunc(week, current_date)) ;; }

  dimension: cur_week{
    group_label: "Created Date"
    label: "z - Current Week"
    type: yesno
    sql: date_trunc(week, ${TABLE}.created) = date_trunc(week, current_date) ;;}

  dimension: how_heard {
    label: "How did you hear? (all)"
    description: "Ungrouped responses for how did you hear questions"
    sql: ${TABLE}.how_heard ;;  }

  dimension: heard_group {
    label: "How did you hear? (buckets)"
    description: "How did you hear about Purple? bucketed to top 12 + Other"
    case: { when: {sql: ${how_heard} = 'YouTube' ;; label: "YouTube" }
      when: { sql: ${how_heard} like 'Referral%' ;; label: "Word-of-Mouth" }
      when: { sql: ${how_heard} = 'Facebook' ;; label: "Facebook" }
      when: { sql: ${how_heard} = 'TV' ;; label: "TV" }
      when: { sql: ${how_heard} like 'Search Engine%' ;; label: "Search Engine" }
      when: { sql: ${how_heard} like 'Review We%' ;; label: "Review Website" }
      when: { sql: ${how_heard} like 'Website Ba%' ;; label: "Display Ad" }
      when: { sql: ${how_heard} like 'Already own%' ;; label: "Already own Purple"}
      when: { sql: ${how_heard} = 'Instagram' ;; label: "Instagram" }
      when: { sql: ${how_heard} = 'Amazon' ;; label: "Amazon" }
      when: { sql: ${how_heard} like 'Sirius%' ;; label: "Sirius XM" }
      when: { sql: ${how_heard} = 'Podcast' ;; label: "Podcast" }
      when: { sql: ${how_heard} ilike 'Saw in %' ;; label: "Store" }
      else: "Other" } }

  measure: count {
    type: count }

  measure: respondents {
    label: "Distinct Respondents"
    description: "Counting distinct respondents by their token"
    #hidden: yes
    type: count_distinct
    sql: ${TABLE}.token ;;  }

}
