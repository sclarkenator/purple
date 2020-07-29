view: v_dispatch {
  sql_table_name: "L2L"."V_DISPATCH"
    ;;

  dimension: area {
    label: "Area"
    type: string
    sql: ${TABLE}."AREA" ;;
  }

  dimension: dispatch_code {
    label: "Dispatch Type"
    type: string
    sql: ${TABLE}."DISPATCH_CODE" ;;
  }

  dimension: dispatch_minutes_dimension {
    hidden: yes
    label: "Dispatch Minutes Dimension"
    description: "Number of Minutes the Dispatch Occured"
    type: number
    sql: ${TABLE}."DISPATCH_MINUTES" ;;
  }

  dimension: dispatch_number {
    type: number
    sql: ${TABLE}."DISPATCH_NUMBER" ;;
  }

  dimension_group: dispatched {
    label: "Dispatch"
    description: "Time dispatch was sent to a tech"
    type: time
    timeframes: [date, day_of_week, day_of_month, week, week_of_year, month, month_name, quarter, quarter_of_year, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}."DISPATCHED" ;;
  }

  dimension_group: started {
    label: "Start"
    description: "Date dispatch started"
    type: time
    timeframes: [date, day_of_week, day_of_month, week, week_of_year, month, month_name, quarter, quarter_of_year, year]
    sql: ${TABLE}."STARTED" ;;
  }

  dimension_group: ended {
    label: "End"
    description: "Date dispatch ended"
    type: time
    timeframes: [date, day_of_week, day_of_month, week, week_of_year, month, month_name, quarter, quarter_of_year, year]
    sql: ${TABLE}."ENDED" ;;
  }

  dimension: line {
    type: string
    sql: ${TABLE}."LINE" ;;
  }

  dimension: machine {
    type: string
    sql: ${TABLE}."MACHINE" ;;
  }

  dimension: machine_id {
    type: number
    sql: ${TABLE}."MACHINE_ID" ;;
  }

  dimension: site {
    label: "Site"
    description: "Site name (Grantsville/Alpine)"
    type: string
    sql: ${TABLE}."SITE" ;;
  }

measure: dispatch_count {
  label: "Count of Dispatch's"
  description: "Count of distinct Dispatch's"
  type: count_distinct
  sql: ${TABLE}."DISPATCH_NUMBER" ;;
}

  measure: dispatch_minutes {
    label: "Dispatch Minutes"
    description: "Number of Minutes the Dispatch Occured"
    type: sum
    sql: ${TABLE}."DISPATCH_MINUTES" ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
