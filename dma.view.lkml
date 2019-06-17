#-------------------------------------------------------------------
# Owner - Russ Macbeth
# Designated Marketing Area - Taking zip codes and grouping them into
#   groups for easier display and tracking.
#-------------------------------------------------------------------

view: dma {
  sql_table_name: analytics.marketing.DMA_FIPS_LKP ;;

  dimension: dma_name {
    label: "DMA"
    description: "Designated Marketing Area - derived from zipcode"
    type: string
    view_label: "Customer"
    group_label: "Customer Address"
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
    sql: ${TABLE}.dma_ID ;;
  }

  dimension: dma_name2 {
    type: string
    hidden: yes
    sql: ${TABLE}.dma_full_name ;;
  }

  dimension: zip {
    type: zipcode
    primary_key: yes
    hidden: yes
    sql: ${TABLE}.zipcode ;;
  }

  dimension: County {
    group_label: "Customer Address"
    description:"Name of the County the Zipcode is in"
    type: string
    hidden: no
    sql: ${TABLE}.county ;;
  }

  dimension: FIPS {
    label: "FIPS Code"
    group_label: "Customer Address"
    description: "The County FIPS number (combination of a state ID and County ID"
    type: string
    hidden: no
    sql: ${TABLE}.FIPS ;;
  }

  dimension: Class {
    description: "A technical classification of the county see more here https://www2.census.gov/geo/pdfs/reference/ClassCodes.pdf"
    type: string
    hidden: yes
    sql: ${TABLE}.Class ;;
  }


  measure: count {
    type: count
    hidden: yes
    drill_fields: [dma_name]
  }

}
