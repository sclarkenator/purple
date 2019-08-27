#-------------------------------------------------------------------
# Owner - Jonathan Stratton
# Max Machine Capacity
#-------------------------------------------------------------------

view: max_machine_capacity {
  sql_table_name: PRODUCTION.MAX_MACHINE_CAPACITY ;;

  dimension_group: date {
    type: time
    timeframes:  [date, day_of_week, day_of_month, week, week_of_year, month, month_name, quarter, quarter_of_year, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.date ;; }

  dimension: max_1_capacity {
    label: "Max 1 Capacity"
    type: number
    sql: ${TABLE}.max_1_capacity ;; }

  dimension: max_2_capacity {
    label: "Max 2 Capacity"
    type: number
    sql: ${TABLE}.max_2_capacity ;; }

  dimension: max_3_capacity {
    label: "Max 3 Capacity"
    type: number
    sql: ${TABLE}.max_3_capacity ;; }

  dimension: max_4_capacity {
    label: "Max 4 Capacity"
    type: number
    sql: ${TABLE}.max_4_capacity ;; }

  measure: count {
    type: count
    hidden: yes }

  measure: total_max_machine_capacity {
    type: sum
    description: "Total Capacity of all Max machines"
    sql: ${TABLE}.max_1_capacity + ${TABLE}.max_2_capacity + ${TABLE}.max_3_capacity  +${TABLE}.max_4_capacity ;; }


  dimension: primary_key {
    primary_key: yes
    sql: CONCAT(${TABLE}.date_date,${TABLE}.total_max_machine_capacity,${TABLE}.max_1_capacity,${TABLE}.max_2_capacity) ;;
    #NOT STRICTLY UNIQUE, COULD BE DUPLICATES
  }

}
