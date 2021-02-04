view: ups_tracking {
  sql_table_name: "SHIPPING"."UPS_TRACKING";;

  dimension: completed {
    type: yesno
    view_label: "Fulfillment"
    group_label: "UPS Details"
    description: "Source: shipping.ups_tracking"
    sql: ${TABLE}."COMPLETED" ;;
  }

  dimension_group: status_ts {
    label: "UPS Last Scan"
    view_label: "Fulfillment"
    group_label: "UPS Details"
    description: "Source: shipping.ups_tracking"
    type: time
    timeframes: [
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
    group_label: "UPS Details"
    description: "Source: shipping.ups_tracking"
    type: string
    primary_key: yes
    sql: ${TABLE}."TRACKING_NUMBER" ;;
  }

  dimension: ups_status_code {
    hidden: yes
    view_label: "Fulfillment"
    group_label: "UPS Details"
    description: "Source: shipping.ups_tracking"
    type: string
    sql: ${TABLE}."UPS_STATUS_CODE" ;;
  }

  dimension: ups_status_description {
    label: "UPS Status"
    type: string
    view_label: "Fulfillment"
    group_label: "UPS Details"
    description: "Source: shipping.ups_tracking"
    sql: ${TABLE}."UPS_STATUS_DESCRIPTION" ;;
  }

  dimension: ups_days_since_last_scan {
    label: "UPS Days Since Last Scan "
    type: number
    view_label: "Fulfillment"
    group_label: "UPS Details"
    description: "Source: shipping.ups_tracking"
    sql: datediff(day, ${TABLE}."STATUS_TS", current_timestamp())  ;;
  }

  dimension: ups_days_since_last_scan_bins {
    label: "UPS Days Since Last Scan Bins"
    type: tier
    view_label: "Fulfillment"
    group_label: "UPS Details"
    description: "Source: shipping.ups_tracking"
    tiers: [0,1,2,3,4,5,10]
    style: integer
    sql: ${ups_days_since_last_scan} ;;
  }


  measure: ups_label_count {
    type: count
    description: "UPS Label Count. Source:shipping.ups_tracking"
    view_label: "Fulfillment"
    group_label: " Advanced"
    drill_fields: [tracking_number, sales_order_line.order_id, ups_status_description, status_ts_date, ups_days_since_last_scan, completed] ##NOTE## This drill references sales_order_line. It will break if not joined to sales_order_line in the explore.
  }
}
