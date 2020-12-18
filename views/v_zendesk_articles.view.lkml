view: v_zendesk_articles {
  sql_table_name: analytics.customer_care.v_zendesk_articles
    ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}."ID" ;;
  }

  dimension: author_id {
    type: number
    sql: ${TABLE}."AUTHOR_ID" ;;
  }

  dimension: body {
    type: string
    sql: ${TABLE}."BODY" ;;
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
    sql: CAST(${TABLE}."CREATED" AS TIMESTAMP_NTZ) ;;
  }

  dimension: draft {
    type: yesno
    sql: ${TABLE}."DRAFT" ;;
  }

  dimension: html_url {
    type: string
    sql: ${TABLE}."HTML_URL" ;;
  }

  dimension: label_names {
    type: string
    sql: ${TABLE}."LABEL_NAMES" ;;
  }

  dimension: name {
    type: string
    sql: ${TABLE}."NAME" ;;
  }

  dimension: permission_group_id {
    type: number
    sql: ${TABLE}."PERMISSION_GROUP_ID" ;;
  }

  dimension: position {
    type: number
    sql: ${TABLE}."POSITION" ;;
  }

  dimension: section_id {
    type: number
    sql: ${TABLE}."SECTION_ID" ;;
  }

  dimension: title {
    type: string
    sql: ${TABLE}."TITLE" ;;
  }

  dimension_group: updated {
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
    sql: CAST(${TABLE}."UPDATED" AS TIMESTAMP_NTZ) ;;
  }

  dimension: url {
    type: string
    sql: ${TABLE}."URL" ;;
  }

  dimension: user_segment_id {
    type: number
    sql: ${TABLE}."USER_SEGMENT_ID" ;;
  }

  dimension: vote_count {
    type: number
    sql: ${TABLE}."VOTE_COUNT" ;;
  }

  dimension: vote_sum {
    type: number
    sql: ${TABLE}."VOTE_SUM" ;;
  }

}
