view: dma {
  sql_table_name: PUBLIC.DMA ;;

  dimension: country {
    type: string
    hidden: yes
    map_layer_name: countries
    sql: ${TABLE}."COUNTRY" ;;
  }

  dimension: dma {
    type: string
    hidden: yes
    sql: ${TABLE}."DMA" ;;
  }

  dimension: dma_name {
    type: string
    view_label: "Customer"
    group_label: "Customer address"
    sql: ${TABLE}."DMA_NAME" ;;
  }

  dimension: dma_name2 {
    type: string
    hidden: yes
    sql: ${TABLE}."DMA_NAME2" ;;
  }

  dimension: zip {
    type: zipcode
    primary_key: yes
    hidden: yes
    sql: ${TABLE}."ZIP" ;;
  }

  measure: count {
    type: count
    hidden: yes
    drill_fields: [dma_name]
  }
}
