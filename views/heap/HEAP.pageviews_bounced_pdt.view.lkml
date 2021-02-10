view: pageviews_bounced_pdt {
    derived_table: {
      explore_source: heap_page_views {
        column: session_time_week {}
        column: Sum_non_bounced_session {}
        column: Sum_bounced_session {}
        column: percent_qualified {}
        column: count {}
        column: session_time_year {}
        filters: {
          field: heap_page_views.session_time_date
          value: "after 2019/01/01"
        }
      }
      datagroup_trigger: pdt_refresh_6am
    }
    dimension: session_time_week {
      primary_key: yes
      hidden: yes
      group_label: "Session Time"
    }
    dimension_group: session {
      group_label: "Session Time"
      label: "Session Time"
      description: "Time the Session Began"
      type: time
      timeframes: [date, week, year]
      sql: ${TABLE}.session_time_week ;;
    }

  dimension: session_week_of_year {
    ## Scott Clark 1/22/21: Added to replace week_of_year for better comps. Remove final week in 2021.
    type: number
    label: "Week of Year"
    group_label: "    Session Date"
    description: "2021 adjusted week of year number"
    sql: case when ${session_date::date} >= '2020-12-28' and ${session_date::date} <= '2021-01-03' then 1
              when ${session_year::number}=2021 then date_part(weekofyear,${session_date::date}) + 1
              else date_part(weekofyear,${session_date::date}) end ;;
  }

  dimension: adj_year {
    ## Scott Clark 1/8/21: Added to replace year for clean comps. Remove final week in 2021.
    type: number
    label: "z - 2021 adj year"
    group_label: "    Session Date"
    description: "Year adjusted to align y/y charts when using week_number. DO NOT USE OTHERWISE"
    sql:  case when ${session_date::date} >= '2020-12-28' and ${session_date::date} <= '2021-01-03' then 2021 else ${session_year::number} end   ;;
  }

    dimension: session_time_year {
      description: "Time the Session Began"
      type: date_year
    }
    dimension: Sum_non_bounced_session {
      hidden: yes
      type: number
    }
    dimension: Sum_bounced_session {
      hidden: yes
      type: number
    }
    dimension: percent_qualified {
      hidden: yes
      value_format: "#,##0.0%"
      type: number
    }
    dimension: count {
      hidden:  yes
    }
    measure: session_count {
      label: "Session Count"
      type: sum
      sql: ${count} ;;
    }
    measure: total_non_bounced_session {
      label: "Sessions Total Non Bounced Session"
      type: sum
      sql: ${Sum_non_bounced_session} ;;
    }
    measure: total_bounced_session {
      label: "Sessions Total Bounced Session"
      type: sum
      sql: ${Sum_bounced_session} ;;
    }
    measure: perc_qualified {
      label: "% Qualified"
      value_format: "#,##0.0%"
      type: sum
      sql: ${percent_qualified} ;;
    }
  }
