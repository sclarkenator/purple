view: v_incoming_inspection_form {
  sql_table_name: "L2L"."V_INCOMING_INSPECTION_FORM"
    ;;

  dimension: area {
    type: string
    hidden: yes
    sql: ${TABLE}."AREA" ;;
  }

  dimension_group: created {
    label: "  Created"
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

  dimension: description {
    type: string
    sql: ${TABLE}."DESCRIPTION" ;;
  }

  dimension: dispatch_num {
    type: string
    sql: ${TABLE}."DISPATCH_NUM" ;;
  }

  dimension: checklist_number_bucketed{
   label: "Checklist Number (Bucketed)"
   type: string
    sql: ${TABLE}."LEFT_SIX" ;;
  }

  dimension: line {
    type: string
    hidden: yes
    sql: ${TABLE}."LINE" ;;
  }

  dimension: machine_code {
    type: string
    hidden: yes
    sql: ${TABLE}."MACHINE_CODE" ;;
  }

  dimension_group: modified {
    type: time
    hidden: yes
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

  dimension: checklist_number_raw {
    label: "Checklist Number"
    type: string
    sql: ${TABLE}."NUMBER" ;;
  }

  dimension: part_number {
    type: string
    sql: ${TABLE}."PART_NUMBER" ;;
  }

  measure: qty_rejected {
    type: sum
    label: "Quantity Rejected"
    sql: try_cast(${TABLE}."QTY_REJECTED" AS INT);;
  }

  dimension: site {
    label: "Production Site"
    type: string
    sql: CASE WHEN ${TABLE}.site = '2' THEN 'Grantsville'
              WHEN ${TABLE}.site = '3' THEN 'Alpine'
              WHEN ${TABLE}.site = '4' THEN 'McDonough'
              ELSE ${TABLE}.site END;;
  }

  dimension: status {
    type: string
    sql: ${TABLE}."STATUS" ;;
  }

  dimension: technology {
    type: string
    hidden: yes
    sql: ${TABLE}."TECHNOLOGY" ;;
  }

  dimension: vendor_name {
    type: string
    sql: ${TABLE}."VENDOR_NAME" ;;
  }

  measure: count {
    type: count
    hidden: yes
    drill_fields: [name, vendor_name]
  }
}
