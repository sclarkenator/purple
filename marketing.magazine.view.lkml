view: marketing_magazine {
  sql_table_name: customer_care.rpt_skill_with_disposition_count ;;

  dimension: agent {
    type: string
    sql: ${TABLE}.agent ;;}

  dimension_group: reported {
    label: "Reported"
    type: time
    timeframes: [raw, date, day_of_week, day_of_month, week, week_of_year, month, month_name, quarter, quarter_of_year, year]
    convert_tz: no
    datatype: timestamp
    sql: to_timestamp_ntz(${TABLE}.reported) ;; }

  dimension_group: captured {
    label: "Captured"
    type: time
    timeframes: [raw, date, day_of_week, day_of_month, week, week_of_year, month, month_name, quarter, quarter_of_year, year]
    convert_tz: no
    datatype: timestamp
    sql: to_timestamp_ntz(${TABLE}.captured) ;; }

  dimension: disposition {
    type: string
    sql: ${TABLE}.disposition ;;}

  dimension: skill {
    type: string
    sql: Lower(${TABLE}.skill) ;;}

  dimension: contact_info_from {
    label: "Caller's Number"
    type: string
    sql: ${TABLE}.contact_info_from ;;}

  dimension: contact_info_to {
    label: "Number Called"
    type: string
    sql: ${TABLE}.contact_info_to ;;}

  measure: handle_time {
    type: sum
    sql: ${TABLE}.handle_time ;;}

  measure: AVG_INQUEUE_TIME {
    type: sum
    sql: ${TABLE}.AVG_INQUEUE_TIME ;;}

  measure: ABANDON_TIME {
    type: sum
    sql: ${TABLE}.ABANDON_TIME ;;}

  measure: HOLD_TIME {
    type: sum
    sql: ${TABLE}.HOLD_TIME ;;}

  measure: ACW_TIME {
    type: sum
    sql: ${TABLE}.ACW_TIME ;;}

  measure: count {
    type:  count
  }
  dimension: primary_key {
    primary_key: yes
    sql: CONCAT(${TABLE}.captured_date,${TABLE}.contact_info_from,${TABLE}.HOLD_TIME) ;;
    #NOT STRICTLY UNIQUE, COULD BE DUPLICATES
  }

}
