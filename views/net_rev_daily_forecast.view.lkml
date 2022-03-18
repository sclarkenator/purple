view: net_rev_daily_forecast {
  sql_table_name: ANALYTICS.DS.V_PACING_FCST
    ;;

  dimension: channel {
    type: string
    sql: ${TABLE}."CHANNEL" ;;
  }

  dimension: channel_date {
    type: string
    hidden:  yes
    primary_key: yes
    sql: ${channel}||${date_date} ;;
  }

  measure: revenue {
    type: sum
    value_format_name: usd
    sql: ${TABLE}.revenue ;;
  }

  dimension_group: date {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}."DATE" ;;
  }


}
