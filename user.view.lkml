view: user {
  sql_table_name: STARSHIP."USER" ;;

  dimension: id {
    primary_key: yes
    hidden:  yes
    type: string
    sql: ${TABLE}."ID" ;;
  }

  dimension: active {
    type: number
    sql: ${TABLE}."ACTIVE" ;;
  }

  dimension_group: created {
    hidden:  yes
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
    sql: ${TABLE}."CREATED_AT" ;;
  }

  dimension: display_name {
    type: string
    sql: ${TABLE}."DISPLAY_NAME" ;;
  }

  dimension_group: insert_ts {
    type: time
    hidden:  yes
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

  dimension_group: last_login_attempt {
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
    sql: ${TABLE}."LAST_LOGIN_ATTEMPT" ;;
  }

  dimension: login_attempts {
    hidden:  yes
    type: number
    sql: ${TABLE}."LOGIN_ATTEMPTS" ;;
  }

  dimension: password {
    hidden:  yes
    type: string
    sql: ${TABLE}."PASSWORD" ;;
  }

  dimension: scope {
    label: "User Role"
    type: string
    sql: ${TABLE}."SCOPE" ;;
  }

  dimension_group: update_ts {
    type: time
    hidden:  yes
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

  dimension_group: updated {
    type: time
    hidden:  yes
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}."UPDATED_AT" ;;
  }

  dimension: username {
    hidden:  yes
    type: string
    sql: ${TABLE}."USERNAME" ;;
  }

  measure: count {
    type: count
    drill_fields: [id, display_name, username]
  }
}
