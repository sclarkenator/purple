view: hotjar_data {
  derived_table: {
    sql:
          select created
                  ,how_heard
                  ,first_heard
                  ,name related_tranid
          from analytics.marketing.hotjar_data h
          join
          (select checkout_token
                  ,name
          from analytics_stage.shopify_ca_ft."ORDER"
          union
          select checkout_token
                  ,name
          from analytics_stage.shopify_us_ft."ORDER"
          where created_at > '2018-05-22') s
          on h.token = s.checkout_token ;;
  }

  dimension: pk_hotjar {
    label: "PK for Hotjar"
    description: "token combined with how heard"
    hidden: yes
    primary_key: yes
    sql: ${TABLE}.related_tranid||${TABLE}.how_heard ;;
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

  dimension: first_heard {
    case: {
      when: {
        sql: ${TABLE}."FIRST_HEARD" = 'Today' ;;
        label: "Today"
      }

      when: {
        sql: ${TABLE}."FIRST_HEARD" = 'Less than 1 week ago' ;;
        label: "<1 week"
      }

      when: {
        sql: ${TABLE}."FIRST_HEARD" = 'Less than 2 weeks ago' ;;
        label: "<2 weeks"
      }

      when: {
        sql: ${TABLE}."FIRST_HEARD" = 'Less than 1 month ago' ;;
        label: "<1 mo"
      }

      when: {
        sql: ${TABLE}."FIRST_HEARD" = 'Less than 2 months ago' ;;
        label: "<2 mo"
      }

      when: {
        sql: ${TABLE}."FIRST_HEARD" = 'Less than 3 months ago' ;;
        label: "<3 mo"
      }

      when: {
        sql: ${TABLE}."FIRST_HEARD" = 'Less than 6 months ago' ;;
        label: "<6 mo"
      }

      when: {
        sql: ${TABLE}."FIRST_HEARD" = 'Less than 1 year ago' ;;
        label: "<1 yr"
      }

      when: {
        sql: ${TABLE}."FIRST_HEARD" = 'More than 1 year ago' ;;
        label: "1+ yr"
      }
    }
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

  dimension: related_tranid {
    hidden:  yes
    type: string
    sql: ${TABLE}.related_tranid ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }

  measure: respondents {
#    hidden: yes
    type: count_distinct
    sql: ${TABLE}.related_tranid ;;
  }

}
