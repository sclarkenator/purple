view: sla_hist {
  sql_table_name: "SHIPPING"."SLA_HIST"
    ;;

  measure: days {
    view_label: "Fulfillment"
    group_label: "Advanced"
    type: number
    sql: ${TABLE}."DAYS" ;;
    label: "Website-stated SLA"
    description: "This is the stated SLA value the customer saw when they made their purchase."
  }

  dimension_group: start {
    hidden: yes
    type: time
    timeframes: [date,week]
    convert_tz: no
    datatype: date
    sql: ${TABLE}."START_DATE" ;;
  }

  dimension_group: end {
    hidden: yes
    type: time
    timeframes: [date,week]
    convert_tz: no
    datatype: date
    sql: ${TABLE}."END_DATE" ;;
  }

  dimension: sku_id {
    hidden: yes
    type: string
    sql: ${TABLE}."SKU_ID" ;;
  }


}
