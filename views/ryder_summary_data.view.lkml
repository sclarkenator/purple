# The name of this view in Looker is "Ryder Summary Data"
view: ryder_summary_data {
  sql_table_name: "SHIPPING"."RYDER_SUMMARY_DATA"
    ;;

  dimension: carrier {
    group_label: "Ryder Info"
    type: string
    sql: ${TABLE}."CARRIER" ;;
  }

  # Dates and timestamps can be represented in Looker using a dimension group of type: time.
  # Looker converts dates and timestamps to the specified timeframes within the dimension group.

  dimension_group: created {
    group_label: "Ryder Info"
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
    sql: ${TABLE}."CREATED" ;;
  }

  dimension_group: current_status {
    group_label: "Ryder Info"
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
    sql: CAST(${TABLE}."CURRENT_STATUS_DATE" AS TIMESTAMP_NTZ) ;;
  }

  dimension: current_status_list {
    group_label: "Ryder Info"
    type: string
    sql: ${TABLE}."CURRENT_STATUS_LIST" ;;
  }

  dimension_group: first_offered {
    group_label: "Ryder Info"
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
    sql: CAST(${TABLE}."FIRST_OFFERED" AS TIMESTAMP_NTZ) ;;
  }

  dimension: missing_records {
    group_label: "Ryder Info"
    type: yesno
    sql: ${TABLE}."MISSING_RECORDS" ;;
  }

  dimension: order_id {
    group_label: "Ryder Info"
    primary_key: yes
    type: number
    sql: ${TABLE}."ORDER_ID" ;;
  }

  dimension: order_number {
    group_label: "Ryder Info"
    type: string
    sql: ${TABLE}."ORDER_NUMBER" ;;
  }

  dimension: order_type {
    group_label: "Ryder Info"
    type: string
    sql: ${TABLE}."ORDER_TYPE" ;;
  }

  measure: quantity {
    group_label: "Ryder Info"
    type: sum
    sql: ${TABLE}."QUANTITY" ;;
  }

  dimension: related_tranid {
    group_label: "Ryder Info"
    type: string
    sql: ${TABLE}."RELATED_TRANID" ;;
  }

  dimension: ryder_id {
    group_label: "Ryder Info"
    hidden: yes
    type: string
    sql: ${TABLE}."RYDER_ID" ;;
  }

  dimension_group: scheduled_appointment {
    group_label: "Ryder Info"
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
    sql: CAST(${TABLE}."SCHEDULED_APPOINTMENT_DATE" AS TIMESTAMP_NTZ) ;;
  }

  dimension: service_location_name {
    group_label: "Ryder Info"
    type: string
    sql: ${TABLE}."SERVICE_LOCATION_NAME" ;;
  }

  dimension: service_location_zip {
    group_label: "Ryder Info"
    type: string
    sql: ${TABLE}."SERVICE_LOCATION_ZIP" ;;
  }

  dimension: status_code {
    group_label: "Ryder Info"
    type: string
    sql: ${TABLE}."STATUS_CODE" ;;
  }

  dimension: status_description {
    group_label: "Ryder Info"
    type: string
    sql: ${TABLE}."STATUS_DESCRIPTION" ;;
  }

  dimension: tranid {
    group_label: "Ryder Info"
    type: string
    sql: ${TABLE}."TRANID" ;;
  }

  measure: total_quantity {
    group_label: "Ryder Info"
    type: sum
    sql: ${quantity} ;;
  }

  measure: average_quantity {
    group_label: "Ryder Info"
    type: average
    sql: ${quantity} ;;
  }
}
