view: scrap_category {
  sql_table_name: "L2L"."SCRAP_CATEGORY"
    ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}."ID" ;;
  }

  dimension: active {
    hidden: yes
    type: yesno
    sql: ${TABLE}."ACTIVE" ;;
  }

  dimension: code {
    hidden: yes
    type: string
    sql: ${TABLE}."CODE" ;;
  }

  dimension_group: created {
    hidden: yes
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: CAST(${TABLE}."CREATED" AS TIMESTAMP_NTZ) ;;
  }

  dimension: created_by {
    hidden: yes
    type: string
    sql: ${TABLE}."CREATED_BY" ;;
  }

  dimension_group: inactivated {
    hidden: yes
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: CAST(${TABLE}."INACTIVATED" AS TIMESTAMP_NTZ) ;;
  }

  dimension_group: insert_ts {
    hidden: yes
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: CAST(${TABLE}."INSERT_TS" AS TIMESTAMP_NTZ) ;;
  }

  dimension_group: last_updated {
    hidden: yes
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: CAST(${TABLE}."LAST_UPDATED" AS TIMESTAMP_NTZ) ;;
  }

  dimension: last_updated_by {
    hidden: yes
    type: string
    sql: ${TABLE}."LAST_UPDATED_BY" ;;
  }

  dimension: name {
    label: "Scrap/Products Name"
    type: string
    sql: ${TABLE}."NAME" ;;
  }

  dimension: scrap_type {
    type: string
    sql: ${TABLE}."SCRAP_TYPE" ;;
  }

  dimension: site {
    hidden: yes
    type: number
    sql: ${TABLE}."SITE" ;;
  }

  dimension_group: update_ts {
    hidden: yes
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: CAST(${TABLE}."UPDATE_TS" AS TIMESTAMP_NTZ) ;;
  }

  measure: count {
    hidden: yes
    type: count
    drill_fields: [id, name]
  }
}
