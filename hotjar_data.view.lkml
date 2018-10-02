view: hotjar_data {
  sql_table_name: marketing.hotjar_data ;;

  dimension: pk_hotjar {
    label: "PK for Hotjar"
    description: "token combined with how heard"
    hidden: yes
    primary_key: yes
    sql: ${TABLE}.token||${TABLE}.how_heard ;;
  }

  dimension: token {
    label: "token"
    description: "checkout token from shopify"
    hidden:  yes
    sql: ${TABLE}.token ;;
  }

  dimension_group: created {
    type: time
    timeframes: [
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}."CREATED" ;;
  }

  dimension: how_heard {
    hidden:  yes
    type: string
    sql: ${TABLE}."HOW_HEARD" ;;
  }

  dimension: heard_group {
    label: "How did you hear?"
    description: "How did you hear about Purple?"
    case: {
        when: {
          sql: ${how_heard} = 'YouTube' ;;
          label: "YouTube"
        }

        when: {
          sql: ${how_heard} like 'Referral%' ;;
          label: "Word-of-mouth"
        }

        when: {
          sql: ${how_heard} = 'Facebook' ;;
          label: "Facebook"
        }

        when: {
          sql: ${how_heard} = 'TV' ;;
          label: "TV"
        }

        when: {
          sql: ${how_heard} like 'Search Engine%' ;;
          label: "Search engine"
        }

        when: {
          sql: ${how_heard} like 'Review We%' ;;
          label: "Review website"
        }

      when: {
          sql: ${how_heard} like 'Website Ba%' ;;
          label: "Display ad"
        }

      when: {
        sql: ${how_heard} like 'Already own%' ;;
        label: "Already own Purple"
      }

        when: {
          sql: ${how_heard} = 'Instagram' ;;
          label: "Instagram"
        }

        when: {
          sql: ${how_heard} = 'Amazon' ;;
          label: "Amazon"
        }

        when: {
          sql: ${how_heard} like 'Sirius%' ;;
          label: "Sirius XM"
        }

        when: {
          sql: ${how_heard} = 'Podcast' ;;
          label: "Podcast"
        }

        else: "Other"
    }
  }

  measure: count {
    type: count
    drill_fields: []
  }

  measure: respondents {
#    hidden: yes
    type: count_distinct
    sql: ${TABLE}.token ;;
  }

}
