view: _period_comparison_reference {
  extension: required

  ## Period Over Period Method 3: Current Period and Previous Period
  ## https://help.looker.com/hc/en-us/articles/360050104194-Methods-for-Period-Over-Period-PoP-Analysis-in-Looker

  filter: date_filter {
    group_label: "Period Comparison"
    label: "Current Period Date Filter"
    description: "Use this date filter in combination with the period dimension to compare this period to previous periods."
    type: date
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
      label: "Previous Quarter"
      value: "quarter"
    }
    allowed_value: {
      label: "Previous Year"
      value: "year"
    }
  }

  dimension_group: filter_start_date {
    group_label: "Period Comparison"
    hidden: yes
    type: time
    timeframes: [raw,time,date]
    ## BIGQUERY PARAMETER
    # datatype: date
    ## SNOWFLAKE SQL
    sql: CASE WHEN {% date_start date_filter %} IS NULL THEN '1970-01-01' ELSE CAST({% date_start date_filter %} as DATE) END;;
  }

  dimension_group: filter_end_date {
    group_label: "Period Comparison"
    hidden: yes
    type: time
    ## BIGQUERY PARAMETER
    # datatype: date
    timeframes: [raw,time,date]
    ## SNOWFLAKE SQL
    sql: CASE WHEN {% date_end date_filter %} IS NULL THEN CURRENT_DATE ELSE CAST({% date_end date_filter %} as DATE) END;;
  }

  dimension: interval {
    hidden: yes
    group_label: "Period Comparison"
    type: number
    ## SNOWFLAKE SQL
    sql: datediff(day,${filter_start_date_raw},${filter_end_date_raw}) ;;
    ## BIGQUERY SQL
    # sql: DATE_DIFF(${filter_start_date_raw}, ${filter_end_date_raw}, DAY) ;;
  }

  dimension: comparison_period_start_date {
    hidden: yes
    group_label: "Period Comparison"
    type: date
    convert_tz: no
    ## BIGQUERY PARAMETER
    # datatype: date
    ## SNOWFLAKE SQL
    sql: {% if comparison_period._parameter_value == "previous" %}
          dateadd(day,-${interval},${filter_start_date_raw})
        {% else %}
          dateadd({% parameter comparison_period %}, -1, ${filter_start_date_raw})
        {% endif %} ;;
    ## BIGQUERY SQL
    # sql: {% if comparison_period._parameter_value == "previous" %}
    #       DATE_ADD(${filter_start_date_raw}, INTERVAL ${interval} DAY)
    #     {% else %}
    #       DATE_ADD(${filter_start_date_raw}, INTERVAL -1 {% parameter comparison_period %})
    #     {% endif %} ;;
  }


  dimension: comparison_period_end_date {
    hidden: yes
    group_label: "Period Comparison"
    type: date
    convert_tz: no
    ## BIGQUERY PARAMETER
    datatype: date
    ## SNOWFLAKE SQL
    sql: {% if comparison_period._parameter_value == "previous" %}
          ${filter_start_date_raw}
        {% else  %}
          dateadd({% parameter comparison_period %}, -1, ${filter_end_date_raw})
        {% endif %} ;;
    ## BIGQUERY SQL
    # sql: {% if comparison_period._parameter_value == "previous" %}
    #       ${filter_start_date_raw}
    #     {% else  %}
    #       DATE_ADD(${filter_end_date_raw}, INTERVAL -1 {% parameter comparison_period %})
    #     {% endif %} ;;
  }

  # Fields to group by the date of the current filter (then pivot by the period name).

  dimension: day_in_period {
    hidden: yes
    description: "Gives the number of days since the start of each period. Use this to align the event dates onto the same axis, the axes will read 1,2,3, etc."
    group_label: "Period Comparison"
    type: number
    ## SNOWFLAKE SQL
    sql:
      {% if date_filter._is_filtered %}
          CASE
          WHEN ${is_current_period} = true
          THEN datediff(day, ${filter_start_date_raw}, ${event_date}) + 1
          WHEN ${is_comparison_period} = true
          THEN datediff(day, ${comparison_period_start_date}, ${event_date}) + 1
          END
      {% else %} NULL
      {% endif %}
    ;;
    ## BIGQUERY SQL
    # sql:
    #   {% if date_filter._is_filtered %}
    #       CASE
    #       WHEN ${is_current_period} = true
    #       THEN DATE_DIFF(${filter_start_date_raw}, ${event_date}+1, DAY)
    #       WHEN ${is_comparison_period} = true
    #       THEN DATE_DIFF(${comparison_period_start_date}, ${event_date}+1, DAY)
    #       END
    #   {% else %} NULL
    #   {% endif %}
    # ;;
  }

  dimension_group: date_in_period {
    description: "Use this as your grouping dimension when comparing periods. Aligns the comparison periods onto the current period"
    label: "Current Period"
    group_label: "Period Comparison Date"
    type: time
    convert_tz: no
    ## BIGQUERY PARAMETER
    # datatype: date
    ## SNOWFLAKE SQL
    sql: dateadd(day, ${day_in_period} - 1, ${filter_start_date_raw}) ;;
    ## BIGQUERY SQL
    # sql: DATE_ADD(${filter_start_date_raw}, INTERVAL ${day_in_period}-1 DAY) ;;

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

  ## Fields to filter measures

  dimension: is_current_period {
    hidden: yes
    group_label: "Period Comparison"
    type: yesno
    sql: ${event_raw} >= ${filter_start_date_raw} AND ${event_raw} < ${filter_end_date_raw} ;;
  }

  dimension: is_comparison_period {
    hidden: yes
    group_label: "Period Comparison"
    type: yesno
    sql: ${event_raw} >= ${comparison_period_start_date} AND ${event_raw} < ${comparison_period_end_date} ;;
  }

  ## Fields to use in Explore to filter or group by

  dimension: is_within_current_and_comparison_period {
    group_label: "Period Comparison"
    description: "Use this to filter down to the current and comparison timeframe."
    type: yesno
    sql: ${is_current_period} = true OR ${is_comparison_period} = true ;;
  }

  dimension: period {
    group_label: "Period Comparison"
    label: "Period"
    description: "Returns Current Period or Previous Period. Use this field in combination with the date filter field for dynamic date filtering."
    type: string
    suggestions: ["Current Period","Comparison Period"]
    sql:
        {% if date_filter._is_filtered %}
            CASE
            WHEN ${is_current_period} = true THEN 'Current Period'
            WHEN ${is_comparison_period} = true THEN 'Comparison Period'
            END
        {% else %}
            NULL
        {% endif %}
        ;;
  }

}
