view: resource_shift {
  label: "L2L Resource Shift"
  #sql_table_name: "L2L"."RESOURCE_SHIFT" ;;
  derived_table: {
    sql: select *
    from ANALYTICS.L2L.RESOURCE_SHIFT
    where active = TRUE ;;
  }

  drill_fields: [id]

  dimension: id {
    primary_key: yes
    description: "Shift ID; Source: l2l.resorce_shift"
    type: number
    sql: ${TABLE}."ID" ;;
  }

  dimension: active {
    hidden: yes
    type: yesno
    sql: ${TABLE}."ACTIVE" ;;
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

  dimension: description {
    hidden: yes
    type: string
    sql: ${TABLE}."DESCRIPTION" ;;
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

  dimension: length {
    hidden: yes
    type: number
    sql: ${TABLE}."LENGTH" ;;
  }

  dimension: name {
    description: "Full name of Shift (1st Shift Mon-Wed, 1st Shift Thursday-Saturday, etc); Source: l2l.resource_shift"
    type: string
    sql: ${TABLE}."NAME" ;;
  }

  dimension: name_clean {
    description: "Full name of Shift (1st Shift Mon-Wed, 1st Shift Thursday-Saturday, etc); Source: l2l.resource_shift"
    label: "Name (Grouped)"
    type: string
    sql: CASE WHEN ${TABLE}."NAME" in ('1st Shift Mon-Wed','Shift 1','1st shift M-W') THEN '1st Shift Mon-Wed'
              WHEN ${TABLE}."NAME" in ('2nd Shift Mon-Wed','Shift 2','2nd Shift M-W') THEN '2nd Shift Mon-Wed'
              WHEN ${TABLE}."NAME" in ('1st Shift Thursday-Saturday','Shift 3','3rd Shift T-S') THEN '3rd Shift Thu-Sat'
              WHEN ${TABLE}."NAME" in ('2nd Shift Thursday-Saturday','Shift 4','4th shift T-SN') THEN '4th Shift Thu-Sat'
              ELSE ${TABLE}."NAME" END ;;
  }

  dimension: schedule {
    hidden: yes
    type: string
    sql: ${TABLE}."SCHEDULE" ;;
  }

  dimension: site {
    hidden: yes
    type: number
    sql: ${TABLE}."SITE" ;;
  }

  dimension_group: start {
    hidden: yes
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
    sql: ${TABLE}."START_DATE" ;;
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
