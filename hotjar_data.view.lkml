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
          where created_at > '2018-05-20') s
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
    type: string
    sql: ${TABLE}."FIRST_HEARD" ;;
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
