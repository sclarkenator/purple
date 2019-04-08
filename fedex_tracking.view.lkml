view: fedex_tracking {
  sql_table_name: PRODUCTION.FEDEX_TRACKING ;;

  dimension: account_number {
    type: string
    hidden:  yes
    sql: ${TABLE}."ACCOUNT_NUMBER" ;;
  }

  dimension: completed {
    type: yesno
    view_label: "Fulfillment"
    group_label: "FedEx Details"
    sql: ${TABLE}."COMPLETED" ;;
  }

  dimension: fedex_status_code {
    type: string
    hidden: yes
    view_label: "Fulfillment"
    group_label: "FedEx Details"
    sql: ${TABLE}."FEDEX_STATUS_CODE" ;;
  }

  dimension: fedex_status_description {
    label: "FedEx Status"
    type: string
    view_label: "Fulfillment"
    group_label: "FedEx Details"
    sql: ${TABLE}."FEDEX_STATUS_DESCRIPTION" ;;
  }

  dimension_group: status_ts {
    label: "Last Scan"
    view_label: "Fulfillment"
    group_label: "FedEx Details"
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
    sql: ${TABLE}."STATUS_TS" ;;
  }

  dimension: tracking_number {
    view_label: "Fulfillment"
    group_label: "FedEx Details"
    type: string
    primary_key: yes
    sql: ${TABLE}."TRACKING_NUMBER" ;;
  }

  dimension: days_since_last_scan {
    type: number
    view_label: "Fulfillment"
    group_label: "FedEx Details"
    sql: datediff(day, ${TABLE}."STATUS_TS", current_timestamp())  ;;
  }

  dimension: days_since_last_scan_bins {
    type: tier
    view_label: "Fulfillment"
    group_label: "FedEx Details"
    tiers: [0,1,2,3,4,5,10]
    style: integer
    sql: ${days_since_last_scan} ;;
  }

  measure: fedex_label_count {
    type: count
    description: "FedEx Label Count"
    view_label: "Fulfillment"
    group_label: "FedEx Details"
    drill_fields: [tracking_number, sales_order_line.order_id, fedex_status_description, status_ts_date, days_since_last_scan, completed] ##NOTE## This drill references sales_order_line. It will break if not joined to sales_order_line in the explore.
  }
}
