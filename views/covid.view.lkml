view: covid {
  sql_table_name: "SALES"."COVID"
    ;;


  dimension: pk {
    hidden: yes
    primary_key: yes
    type: date
    sql: ${fips}||'-'||${case_type}||'-'||${TABLE}.date ;;
  }

  dimension: case_type {
    type: string
    sql: ${TABLE}."CASE_TYPE" ;;
  }

  measure: cases {
    type: sum
    sql: ${TABLE}."CASES" ;;
  }

  dimension: country_region {
    type: string
    label: "Country"
    sql: ${TABLE}."COUNTRY_REGION" ;;
  }

  dimension: county {
    type: string
    sql: ${TABLE}."COUNTY" ;;
  }

  dimension_group: date {
    type: time
    label: "    Case"
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


  dimension: fips {
    type: string
    label: "FIPS"
    sql: ${TABLE}."FIPS" ;;
  }

  dimension: iso3166_1 {
    type: string
    hidden:  yes
    sql: ${TABLE}."ISO3166_1" ;;
  }

  dimension: iso3166_2 {
    type: string
    hidden:  yes
    sql: ${TABLE}."ISO3166_2" ;;
  }

  dimension: province_state {
    type: string
    label: "State"
    sql: ${TABLE}."PROVINCE_STATE" ;;
  }

  measure: count {
    type: count
    hidden: yes
    drill_fields: []
  }
}
