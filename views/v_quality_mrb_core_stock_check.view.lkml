# The name of this view in Looker is "V Quality Mrb Core Stock Check"
view: v_quality_mrb_core_stock_check {
  # The sql_table_name parameter indicates the underlying database table
  # to be used for all fields in this view.
  sql_table_name: "L2L"."V_QUALITY_MRB_CORE_STOCK_CHECK"
    ;;
  # No primary key is defined for this view. In order to join this view in an Explore,
  # define primary_key: yes on a dimension that has no repeated values.

  # Here's what a typical dimension looks like in LookML.
  # A dimension is a groupable field that can be used to filter query results.
  # This dimension will be called "Area" in Explore.

  dimension: area {
    type: string
    sql: ${TABLE}."AREA" ;;
  }

  dimension: core_type {
    type: string
    sql: ${TABLE}."CORE_TYPE" ;;
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

  dimension: defect {
    type: string
    sql: ${TABLE}."DEFECT" ;;
  }

  dimension: description {
    type: string
    sql: ${TABLE}."DESCRIPTION" ;;
  }

  dimension: dispatch_num {
    type: string
    sql: ${TABLE}."DISPATCH_NUM" ;;
  }

  dimension: final_disposition {
    type: string
    sql: ${TABLE}."FINAL_DISPOSITION" ;;
  }

  dimension: l_and_p_production_line {
    type: string
    sql: ${TABLE}."L_AND_P_PRODUCTION_LINE" ;;
  }

  dimension: line {
    type: string
    sql: ${TABLE}."LINE" ;;
  }

  dimension: machine_code {
    type: string
    sql: ${TABLE}."MACHINE_CODE" ;;
  }

  dimension: mfg_date {
    type: string
    sql: ${TABLE}."MFG_DATE" ;;
  }

  dimension_group: modified {
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
    sql: CAST(${TABLE}."MODIFIED" AS TIMESTAMP_NTZ) ;;
  }

  dimension: name {
    type: string
    sql: ${TABLE}."NAME" ;;
  }

  dimension: noncome_cause {
    type: string
    sql: ${TABLE}."NONCOME_CAUSE" ;;
  }

  dimension: number {
    type: string
    sql: ${TABLE}."NUMBER" ;;
  }

  dimension: purchase_order {
    type: string
    sql: ${TABLE}."PURCHASE_ORDER" ;;
  }

  dimension: quantity {
    type: string
    sql: ${TABLE}."QUANTITY" ;;
  }

  dimension: site {
    type: string
    sql: ${TABLE}."SITE" ;;
  }

  dimension: size {
    type: string
    sql: ${TABLE}."SIZE" ;;
  }

  dimension: sqc_core {
    type: string
    sql: ${TABLE}."SQC_CORE" ;;
  }

  dimension: sqc_initials_found {
    type: string
    sql: ${TABLE}."SQC_INITIALS_FOUND" ;;
  }

  dimension: status {
    type: string
    sql: ${TABLE}."STATUS" ;;
  }

  dimension: supplier {
    type: string
    sql: ${TABLE}."SUPPLIER" ;;
  }

  dimension: technology {
    type: string
    sql: ${TABLE}."TECHNOLOGY" ;;
  }

  measure: count {
    type: count
    drill_fields: [name]
  }
}
