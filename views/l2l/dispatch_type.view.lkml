view: dispatch_type {
  sql_table_name: "L2L"."DISPATCH_TYPE"
    ;;
  drill_fields: [dispatch_type_id]

  dimension: dispatch_type_id {
    hidden: yes
    primary_key: yes
    type: number
    sql: ${TABLE}."DISPATCH_TYPE_ID" ;;
  }

  dimension: action_component_required {
    description: "Source: l2l.dispatch_type"
    type: yesno
    sql: ${TABLE}."ACTION_COMPONENT_REQUIRED" ;;
  }

  dimension: allow_multiple {
    description: "Source: l2l.dispatch_type"
    type: yesno
    sql: ${TABLE}."ALLOW_MULTIPLE" ;;
  }

  dimension: code {
    description: "Source: l2l.dispatch_type"
    type: string
    sql: ${TABLE}."CODE" ;;
  }

  dimension: code_bucket {
    description: "Source: Looker Calculation"
    type: string
    sql: case
      when ${code} = 'Labor' then 'Labor'
      when ${code} = 'Materials' then 'Material'
      when ${code} in ('Code Red', 'Code Black', 'Production Machine Setup', 'Tooling Setup') then 'Equipment'
      else 'Other'
      end ;;
  }

  dimension_group: created {
    hidden: yes
    type: time
    timeframes: [raw, hour_of_day, date, day_of_week, day_of_week_index, day_of_month, day_of_year, week, week_of_year, month, month_num, month_name, quarter, quarter_of_year, year]
    convert_tz: no
    datatype: timestamp
    sql: CAST(${TABLE}."CREATED" AS TIMESTAMP_NTZ) ;;
  }

  dimension: created_by {
    hidden: yes
    type: string
    sql: ${TABLE}."CREATED_BY" ;;
  }

  dimension: critical {
    description: "Source: l2l.dispatch_type"
    type: yesno
    sql: ${TABLE}."CRITICAL" ;;
  }

  dimension: description {
    label: "Dispatch Type Description"
    description: "Source: l2l.dispatch_type"
    type: string
    sql: ${TABLE}."DESCRIPTION" ;;
  }

  dimension: exclude_production_dashboard {
    description: "Source: l2l.dispatch_type"
    type: yesno
    sql: ${TABLE}."EXCLUDE_PRODUCTION_DASHBOARD" ;;
  }

  dimension: highlight_critical {
    description: "Source: l2l.dispatch_type"
    type: yesno
    sql: ${TABLE}."HIGHLIGHT_CRITICAL" ;;
  }

  dimension: impact {
    description: "Source: l2l.dispatch_type"
    type: number
    sql: ${TABLE}."IMPACT" ;;
  }

  dimension_group: inactivated {
    hidden: yes
    type: time
    timeframes: [raw, hour_of_day, date, day_of_week, day_of_week_index, day_of_month, day_of_year, week, week_of_year, month, month_num, month_name, quarter, quarter_of_year, year]
    convert_tz: no
    datatype: timestamp
    sql: CAST(${TABLE}."INACTIVATED" AS TIMESTAMP_NTZ) ;;
  }

  dimension: inactive {
    description: "Source: l2l.dispatch_type"
    type: yesno
    sql: ${TABLE}."INACTIVE" ;;
  }

  dimension: open {
    description: "Source: l2l.dispatch_type"
    type: yesno
    sql: ${TABLE}."OPEN" ;;
  }

  dimension: operator_type {
    description: "Source: l2l.dispatch_type"
    type: yesno
    sql: ${TABLE}."OPERATOR_TYPE" ;;
  }

  dimension: priority {
    description: "Source: l2l.dispatch_type"
    type: number
    sql: ${TABLE}."PRIORITY" ;;
  }

  dimension: reason_required {
    description: "Source: l2l.dispatch_type"
    type: yesno
    sql: ${TABLE}."REASON_REQUIRED" ;;
  }

  dimension: require_quality_fields {
    description: "Source: l2l.dispatch_type"
    type: yesno
    sql: ${TABLE}."REQUIRE_QUALITY_FIELDS" ;;
  }

  dimension: resource_required {
    description: "Source: l2l.dispatch_type"
    type: yesno
    sql: ${TABLE}."RESOURCE_REQUIRED" ;;
  }

  dimension: site_id {
    hidden: yes
    type: number
    sql: ${TABLE}."SITE_ID" ;;
  }

  dimension: start_when_dispatched {
    description: "Source: l2l.dispatch_type"
    type: yesno
    sql: ${TABLE}."START_WHEN_DISPATCHED" ;;
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

  dimension_group: updated {
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
    sql: CAST(${TABLE}."UPDATED" AS TIMESTAMP_NTZ) ;;
  }

  dimension: updated_by {
    hidden: yes
    type: string
    sql: ${TABLE}."UPDATED_BY" ;;
  }

  dimension: user_create_type {
    description: "Source: l2l.dispatch_type"
    type: yesno
    sql: ${TABLE}."USER_CREATE_TYPE" ;;
  }

  dimension: why_required {
    description: "Source: l2l.dispatch_type"
    type: yesno
    sql: ${TABLE}."WHY_REQUIRED" ;;
  }
}
