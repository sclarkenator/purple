view: v_google_keyword_page_report {
  sql_table_name: "MARKETING"."V_GOOGLE_KEYWORD_PAGE_REPORT"
    ;;

  dimension_group: _fivetran_synced {
    type: time
    hidden: yes
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: CAST(${TABLE}."_FIVETRAN_SYNCED" AS TIMESTAMP_NTZ) ;;
  }

  dimension: country {
    type: string
    map_layer_name: countries
    sql: ${TABLE}."COUNTRY" ;;
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

  dimension: device {
    type: string
    sql: ${TABLE}."DEVICE" ;;
  }

  dimension: keyword {
    type: string
    sql: ${TABLE}."KEYWORD" ;;
  }

  dimension: page {
    type: string
    sql: ${TABLE}."PAGE" ;;
  }

  dimension: position {
    type: number
    sql: ${TABLE}."POSITION" ;;
  }

  dimension: search_type {
    type: string
    sql: ${TABLE}."SEARCH_TYPE" ;;
  }

  dimension: site {
    type: string
    sql: ${TABLE}."SITE" ;;
  }
  measure: clicks {
    type: sum
    sql: ${TABLE}."CLICKS" ;;
  }
  measure: ctr {
    type: number
    value_format: "00.00%"
    sql: (${clicks}/NULLIF(${impressions},0));;
    }
  measure: impressions {
    type: sum
    sql: ${TABLE}."IMPRESSIONS" ;;
  }
  measure: count {
    type: count
    drill_fields: []
  }
}
