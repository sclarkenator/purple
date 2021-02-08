view: v_fb_adset_freq_weekly {
  sql_table_name: "MARKETING"."V_FB_ADSET_FREQ_WEEKLY"
    ;;

  dimension_group: _fivetran_synced {
    type: date_time
    sql: ${TABLE}."_FIVETRAN_SYNCED";;
  }

  dimension: account_id {
    type: number
    sql: ${TABLE}."ACCOUNT_ID" ;;
  }

  dimension: adset_id {
    type: string
    sql: ${TABLE}."ADSET_ID" ;;
  }

  dimension: adset_name {
    type: string
    sql: ${TABLE}."ADSET_NAME" ;;
  }

  measure: frequency {
    type: sum
    value_format: "#.##"
    sql: ${TABLE}."FREQUENCY" ;;
  }

  dimension_group: week {
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
    sql: ${TABLE}."WEEK" ;;
  }

  measure: count {
    type: count
    drill_fields: [adset_name]
  }
}
