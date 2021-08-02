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
