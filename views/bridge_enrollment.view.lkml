view: bridge_enrollment {
  sql_table_name: "HR"."BRIDGE_ENROLLMENT"
    ;;

  dimension_group: completed {
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
    sql: CAST(${TABLE}."COMPLETED_AT" AS TIMESTAMP_NTZ) ;;
  }

  dimension: course_id {
    type: number
    sql: ${TABLE}."COURSE_ID" ;;
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

  dimension: enrollment_id {
    type: number
    primary_key: yes
    sql: ${TABLE}."ENROLLMENT_ID" ;;
  }

  dimension: is_active {
    type: yesno
    sql: ${TABLE}."IS_ACTIVE" ;;
  }

  dimension: is_required {
    type: yesno
    sql: ${TABLE}."IS_REQUIRED" ;;
  }

  dimension: learner_id {
    type: number
    sql: ${TABLE}."LEARNER_ID" ;;
  }

  dimension: progress {
    type: number
    sql: ${TABLE}."PROGRESS" ;;
  }

  dimension: score {
    type: number
    sql: ${TABLE}."SCORE" ;;
  }

  dimension: state {
    type: string
    sql: ${TABLE}."STATE" ;;
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

  dimension: is_deleted {
    type: yesno
    sql: CASE
          WHEN ${TABLE}.deleted_at IS NULL then FALSE
          ELSE TRUE
         END ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }

  measure: completions {
    type: sum
    sql: case when ${completed_date} is not null then 1 else 0 end;;
  }

  measure: completion_rate {
    type: number
    sql: ${completions}/${count}*100 ;;
    value_format: "0.0\%"
  }
}
