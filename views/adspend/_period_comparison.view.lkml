view: _period_comparison {
  extension: required

  filter: date_filter {
    group_label: "Period Comparison"
    label: "Current Period Date Filter"
    description: "Use this date filter in combination with the period dimension to compare this period to previous periods."
    type: date
  }

  dimension_group: filter_start_date {
    group_label: "Period Comparison"
    hidden: yes
    type: time
    timeframes: [raw,date]
    sql: CASE WHEN {% date_start date_filter %} IS NULL THEN '1970-01-01' ELSE CAST({% date_start date_filter %} as DATE) END;;
  }

  dimension_group: filter_end_date {
    group_label: "Period Comparison"
    hidden: yes
    type: time
    timeframes: [raw,date]
    sql: CASE WHEN {% date_end date_filter %} IS NULL THEN CURRENT_DATE ELSE CAST({% date_end date_filter %} as DATE) END;;
  }

  dimension: interval {
    hidden: yes
    group_label: "Period Comparison"
    type: number
    sql: datediff(day,${filter_start_date_raw},${filter_end_date_raw}) ;;
  }

  dimension: previous_start_date {
    hidden: yes
    group_label: "Period Comparison"
    type: date
    sql: dateadd(day,-${interval},${filter_start_date_raw}) ;;

  }

  dimension: same_period_last_year_start_date {
    hidden: yes
    group_label: "Period Comparison"
    type: date
    sql: dateadd(year,-1,${filter_start_date_raw}) ;;
  }

  dimension: same_period_last_year_end_date {
    hidden: yes
    group_label: "Period Comparison"
    type: date
    sql: dateadd(year,-1,${filter_end_date_raw}) ;;
  }

  dimension: comparison_period_start_date {
    hidden: yes
    group_label: "Period Comparison"
    type: date
    sql:
            {% if comparison_period._parameter_value == 'previous'  %}
              ${previous_start_date}
            {% elsif comparison_period._parameter_value == 'lastyear'  %}
              ${same_period_last_year_start_date}
            {% else %}
              false
            {% endif %};;
  }

  dimension: day_in_period {
    hidden: yes
    description: "Gives the number of days since the start of each period. Use this to align the event dates onto the same axis, the axes will read 1,2,3, etc."
    group_label: "Period Comparison"
    type: number
    sql:
      {% if date_filter._is_filtered %}
          CASE
          WHEN ${is_current_period} = true
          THEN datediff(day, ${filter_start_date_date}, ${event_date}) + 1
          WHEN ${is_comparison_period} = true
          THEN datediff(day, ${comparison_period_start_date}, ${event_date}) + 1
          END
      {% else %} NULL
      {% endif %}
    ;;
  }

  dimension_group: date_in_period {
    description: "Use this as your grouping dimension when comparing periods. Aligns the comparison periods onto the current period"
    label: "Current Period"
    group_label: "Period Comparison Date"
    type: time
    sql: dateadd(day, ${day_in_period} - 1, ${filter_start_date_raw}) ;;
    timeframes: [
      date,
      hour_of_day,
      day_of_week,
      day_of_week_index,
      day_of_month,
      day_of_year,
      week,
      week_of_year,
      month,
      month_name,
      month_num,
      year]
  }


  dimension: is_current_period {
    hidden: yes
    group_label: "Period Comparison"
    type: yesno
    sql: ${event_raw} >= ${filter_start_date_raw} AND ${event_raw} < ${filter_end_date_raw} ;;
  }

  dimension: is_previous_period {
    hidden: yes
    group_label: "Period Comparison"
    type: yesno
    sql: ${event_raw} >= ${previous_start_date} AND ${event_raw} < ${filter_start_date_raw} ;;
  }

  dimension: is_same_period_last_year {
    hidden: yes
    group_label: "Period Comparison"
    type: yesno
    sql: ${event_raw} >= ${same_period_last_year_start_date} AND ${event_raw} < ${same_period_last_year_end_date} ;;
  }

  parameter: comparison_period {
    group_label: "Period Comparison"
    label: "Comparison Period"
    type: unquoted
    default_value: "lastyear"
    allowed_value: {
      label: "Previous Period"
      value: "previous"
    }
    allowed_value: {
      label: "Same Period Last Year"
      value: "lastyear"
    }
  }

  dimension: is_comparison_period {
    group_label: "Period Comparison"
    hidden: yes
    type: yesno
    sql:
            {% if comparison_period._parameter_value == 'previous'  %}
              ${is_previous_period}=true
            {% elsif comparison_period._parameter_value == 'lastyear'  %}
              ${is_same_period_last_year}=true
            {% else %}
              false
            {% endif %}
         ;;
  }

  dimension: is_within_current_and_comparison_period {
    group_label: "Period Comparison"
    type: yesno
    sql: ${is_current_period} = true OR ${is_comparison_period} = true
      ;;
  }

  dimension: period {
    group_label: "Period Comparison"
    description: "Use this field in combination with the date filter field for dynamic date filtering"
    suggestions: ["Current Period","Previous Period", "Same Period Last Year"]
    type: string
    sql: CASE
            WHEN ${is_current_period} = true THEN 'Current Period'
            WHEN ${is_previous_period} = true THEN 'Previous Period'
            WHEN ${is_same_period_last_year} = true THEN 'Same Period Last Year'
        END
    ;;
  }
}
