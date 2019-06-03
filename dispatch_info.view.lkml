view: dispatch_info {
  sql_table_name: PRODUCTION.DISPATCH_INFO ;;

  dimension: assigned_techs {
    label: "Assigned Technicain"
    description: "The Technicains listed on the dispatch"
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
    sql: ${TABLE}."machine_name" ;;
  }

  dimension: location {
    description: "What warehouse the machine is in"
    type: string
    sql: ${TABLE}."location" ;;
  }

  dimension: description {
    label: "Dispatch Description"
    description: "Description of the problem being addressed"
    type: string
    sql: ${TABLE}."DESCRIPTION" ;;
  }

  dimension: dispatch_code {
    label: "Dispatch Type"
    description: "What kind of Dispatch"
    type: string
    sql: ${TABLE}."DISPATCH_CODE" ;;
  }

  dimension: dispatch_id {
    type: number
    hidden: yes
    primary_key: yes
    sql: ${TABLE}."DISPATCH_ID" ;;
  }

  dimension: dispatch_impact {
    hidden: yes
    description: "The level of impact a dispatch Type has"
    type: number
    sql: ${TABLE}."DISPATCH_IMPACT" ;;
  }

  dimension: dispatch_number {
    description: "The L2L ID for the dispatch"
    type: number
    sql: ${TABLE}."DISPATCH_NUMBER" ;;
  }

  dimension: dispatch_priority {
    description: "The priority level assigned to the dispatch in L2L"
    type: number
    sql: ${TABLE}."DISPATCH_PRIORITY" ;;
  }

  dimension: dispatch_type_description {
    description: "The explination of the Dispatch Type"
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
    description: "When was the dispactch sent out to a Tech"
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
    label: "Downtime Total"
    description: "How long was the dispatch open"
    type: sum
    sql: ${TABLE}."DOWNTIME" ;;
  }

  measure: downtime_until_dispatch {
    description: "How long was the Dispatch Reported until it was reported dispatched"
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
    description: "How long from the time the dispatch was dispatched to the completed time was reported"
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
    hidden:  yes
    type: count
    drill_fields: []
  }
}
