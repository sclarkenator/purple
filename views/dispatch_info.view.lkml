view: dispatch_info {
  sql_table_name: PRODUCTION.DISPATCH_INFO ;;

  dimension: assigned_techs {
    label: "Assigned Technician"
    description: "The Technicians listed on the dispatch"
    type: string
    sql: ${TABLE}."ASSIGNED_TECHS" ;;
  }

  dimension_group: completed {
    label: "Completed Time"
    description: "When was the dispactch marked as completed"
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
    sql: ${TABLE}."COMPLETED" ;;
  }

  dimension_group: created {
    hidden: no
    label: "Created Time"
    description: "When was the dispactch created in L2L"
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

  dimension: created_by {
    description: "What user created the dispatch"
    type: string
    sql: ${TABLE}."CREATED_BY" ;;
  }

  dimension: machine_name {
    type: string
    sql: ${TABLE}."MACHINE_NAME" ;;
  }

  dimension: location {
    description: "What warehouse the machine is in"
    type: string
    sql: ${TABLE}."LOCATION" ;;
  }

  dimension: description {
    label: "Dispatch Description"
    description: "Description of the problem being addressed"
    type: string
    sql: ${TABLE}."DESCRIPTION" ;;
  }

  dimension: dispatch_code {
    label: "Dispatch Type"
    type: string
    sql: ${TABLE}."DISPATCH_CODE" ;;
  }

  dimension: dispatch_id {
    type: number
    hidden: yes
    primary_key: yes
    sql: ${TABLE}."DISPATCH_ID" ;;
  }

  dimension: MACHINE_LINE_ID {
    type: number
    hidden: yes
    sql: ${TABLE}."MACHINE_LINE_ID" ;;
  }

  dimension: dispatch_impact {
    hidden: no
    description: "The level of impact a dispatch Type has. 0 highest"
    type: number
    sql: ${TABLE}."DISPATCH_IMPACT" ;;
  }

  dimension: dispatch_number {
    description: "The L2L ID for the dispatch"
    type: string
    sql: ${TABLE}."DISPATCH_NUMBER" ;;
  }

  dimension: dispatch_priority {
    description: "The priority level assigned to the dispatch in L2L"
    type: number
    sql: ${TABLE}."DISPATCH_PRIORITY" ;;
  }

  dimension: dispatch_type_description {
    description: "The explanation of dispatch type"
    type: string
    sql: ${TABLE}."DISPATCH_TYPE_DESCRIPTION" ;;
  }

  dimension: dispatch_type_id {
    hidden: yes
    type: number
    sql: ${TABLE}."DISPATCH_TYPE_ID" ;;
  }

  dimension_group: dispatched {
    label: "Dispatched Time"
    description: "Time dispatch was sent to a tech"
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
    sql: ${TABLE}."DISPATCHED" ;;
  }

  measure: downtime {
    label: "Downtime Total (Min.)"
    description: "How long the dispatch was open"
    type: sum
    sql: ${TABLE}."DOWNTIME" ;;
  }

  measure: downtime_until_dispatch {
    label: "Downtime Until Dispatched (Min.)"
    description: "How long was dispatch reported until it was reported"
    type: sum
    sql: ${TABLE}."DOWNTIME_UNTIL_DISPATCHED" ;;
  }

  dimension: last_updated_by {
    description: "Who last updated the Dispatch"
    type: string
    sql: ${TABLE}."LAST_UPDATED_BY" ;;
  }

  dimension: machine_id {
    hidden: yes
    type: number
    sql: ${TABLE}."MACHINE_ID" ;;
  }

  measure: DISPATCHED_UNTIL_COMPLETED {
    label: "Dispatched Until Completed (Min.)"
    description: "How long from the time the dispatch was dispatched to the completed time reported"
    type: sum
    sql: ${TABLE}."DISPATCHED_UNTIL_COMPLETED" ;;
  }

  dimension_group: reported {
    label: "Reported Time"
    description: "When was the dispactch reported"
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
    sql: ${TABLE}."REPORTED" ;;
  }

  dimension_group: shift_time{
    label: "Shift Timescale"
    description: "Adjusts the Reported time to make 0700 to 0000. This sets the beginning of the day as the beginning of the shift. 0000 - 0100 is the first hour of the AM shift."
    type: time
    timeframes: [raw, time, date,hour_of_day, day_of_week, day_of_month, week, week_of_year,hour, month, month_name, quarter, quarter_of_year, year]
    convert_tz: no
    datatype: timestamp
    sql: to_timestamp_ntz(Dateadd(hour,-7,${TABLE}.reported));;
  }

  measure: reported_to_completed {
    description: "How long from reported time until the dispatch was marked closed"
    type: sum
    sql: ${TABLE}."REPORTED_TO_COMPLETED" ;;
  }

  dimension: technicians {
    hidden: yes
    type: string
    sql: ${TABLE}."TECHNICIANS" ;;
  }

  measure: count {
    hidden:  no
    type: count
    drill_fields: []
  }
}
