view: v_mattress_cogs {
  derived_table: {
    sql: select * from "PRODUCTION"."V_MATTRESS_COGS" ;;
    persist_for: "24 hours"
  }

  dimension: pk {
    primary_key: yes
    hidden: yes
    sql: ${item_id}||'-'||${sub_component}||'-'||${TABLE}.month ;;
  }

  measure: cogs {
    type: sum
    label: "COGS"
    value_format: "$0.00"
    description: "Most recent price"
    sql: ${TABLE}."COGS" ;;
  }

  dimension: item_id {
    hidden: yes
    type: number
    sql: ${TABLE}."ITEM_ID" ;;
  }

  dimension_group: month {
    type: time
    timeframes: [
      month,
      month_name,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}."MONTH" ;;
  }

  dimension: sub_component {
    hidden: yes
    type: number
    sql: ${TABLE}."SUB_COMPONENT" ;;
  }

}
