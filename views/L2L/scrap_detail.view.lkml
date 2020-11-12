view: scrap_detail {
  sql_table_name: "L2L"."SCRAP_DETAIL"
    ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}."ID" ;;
  }

  dimension: category {
    hidden: yes
    type: number
    sql: ${TABLE}."CATEGORY" ;;
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

  dimension_group: end_ts {
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
    sql: CAST(${TABLE}."END_TS" AS TIMESTAMP_NTZ) ;;
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

  dimension: line {
    hidden: yes
    type: number
    sql: ${TABLE}."LINE" ;;
  }

  dimension: machine {
    hidden: yes
    type: string
    sql: ${TABLE}."MACHINE" ;;
  }

  dimension: pitch {
    hidden: yes
    type: number
    sql: ${TABLE}."PITCH" ;;
  }

  dimension: product {
    hidden: yes
    type: number
    sql: ${TABLE}."PRODUCT" ;;
  }

  measure: scrap {
    hidden: yes
    label: "Scrap"
    type: sum
    sql: ${TABLE}."SCRAP" ;;
  }

  dimension: shift {
    hidden: yes
    type: number
    sql: ${TABLE}."SHIFT" ;;
  }

  dimension: site {
    hidden: yes
    type: number
    sql: ${TABLE}."SITE" ;;
  }

  dimension_group: start_ts {
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
    sql: CAST(${TABLE}."START_TS" AS TIMESTAMP_NTZ) ;;
  }

  dimension: ui_editable {
    hidden: yes
    type: yesno
    sql: ${TABLE}."UI_EDITABLE" ;;
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

  measure: cal_king_scrap {
    hidden: yes
    group_label: "Scrap by Type"
    type: sum
    sql: case when ${category} = '16' then ${TABLE}.scrap else 0 end  ;;
  }

  measure: king_scrap {
    hidden: yes
    group_label: "Scrap by Type"
    type: sum
    sql: case when ${category} = '15' then ${TABLE}.scrap else 0 end  ;;
  }

  measure: queen_scrap {
    hidden: yes
    group_label: "Scrap by Type"
    type: sum
    sql: case when ${category} = '14' then ${TABLE}.scrap else 0 end  ;;
  }

  measure: full_scrap {
    hidden: yes
    group_label: "Scrap by Type"
    type: sum
    sql: case when ${category} = '13' then ${TABLE}.scrap else 0 end  ;;
  }

  measure: twin_scrap {
    hidden: yes
    group_label: "Scrap by Type"
    type: sum
    sql: case when ${category} in ('12', '45') then ${TABLE}.scrap else 0 end  ;;
  }

  measure: regrind_scrap {
    hidden: yes
    group_label: "Scrap by Type"
    type: sum
    sql: case when ${category} in ('10', '17') then ${TABLE}.scrap else 0 end  ;;
  }

  measure: trash_scrap {
    hidden: yes
    group_label: "Scrap by Type"
    type: sum
    sql: case when ${category} = '18' then ${TABLE}.scrap else 0 end  ;;
  }

  measure: count {
    hidden: yes
    type: count
    drill_fields: [id]
  }
}
