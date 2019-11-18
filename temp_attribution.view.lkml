view: temp_attribution {
  sql_table_name: MARKETING.TEMP_ATTRIBUTION ;;

  dimension: pk {
    primary_key: yes
    hidden: yes
    sql:  ${TABLE}."AD_DATE"||${TABLE}."ATT_DATE"||${TABLE}."PARTNER" ;;
  }
  dimension_group: ad {
    label: "Ad"
    hidden:  yes
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
    hidden:  yes
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
    hidden:  yes
    sql: ${TABLE}."CONVERSIONS" ;;
  }

  dimension: partner {
    type: string
    hidden:  yes
    sql: upper(${TABLE}."PARTNER") ;;
  }

  measure: count {
    hidden: yes
    type: count
    drill_fields: []
  }
}
