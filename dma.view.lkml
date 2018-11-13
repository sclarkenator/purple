#-------------------------------------------------------------------
# Owner - Russ Macbeth
# Designated Marketing Area - Taking zip codes and grouping them into
#   groups for easier display and tracking.
#-------------------------------------------------------------------

view: dma {
  sql_table_name: PUBLIC.DMA ;;

  dimension: dma_name {
    label: "DMA"
    description: "Designated Marketing Area - derived from zipcode"
    type: string
    #view_label: "Customer"
    #group_label: "Customer address"
    sql: ${TABLE}.dma_name ;;
  }

  # Dimensions below are for joining reasons
  dimension: country {
    type: string
    hidden: yes
    map_layer_name: countries
    sql: ${TABLE}.country ;;
  }

  dimension: dma {
    type: string
    hidden: yes
    sql: ${TABLE}.dma ;;
  }

  dimension: dma_name2 {
    type: string
    hidden: yes
    sql: ${TABLE}.dma_name2 ;;
  }

  dimension: zip {
    type: zipcode
    primary_key: yes
    hidden: yes
    sql: ${TABLE}.zip ;;
  }

  measure: count {
    type: count
    hidden: yes
    drill_fields: [dma_name]
  }

}
