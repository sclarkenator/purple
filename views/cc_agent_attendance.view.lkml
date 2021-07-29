view: cc_agent_attendance {
  sql_table_name: "CUSTOMER_CARE"."ATTENDANCE_CHANGES"  ;;

  dimension: pk {
    label: "Primary Key"
    primary_key: yes
    type: string
    hidden: yes
    sql: concat(ic_id, year(combined_dates), right(concat(0, month(combined_dates)), 2), right(concat(0, day(combined_dates)), 2) , rank()over(partition by IC_ID, combined_dates order by occurrence, sub_occurrence, notes)) ;;
  }

  ##########################################################################################
  ##########################################################################################
  ## GENERAL DIMENSIONS

  dimension: added_by {
    label: "Added By"
    description: "Name of person entering record data."
    type: string
    sql: ${TABLE}."ADDED_BY" ;;
  }

  dimension: fmla {
    label: "FMLA"
    description: "How many hours of FMLA was the agent using and needed to submit into Workday."
    type: number
    sql: ${TABLE}."FMLA" ;;
  }

  dimension: ic_id {
    label: "Agent ID"
    description: "Agent's InContact ID."
    hidden: yes
    type: string
    sql: ${TABLE}."IC_ID" ;;
  }

  dimension: is_occurrence {
    label: "Is Occurrence"
    description: "Flags whether was an Occurrence event."
    # hidden: yes
    type: yesno
    sql: is_occurrence ;;
  }

  dimension: last_update {
    label: "Last Update"
    description: "Last date when the data was updated."
    type: date
    sql: select max(insert_ts) from "CUSTOMER_CARE"."ATTENDANCE_CHANGES" ;;
  }

  dimension: name {
    label: "Agent Name"
    description: "Name of agent to whom this record applies."
    hidden: yes
    type: string
    sql: ${TABLE}."NAME" ;;
  }

  dimension: notes {
    label: "Notes"
    description: "Comments to help explain the occurrence or non-occurrence event."
    type: string
    sql: ${TABLE}."NOTES" ;;
  }

  dimension: occurrence_type {
    label: "Occurence Type"
    description: "Identifies what the occurrence or issue was (example, Absent, Late, Left Early, Bereavement, Long Break…etc)."
    type: string
    sql: ${TABLE}."OCCURRENCE" ;;
  }

  dimension: points {
    label: "Points"
    description: "The value of the points against the agent for occurence events (0.5, 1.0, 1.5, or possibly -.5, -1.0 for earned back time)."
    type: number
    sql: ${TABLE}."POINTS" ;;
  }

  dimension: sick_time {
    label: "Sick Time"
    description: "How many hours of Sick Time was the agent using and needed to submit into Workday."
    type: number
    sql: ${TABLE}."SICK_TIME" ;;
  }

  dimension: sub_occurrence {
    label: "Sub Occurrance"
    description: "sub category of the type of Occurrence (was it Sick Time, FMLA or other Standard Procedure for points or was it an Exception/Excused or just for tracking notes/comments"
    type: string
    sql: ${TABLE}."SUB_OCCURRENCE" ;;
  }

  dimension: vm {
    label: "Left Voicemail"
    description: "Identifies if the agent called the attendance line and left a Voice Message."
    type: yesno
    sql: case when ${TABLE}."VM" = 'true' then TRUE else FALSE end ;;
  }

  ##########################################################################################
  ##########################################################################################
  ## DATE/TIME DIMENSIONS

  # The DATE field does not need to be included as a date field.  It is used as more of a flag field.

  dimension_group: combined_date {
    label: "Event"
    description: "The date recorded event took place."
    hidden: no
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
    sql: ${TABLE}."COMBINED_DATES" ;;
  }

  dimension_group: insert_ts {
    label: "Inserted"
    description: "Date record was inserted in database."
    # hidden: yes
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

  ##########################################################################################
  ##########################################################################################
  ## MEASURES


  measure: count {
    label: "Count of all recorded events"
    hidden: yes
    type: count
  }

  measure: current_points {
    label: "Current Points"
    description: "Current summary of Attendence Points"
    type: number
    value_format_name: decimal_1
    sql: zeroifnull(sum(${points})) ;;
    html: <a href="https://purple.looker.com/dashboards-next/4398">{{ value }}</a> ;;
  }

  measure: fmla_time_used {
    label: "FMLA Time Used"
    description: "FMLA time used in given period."
    type: sum
    value_format_name: decimal_0
    sql: case when ${fmla} > 0 then ${fmla} else 0 end ;;
  }

  measure: last_occurrence {
    label: "Last Occurrence"
    description: "Most recent date when an occurrence event was recorded."
    type: date
    sql: max(case when ${is_occurrence} = True then ${combined_date_date}
      else null end) ;;
    html: <a href="https://purple.looker.com/dashboards-next/4398">{{ value }}</a> ;;
  }

  measure: non_occurrence_count {
    label: "Non-Occurrence Count"
    description: "Sum count of Non-Occurrence events."
    hidden: yes
    type: number
    value_format_name: decimal_0
    sql: case when ${is_occurrence}  True then 0 else 1 end ;;
  }

  measure: occurrence_count {
    label: "Occurrence Count"
    description: "Sum count of Occurrence events."
    type: number
    value_format_name: decimal_0
    sql: sum(case when ${is_occurrence} = True then 1 else 0 end) ;;
  }

  measure: occurrence_hit_points {
    # hidden: yes
    type: sum
    sql: case when ${points} > 0 then ${points} else 0 end ;;
  }

  measure: sick_time_used {
    label: "Sick Time Used"
    description: "Sick time used in given period."
    type: sum
    value_format_name: decimal_0
    sql: case when ${sick_time} > 0 then ${sick_time} else 0 end ;;
  }
}
