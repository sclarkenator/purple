view: cordial_subscribe {
  sql_table_name: ANALYTICS.MARKETING.V_CORDIAL_SUBSCRIBE ;;
  # derived_table: {
  #   sql: select distinct i.email as EMAIL, to_date(i.time) as OPT_IN_DATE, to_date(o.time) as OPT_OUT_DATE
  #       from analytics.marketing.cordial_activity as i
  #       left outer join analytics.marketing.cordial_activity as o
  #           on lower(i.email) = lower(o.email)
  #           and o.action = 'optout'
  #       where i.action = 'crdl_subscribeStatusChange';;
  #   }

    dimension: email {
      type: string
      hidden: yes
      sql: ${TABLE}."EMAIL" ;;
    }

  dimension_group: opt_in_date {
    type: time
    timeframes: [
      raw,
      time,
      hour,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}."OPT_IN_DATE" ;;
  }

  dimension_group: opt_out_date {
    type: time
    timeframes: [
      raw,
      time,
      hour,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}."OPT_OUT_DATE" ;;
  }


}
