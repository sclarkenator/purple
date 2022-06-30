view: daily_qualified_site_traffic_goals {

  sql_table_name: analytics.heap.v_ecommerce_daily_qualified_site_traffic_goals ;;

  dimension: date {
    type: date
    label: "Target Date"
    description: "Use this date for filtering the Qualified Traffic Goal"
    group_label: "Advanced"
    sql: ${TABLE}.date ;;
    hidden: yes
    primary_key: yes
  }

  dimension_group: date_set {
    type: time
    label: "Traffic Target"
    description: "Use this date for filtering the Qualified Traffic Goal. Source: looker calculation"
    group_label: "Traffic Target"
    timeframes: [date, day_of_week, day_of_week_index, day_of_month, day_of_year, week, week_of_year, month, month_name, quarter, quarter_of_year, year]
    sql: ${TABLE}.date ;;
  }

  measure: traffic_goal {
    label: "Qualified Traffic Goal"
    description: "Qualified Traffic needed to hit Sales; filter with 'Target Date'. Source: looker calculation"
    type: sum
    sql: ${TABLE}.Traffic_goal ;;
    value_format: "0"
  }
}
