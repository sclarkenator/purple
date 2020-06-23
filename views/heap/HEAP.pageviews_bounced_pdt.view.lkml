view: pageviews_bounced_pdt {
    derived_table: {
      explore_source: heap_page_views {
        column: session_time_week {}
        column: Sum_non_bounced_session {}
        column: Sum_bounced_session {}
        column: percent_qualified {}
        filters: {
          field: heap_page_views.session_time_date
          value: "52 weeks ago for 52 weeks"
        }
      }
      datagroup_trigger: pdt_refresh_6am
    }

    dimension: session_time_week {
      primary_key: yes
      description: "Time the Session Began"
      type: date_week
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
