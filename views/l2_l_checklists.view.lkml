view: l2_l_checklists {
  sql_table_name: L2L.CHECKLIST ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: string
    sql: ${TABLE}."ID" ;;
  }

  dimension: area {
    type: string
    sql: ${TABLE}."AREA" ;;
  }

  dimension: build_sequence {
    type: string
    sql: ${TABLE}."BUILD_SEQUENCE" ;;
  }

  dimension: closed {
    type: yesno
    sql: ${TABLE}."CLOSED" ;;
  }

  dimension_group: closeddate {
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
    sql: ${TABLE}."CLOSEDDATE" ;;
  }

  dimension_group: created {
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
    sql: ${TABLE}."CREATED" ;;
  }

  dimension: createdby {
    type: string
    sql: ${TABLE}."CREATEDBY" ;;
  }

  dimension: description {
    type: string
    sql: ${TABLE}."DESCRIPTION" ;;
  }

  dimension: dispatch {
    type: string
    sql: ${TABLE}."DISPATCH" ;;
  }

  dimension: document {
    type: string
    sql: ${TABLE}."DOCUMENT" ;;
  }

  dimension: externalid {
    type: string
    sql: ${TABLE}."EXTERNALID" ;;
  }

  dimension_group: insert_ts {
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
    sql: ${TABLE}."INSERT_TS" ;;
  }

  dimension_group: lastupdated {
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
    sql: ${TABLE}."LASTUPDATED" ;;
  }

  dimension: lastupdatedby {
    type: string
    sql: ${TABLE}."LASTUPDATEDBY" ;;
  }

  dimension: line {
    type: string
    sql: ${TABLE}."LINE" ;;
  }

  dimension: machine {
    type: string
    sql: ${TABLE}."MACHINE" ;;
  }

  dimension: name {
    type: string
    sql: ${TABLE}."NAME" ;;
  }

  dimension: notes {
    type: string
    sql: ${TABLE}."NOTES" ;;
  }

  dimension: number {
    type: string
    sql: ${TABLE}."NUMBER" ;;
  }

  dimension: product {
    type: string
    sql: ${TABLE}."PRODUCT" ;;
  }

  dimension: product_order {
    type: string
    sql: ${TABLE}."PRODUCT_ORDER" ;;
  }

  dimension: require_complete_all {
    type: yesno
    sql: ${TABLE}."REQUIRE_COMPLETE_ALL" ;;
  }

  dimension: require_dispatch_close {
    type: yesno
    sql: ${TABLE}."REQUIRE_DISPATCH_CLOSE" ;;
  }

  dimension: require_password_save {
    type: yesno
    sql: ${TABLE}."REQUIRE_PASSWORD_SAVE" ;;
  }

  dimension: revision {
    type: string
    sql: ${TABLE}."REVISION" ;;
  }

  dimension: site {
    type: string
    sql: ${TABLE}."SITE" ;;
  }

  dimension: tasks {
    type: string
    sql: ${TABLE}."TASKS" ;;
  }

  dimension: technology {
    type: string
    sql: ${TABLE}."TECHNOLOGY" ;;
  }

  dimension_group: update_ts {
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
    sql: ${TABLE}."UPDATE_TS" ;;
  }

  dimension: user {
    type: string
    sql: ${TABLE}."USER" ;;
  }

  measure: count {
    type: count
    drill_fields: [id, name]
  }
}
