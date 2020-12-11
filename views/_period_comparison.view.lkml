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
    sql: {% if comparison_period._parameter_value == "previous" %}
          dateadd(day,-${interval},${filter_start_date_raw})
        {% else %}
          dateadd({% parameter comparison_period %}, -1, ${filter_start_date_raw})
        {% endif %} ;;
  }

  dimension: previous_end_date {
    hidden: yes
    group_label: "Period Comparison"
    type: date
    sql: {% if comparison_period._parameter_value == "previous" %}
          ${filter_start_date_raw}
        {% else  %}
          dateadd({% parameter comparison_period %}, -1, ${filter_end_date_raw})
        {% endif %} ;;
  }

  dimension: same_period_last_year_start_date {
    hidden: yes
    group_label: "Period Comparison"
    type: date
    sql:
      {% if comparison_period._parameter_value == 'week'  %}
        dateadd({% parameter comparison_period %}, -52, ${filter_start_date_raw})
      {% else %}
        dateadd(year,-1,${filter_start_date_raw})
      {% endif %};;
    # dateadd(year,-1,${filter_start_date_raw}) ;;
  }

  dimension: same_period_last_year_end_date {
    hidden: yes
    group_label: "Period Comparison"
    type: date
    sql:
      {% if comparison_period._parameter_value == 'week'  %}
        dateadd({% parameter comparison_period %}, -52, ${filter_end_date_raw})
      {% else %}
        dateadd(year,-1,${filter_end_date_raw})
      {% endif %};;
    # dateadd(year,-1,${filter_end_date_raw}) ;;
  }

  dimension: comparison_period_start_date {
    hidden: yes
    group_label: "Period Comparison"
    type: date
    sql:
            {% if comparison_period._parameter_value == 'previous'  %}
              ${previous_start_date}
            {% elsif comparison_period._parameter_value == 'week'  %}
              ${previous_start_date}
            {% elsif comparison_period._parameter_value == 'month'  %}
              ${previous_start_date}
            {% elsif comparison_period._parameter_value == 'year'  %}
              ${previous_start_date}
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
    sql:
            {% if comparison_period._parameter_value == 'previous'  %}
              dateadd(day, ${day_in_period} - 1, ${filter_start_date_raw})
            {% elsif comparison_period._parameter_value == 'week'  %}
              CASE
                WHEN ${is_same_period_last_year}
                  THEN  dateadd(week, 52, ${event_date})
                ELSE dateadd(day, ${day_in_period} - 1, ${filter_start_date_raw})
              END
            {% elsif comparison_period._parameter_value == 'month'  %}
              dateadd(day, ${day_in_period} - 1, ${filter_start_date_raw})
            {% elsif comparison_period._parameter_value == 'year'  %}
              dateadd(day, ${day_in_period} - 1, ${filter_start_date_raw})
            {% else %}
              false
            {% endif %};;
# dateadd(day, ${day_in_period} - 1, ${filter_start_date_raw}) ;;

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
    sql: ${event_raw} >= ${previous_start_date} AND ${event_raw} < ${previous_end_date} ;;
  }

  dimension: is_same_period_last_year {
    hidden: yes
    group_label: "Period Comparison"
    type: yesno
    sql: ${event_raw} >= ${same_period_last_year_start_date} AND ${event_raw} < ${same_period_last_year_end_date} ;;
  }

  dimension: is_current_previous_or_same_period_last_year {
    group_label: "Period Comparison"
    type: yesno
    sql: ${is_current_period} = 'Yes' or ${is_previous_period} = 'Yes' or ${is_same_period_last_year} = 'Yes' ;;
  }

  parameter: comparison_period {
    group_label: "Period Comparison"
    label: "Comparison Period"
    type: unquoted
    default_value: "previous"
    allowed_value: {
      label: "Previous Period"
      value: "previous"
    }
    allowed_value: {
      label: "Previous Week"
      value: "week"
    }
    allowed_value: {
      label: "Previous Month"
      value: "month"
    }
    allowed_value: {
      label: "Same Period Last Year"
      value: "year"
    }
    allowed_value: {
      label: "Previous Period Last Year"
      value: "year"
    }
  }

  dimension: is_comparison_period {
    group_label: "Period Comparison"
    hidden: yes
    type: yesno
    sql:
            {% if comparison_period._parameter_value == 'previous'  %}
              ${is_previous_period}=true
            {% elsif comparison_period._parameter_value == 'year'  %}
              ${is_previous_period}=true
            {% elsif comparison_period._parameter_value == 'week'  %}
              ${is_previous_period}=true
            {% elsif comparison_period._parameter_value == 'month'  %}
              ${is_previous_period}=true
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
            WHEN ${is_previous_period} = true THEN 'Same Period Last Year'
        END
    ;;
  }

  dimension: period_and_last_year {
    group_label: "Period Comparison"
    description: "Use this field in combination with the date filter field for dynamic date filtering"
    type: string
    sql: CASE
            WHEN ${is_current_period} = true THEN 'Current Period'
            WHEN ${is_previous_period} = true THEN 'Previous Period'
            WHEN ${is_same_period_last_year} = true THEN 'Same Period Last Year'
        END
    ;;
  }
}
