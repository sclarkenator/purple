view: v_dispatch {
  sql_table_name: "L2L"."V_DISPATCH"
    ;;

 dimension: area {
    hidden: no
    label: "Area"
    type: string
    sql: ${TABLE}."AREA" ;;
  }

  dimension: dispatch_code {
    hidden: yes
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
    hidden: yes
    type: number
    sql: ${TABLE}."DISPATCH_NUMBER" ;;
  }

  dimension_group: dispatched {
    hidden: no
    label: "Dispatched"
    description: "Time dispatch was sent to a tech"
    type: time
    timeframes: [date, day_of_week, day_of_month, week, week_of_year, month, month_name, quarter, quarter_of_year, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}."DISPATCHED" ;;
  }

  dimension_group: started {
    hidden: yes
    label: "Start"
    description: "Date dispatch started"
    type: time
    timeframes: [date, day_of_week, day_of_month, week, week_of_year, month, month_name, quarter, quarter_of_year, year]
    sql: ${TABLE}."STARTED" ;;
  }

  dimension_group: ended {
    hidden: yes
    label: "End"
    description: "Date dispatch ended"
    type: time
    timeframes: [date, day_of_week, day_of_month, week, week_of_year, month, month_name, quarter, quarter_of_year, year]
    sql: ${TABLE}."ENDED" ;;
  }

  dimension: line {
    hidden: yes
    type: string
    sql: ${TABLE}."LINE" ;;
  }

  dimension: machine {
    hidden: yes
    type: string
    sql: ${TABLE}."MACHINE" ;;
  }

  dimension: machine_id {
    hidden: yes
    type: number
    sql: ${TABLE}."MACHINE_ID" ;;
  }

  dimension: site {
    hidden: yes
    label: "Site"
    description: "Site name (Grantsville/Alpine)"
    type: string
    sql: ${TABLE}."SITE" ;;
  }

measure: dispatch_occurences {
  label: "Dispatch Occurrences"
  description: "Count of distinct Dispatch Occurrences to be used with Dispatched Date"
  type: count_distinct
  sql: ${TABLE}."DISPATCH_NUMBER" ;;
}

  measure: dispatch_minutes {
    label: "Dispatch Minutes"
    description: "Number of Minutes the Dispatch Occured to be used with Dispatched Date"
    value_format: "#,##0"
    type: sum
    sql: ${TABLE}."DISPATCH_MINUTES" ;;
  }

  measure: dispatch_hours {
    label: "Dispatch Hours"
    description: "Number of Hours the Dispatch Occured to be used with Dispatched Date"
    value_format: "#,##0.00"
    type: sum
    sql: ${TABLE}."DISPATCH_MINUTES"/60 ;;
    }

  measure: count {
    type: count
    drill_fields: []
  }
}
