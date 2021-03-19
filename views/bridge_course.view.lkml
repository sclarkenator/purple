view: bridge_course {
  sql_table_name: "HR"."BRIDGE_COURSE"
    ;;
  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}."ID" ;;
  }

  dimension_group: archived {
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
    sql: CAST(${TABLE}."ARCHIVED_AT" AS TIMESTAMP_NTZ) ;;
  }

  dimension: author_id {
    type: number
    sql: ${TABLE}."AUTHOR_ID" ;;
  }

  dimension: categories {
    type: string
    sql: ${TABLE}."CATEGORIES" ;;
  }

  dimension: course_type {
    type: string
    sql: ${TABLE}."COURSE_TYPE" ;;
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
    sql: CAST(${TABLE}."CREATED_AT" AS TIMESTAMP_NTZ) ;;
  }

  dimension: default_days_until_due {
    type: number
    sql: ${TABLE}."DEFAULT_DAYS_UNTIL_DUE" ;;
  }

  dimension_group: default_due_on {
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
    sql: CAST(${TABLE}."DEFAULT_DUE_ON_DATE" AS TIMESTAMP_NTZ) ;;
  }

  dimension: description {
    type: string
    sql: ${TABLE}."DESCRIPTION" ;;
  }

  dimension: due_date_type {
    type: string
    sql: ${TABLE}."DUE_DATE_TYPE" ;;
  }

  dimension: enroll_url {
    type: string
    sql: ${TABLE}."ENROLL_URL" ;;
  }

  dimension: enrollment_counts_all {
    type: number
    sql: ${TABLE}."ENROLLMENT_COUNTS_ALL" ;;
  }

  dimension: enrollment_counts_finished {
    type: number
    sql: ${TABLE}."ENROLLMENT_COUNTS_FINISHED" ;;
  }

  dimension: enrollment_counts_in_progress {
    type: number
    sql: ${TABLE}."ENROLLMENT_COUNTS_IN_PROGRESS" ;;
  }

  dimension: enrollment_counts_incomplete {
    type: number
    sql: ${TABLE}."ENROLLMENT_COUNTS_INCOMPLETE" ;;
  }

  dimension: enrollment_counts_incomplete_or_finished {
    type: number
    sql: ${TABLE}."ENROLLMENT_COUNTS_INCOMPLETE_OR_FINISHED" ;;
  }

  dimension: enrollment_counts_not_started {
    type: number
    sql: ${TABLE}."ENROLLMENT_COUNTS_NOT_STARTED" ;;
  }

  dimension: enrollment_counts_optional {
    type: number
    sql: ${TABLE}."ENROLLMENT_COUNTS_OPTIONAL" ;;
  }

  dimension: enrollment_counts_overdue {
    type: number
    sql: ${TABLE}."ENROLLMENT_COUNTS_OVERDUE" ;;
  }

  dimension: enrollment_counts_required {
    type: number
    sql: ${TABLE}."ENROLLMENT_COUNTS_REQUIRED" ;;
  }

  dimension: estimated_time_min {
    type: number
    sql: ${TABLE}."ESTIMATED_TIME_MIN" ;;
  }

    dimension: is_archived {
    type: yesno
    sql: ${TABLE}."IS_ARCHIVED" ;;
  }

  dimension: quizzes_count {
    type: number
    sql: ${TABLE}."QUIZZES_COUNT" ;;
  }

  dimension: retain {
    type: yesno
    sql: ${TABLE}."RETAIN" ;;
  }

  dimension: tags {
    type: string
    sql: ${TABLE}."TAGS" ;;
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
    sql: CAST(${TABLE}."UPDATED_AT" AS TIMESTAMP_NTZ) ;;
  }

  measure: count {
    type: count
    drill_fields: [id]
  }
}
