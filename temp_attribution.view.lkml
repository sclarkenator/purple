view: temp_attribution {
  sql_table_name: MARKETING.TEMP_ATTRIBUTION ;;

  dimension_group: ad {
    label: "Ad"
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
    sql: ${TABLE}."AD_DATE" ;;
  }

  dimension_group: att {
    label: "Attribution"
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
    sql: ${TABLE}."ATT_DATE" ;;
  }

  measure: conversions {
    label: "Conversion value"
    type: sum
    sql: ${TABLE}."CONVERSIONS" ;;
  }

  dimension: partner {
    type: string
    sql: ${TABLE}."PARTNER" ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
