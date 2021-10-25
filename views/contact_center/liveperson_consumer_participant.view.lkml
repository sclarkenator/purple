# The name of this view in Looker is "Consumer Participant"
view: liveperson_consumer_participant {
  # The sql_table_name parameter indicates the underlying database table
  # to be used for all fields in this view.
  sql_table_name: "LIVEPERSON"."CONSUMER_PARTICIPANT"
    ;;
  # No primary key is defined for this view. In order to join this view in an Explore,
  # define primary_key: yes on a dimension that has no repeated values.

  # Here's what a typical dimension looks like in LookML.
  # A dimension is a groupable field that can be used to filter query results.
  # This dimension will be called "Avatar URL" in Explore.

  dimension: avatar_url {
    type: string
    sql: ${TABLE}."AVATAR_URL" ;;
  }

  dimension: conversation_id {
    type: string
    sql: ${TABLE}."CONVERSATION_ID" ;;
  }

  # Dates and timestamps can be represented in Looker using a dimension group of type: time.
  # Looker converts dates and timestamps to the specified timeframes within the dimension group.

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

  dimension: dialog_id {
    type: string
    sql: ${TABLE}."DIALOG_ID" ;;
  }

  dimension: email {
    type: string
    sql: ${TABLE}."EMAIL" ;;
  }

  dimension: first_name {
    type: string
    sql: ${TABLE}."FIRST_NAME" ;;
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
    sql: CAST(${TABLE}."INSERT_TS" AS TIMESTAMP_NTZ) ;;
  }

  dimension_group: joined {
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

  dimension: last_name {
    type: string
    sql: ${TABLE}."LAST_NAME" ;;
  }

  dimension: name {
    type: string
    sql: ${TABLE}."NAME" ;;
  }

  dimension: participant_id {
    type: string
    sql: ${TABLE}."PARTICIPANT_ID" ;;
  }

  dimension: phone {
    type: string
    sql: ${TABLE}."PHONE" ;;
  }

  dimension: token {
    type: string
    sql: ${TABLE}."TOKEN" ;;
  }

  # A measure is a field that uses a SQL aggregate function. Here are count, sum, and average
  # measures for numeric dimensions, but you can also add measures of many different types.
  # Click on the type parameter to see all the options in the Quick Help panel on the right.

  measure: count {
    type: count
    drill_fields: [first_name, name, last_name]
  }
}

# These sum and average measures are hidden by default.
# If you want them to show up in your explore, remove hidden: yes.
