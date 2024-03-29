view: site_slas {
  sql_table_name: "CSV_UPLOADS"."SITE_SLAS"
    ;;


  dimension: days {
    view_label: "Fulfillment"
    group_label: " Advanced"
    hidden:  yes
    type: number
    sql: ${TABLE}.sla_days ;;
    label: "Website-stated SLA"
    description: "This is the stated SLA value the customer saw when they made their purchase for DTC only"
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
