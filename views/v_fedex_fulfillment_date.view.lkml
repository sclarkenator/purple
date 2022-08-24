view: fedex_fulfillment_date {
  sql_table_name: "SALES"."V_FEDEX_FULFILLMENT_DATE"
    ;;

  dimension_group: fedex_delivery {
    type: time
    view_label: "Fulfillment"
    group_label: "FedEx Delivered"
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
    sql: ${TABLE}."FEDEX_DELIVERY_DATE" ;;
  }

  dimension: fulfillment_id {
    type: number
    primary_key: yes
    view_label: "Fulfillment"
    group_label: "FedEx Delivered"
    sql: ${TABLE}."FULFILLMENT_ID" ;;
  }

  dimension: tracking_numbers {
    type: string
    view_label: "Fulfillment"
    group_label: "FedEx Delivered"
    sql: ${TABLE}."TRACKING_NUMBERS" ;;
  }

  measure: fulfillment_id_count_delivered {
    type: count_distinct
    view_label: "Fulfillment"
    group_label: "FedEx Delivered"
    sql: ${TABLE}."FULFILLMENT_ID" ;;

  }


}
