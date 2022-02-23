# The name of this view in Looker is "Slt Safety"
view: slt_safety {
  # The sql_table_name parameter indicates the underlying database table
  # to be used for all fields in this view.
  sql_table_name: "PRODUCTION"."SLT_SAFETY"
    ;;
  # No primary key is defined for this view. In order to join this view in an Explore,
  # define primary_key: yes on a dimension that has no repeated values.

  # Dates and timestamps can be represented in Looker using a dimension group of type: time.
  # Looker converts dates and timestamps to the specified timeframes within the dimension group.

  dimension_group: end {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}."END_DATE" ;;
  }

  # Here's what a typical dimension looks like in LookML.
  # A dimension is a groupable field that can be used to filter query results.
  # This dimension will be called "First Aid" in Explore.

  dimension: first_aid {
    type: number
    value_format_name: id
    sql: ${TABLE}."FIRST_AID" ;;
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

  dimension: lost_time_incident_rate {
    hidden: yes
    type: number
    sql: ${TABLE}."LOST_TIME_INCIDENT_RATE" ;;
  }

  # A measure is a field that uses a SQL aggregate function. Here are defined sum and average
  # measures for this dimension, but you can also add measures of many different aggregates.
  # Click on the type parameter to see all the options in the Quick Help panel on the right.

  measure: total_lost_time_incident_rate {
    group_label: "Totals"
    label: "Lost Time Incident Rate"
    type: sum
    sql: ${lost_time_incident_rate} ;;
  }

  measure: average_lost_time_incident_rate {
    group_label: "Averages"
    label: "Lost Time Incident Rate"
    type: average
    sql: ${lost_time_incident_rate} ;;
  }

  dimension: lost_time_injury {
    hidden: yes
    type: number
    sql: ${TABLE}."LOST_TIME_INJURY" ;;
  }

  measure: total_lost_time_injury {
    group_label: "Totals"
    label: "Lost Time Injury"
    type: sum
    sql: ${lost_time_injury} ;;
  }

  measure: average_lost_time_injury {
    group_label: "Averages"
    label: "Lost Time Injury"
    type: average
    sql: ${lost_time_injury} ;;
  }

  dimension: near_miss_non_injury {
    hidden: yes
    type: number
    sql: ${TABLE}."NEAR_MISS_NON_INJURY" ;;
  }

  measure: total_near_miss_non_injury {
    group_label: "Totals"
    label: "Near Miss (Non Injury)"
    type: sum
    sql: ${near_miss_non_injury} ;;
  }

  measure: average_near_miss_non_injury {
    group_label: "Averages"
    label: "Near Miss (Non Injury)"
    type: average
    sql: ${near_miss_non_injury} ;;
  }

  dimension: osha_recordable {
    hidden: yes
    type: number
    sql: ${TABLE}."OSHA_RECORDABLE" ;;
  }

  measure: total_osha_recordable {
    group_label: "Totals"
    label: "Osha Recordable"
    type: sum
    sql: ${osha_recordable} ;;
  }

  measure: average_osha_recordable {
    group_label: "Averages"
    label: "Osha Recordable"
    type: average
    sql: ${osha_recordable} ;;
  }

  dimension: site_name {
    type: string
    sql: ${TABLE}."SITE" ;;
  }

  dimension_group: start {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}."START_DATE" ;;
  }

  dimension: recordable_incident_rate {
    type: number
    sql: ${TABLE}."TOTAL_RECORDABLE_INCIDENT_RATE" ;;
  }

  measure: total_recordable_incident_rate {
    group_label: "Totals"
    label: "Recordable Incident Rate"
    type: sum
    sql: ${recordable_incident_rate} ;;
  }

  measure: average_recordable_incident_rate {
    group_label: "Averages"
    label: "Recordable Incident Rate"
    type: average
    sql: ${recordable_incident_rate} ;;
  }

  measure: count {
    hidden: yes
    type: count
    drill_fields: []
  }
}
