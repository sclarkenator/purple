view: product {
  sql_table_name: "L2L"."PRODUCT"
    ;;
  drill_fields: [product_id]

  dimension: product_id {
    hidden: yes
    primary_key: yes
    type: number
    sql: ${TABLE}."PRODUCT_ID" ;;
  }

  dimension: description {
    label: "Actual Product"
    type: string
    sql: ${TABLE}."DESCRIPTION" ;;
  }

  dimension: finished_product {
    hidden: yes
    type: yesno
    sql: ${TABLE}."FINISHED_PRODUCT" ;;
  }

  dimension: inactive {
    hidden: yes
    type: yesno
    sql: ${TABLE}."INACTIVE" ;;
  }

  dimension_group: insert_ts {
    hidden: yes
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
    sql: CAST(${TABLE}."INSERT_TS" AS TIMESTAMP_NTZ) ;;
  }

  dimension: raw_material {
    hidden: yes
    type: yesno
    sql: ${TABLE}."RAW_MATERIAL" ;;
  }

  dimension: site {
    hidden: yes
    type: number
    sql: ${TABLE}."SITE" ;;
  }

  dimension: sku {
    hidden: yes
    type: string
    sql: ${TABLE}."SKU" ;;
  }

  dimension: subassembly {
    hidden: yes
    type: yesno
    sql: ${TABLE}."SUBASSEMBLY" ;;
  }

  dimension_group: update_ts {
    hidden: yes
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
    sql: CAST(${TABLE}."UPDATE_TS" AS TIMESTAMP_NTZ) ;;
  }

  measure: count {
    hidden: yes
    type: count
    drill_fields: [product_id]
  }
}
