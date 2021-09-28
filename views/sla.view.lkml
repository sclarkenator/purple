view: sla {
  sql_table_name: "SHIPPING"."SLA"
    ;;

  dimension_group: order {
    hidden:  yes
    type: time
    timeframes: [
      date
    ]
    sql: CAST(${TABLE}."INSERT_TS" AS TIMESTAMP_NTZ) ;;
  }

  dimension: sku_id {
    hidden:  yes
    type: string
    sql: ${TABLE}."SKU_ID" ;;
  }

  dimension: sla {
    hidden:  yes
    type: number
    sql: ${TABLE}."SLA" ;;
  }

  dimension: sla_range {
    view_label: "Fulfillment"
    label: "Site SLA range"
    group_label: "Website SLAs"
    type: string
    sql: ${TABLE}."SLA_RANGE" ;;
  }

  dimension: wg_sla_range {
    view_label: "Fulfillment"
    label: "White Glove SLA range"
    group_label: "Website SLAs"
    type: string
    sql: ${TABLE}."WG_SLA_RANGE" ;;
  }

  dimension: days_from_order {
    view_label: "Fulfillment"
    label: "Days from Order Date"
    group_label: "Website SLAs"
    type: number
    sql: datediff(d, ${sales_order_line.created_date}, current_date);;
  }

  dimension: days_from_sla_standard {
    view_label: "Fulfillment"
    label: "Days from SLA - Standard Shipping"
    group_label: "Website SLAs"
    description: "Day from SLA if the item is going through standard shipping"
    type: number
    sql: datediff(d, current_date, ${sales_order_line.sla_ship});;
  }

  dimension: days_from_sla_wg {
    view_label: "Fulfillment"
    label: "Days from SLA - White Glove"
    group_label: "Website SLAs"
    description: "Days from SLA if the item is shipping through a Premier Delivery partner"
    type: number
    sql: datediff(d, current_date, ${sales_order_line.wg_sla_ship}) ;;
  }

  dimension: days_from_sla {
    view_label: "Fulfillment"
    label: "Days from SLA"
    group_label: "Website SLAs"
    description: "Days from SLA. Negative values indicate we are past the SLA as shown on the date the order was placed."
    type: number
    sql: case when ${sales_order_line.ship_flag} then ${sla.days_from_sla_standard} else ${sla.days_from_sla_wg} end  ;;
  }

  dimension: past_sla_days {
  view_label: "Fulfillment"
  label: "Days past due"
  group_label: "Website SLAs"
  description: "Days from SLA. Negative values indicate we are past the SLA as shown on the date the order was placed."
  case: {
    when: {
      sql: ${days_from_sla} >0 ;;
      label: "Within SLA"}
    when: {
      sql: ${days_from_sla} = 0 ;;
      label: "Due today"}
    when: {
      sql: ${days_from_sla}>-3 ;;
      label: "<3 days"}
    when: {
      sql: ${days_from_sla}>-8 ;;
      label: "<1 week"}
    when: {
      sql: ${days_from_sla}>-15 ;;
      label: "1-2 weeks"}
    when: {
      sql: ${days_from_sla}>-22 ;;
      label: "2-3 weeks"}
    when: {
      sql: ${days_from_sla}>-28 ;;
      label: "3-4 weeks"}
    when: {
      sql: ${days_from_sla} >-61 ;;
      label: "1-2 months"}
    when: {
      sql: ${days_from_sla}<-60 ;;
      label: "2+ months"}
    }
  }

  dimension: site_sla_to_use {
    hidden: yes
    type: date
    sql: case when ${sales_order_line.carrier_raw} in ('Parcel','Will Call','Carry Out','Mainfreight')  ;;
  }

  dimension: white_glove {
    hidden:  yes
    type: number
    sql: ${TABLE}."WHITE_GLOVE" ;;
  }

  dimension: pk {
    hidden: yes
    primary_key: yes
    sql: ${order_date}||'-'||${sku_id} ;;
  }
}
