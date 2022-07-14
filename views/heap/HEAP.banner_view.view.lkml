view: heap_banner_view {
    sql_table_name: analytics.heap.v_ecommerce_carousel_banner_change ;;

    dimension: PK {
      type: string
      primary_key: yes
      group_label: "Hero Banner"
      hidden: yes
      sql:  ${TABLE}.primary_key;;
    }

    dimension: user_id {
      group_label: "Hero Banner"
      description: "Unique ID for each user that has ordered"
      type: number
      hidden: yes
      sql: ${TABLE}.user_id ;;
    }

    dimension: event_id {
      group_label: "Hero Banner"
      hidden: yes
      type: number
      sql: ${TABLE}.event_id ;;
    }

    dimension: session_id {
      group_label: "Hero Banner"
      hidden:yes
      type: number
      sql: ${TABLE}.session_id ;;
    }

    dimension_group: time {
      group_label: "Hero Banner"
      hidden: yes
      type: time
      timeframes: [date, week, month, year]
      sql: ${TABLE}.time ;;
    }

    dimension: banner_heading_view {
      group_label: "Hero Banner"
      description: "View event: viewed banner in the hero Source: heap.carousel_banner_change"
      type: string
      sql: ${TABLE}.bannername ;;
    }

    dimension: banner_position_view {
      group_label: "Hero Banner"
      description: "View event: viewed banner in the hero Source: heap.carousel_banner_change"
      type: string
      sql: ${TABLE}.bannerposition ;;
    }

  }
