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
      timeframes: [week,week_of_year]
      sql: ${TABLE}.session_time_week ;;
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
