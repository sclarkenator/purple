## REFERENCE: https://developers.liveperson.com/messaging-interactions-api-methods-conversations.html
view: liveperson_consumer_participant {

  sql_table_name: "LIVEPERSON"."CONSUMER_PARTICIPANT"
    ;;
    drill_fields: [participant_id]

  ##########################################################################################
  ##########################################################################################
  ## GENERAL DIMENSIONS

  dimension: avatar_url {
    label: "Avatar URL"
    type: string
    hidden: yes
    sql: ${TABLE}."AVATAR_URL" ;;
  }

  dimension: email {
    label: "Email"
    type: string
    hidden: yes
    sql: ${TABLE}."EMAIL" ;;
  }

  dimension: first_name {
    label: "First Name"
    group_label: "* Details"
    type: string
    hidden: yes
    sql: ${TABLE}."FIRST_NAME" ;;
  }

  dimension: last_name {
    label: "Last Name"
    group_label: "* Details"
    type: string
    hidden: yes
    sql: ${TABLE}."LAST_NAME" ;;
  }

  dimension: name {
    label: "Consumer Name"
    description: "Consumer participant's full name."
    type: string
    sql: ${TABLE}."NAME" ;;
  }

  dimension: phone {
    label: "Phone"
    type: string
    hidden: yes
    sql: ${TABLE}."PHONE" ;;
  }

  dimension: token {
    label: "Token"
    type: string
    hidden: yes
    sql: ${TABLE}."TOKEN" ;;
  }

  ##########################################################################################
  ##########################################################################################
  ## DATE DIMENSIONS

  dimension_group: created {
    label: "- Created"
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
    hidden: yes
    sql: CAST(${TABLE}."INSERT_TS" AS TIMESTAMP_NTZ) ;;
  }

  dimension_group: joined {
    label: "- Joined"
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
    sql: CAST(${TABLE}."JOINED" AS TIMESTAMP_NTZ) ;;
  }

  ##########################################################################################
  ##########################################################################################
  ## IDs

  dimension: conversation_id {
    group_label: "*IDs"
    type: string
    hidden: yes
    sql: ${TABLE}."CONVERSATION_ID" ;;
  }

  dimension: dialog_id {
    group_label: "*IDs"
    type: string
    hidden: yes
    sql: ${TABLE}."DIALOG_ID" ;;
  }

  dimension: participant_id {
    group_label: "*IDs"
    primary_key: yes
    type: string
    hidden: yes
    sql: ${TABLE}."PARTICIPANT_ID" ;;
  }

  ##########################################################################################
  ##########################################################################################
  ## MEASURES
  measure: measure_count {
    label: "Consumer Count"
    type: count
    hidden: yes
    drill_fields: [first_name, name, last_name]
  }
}
