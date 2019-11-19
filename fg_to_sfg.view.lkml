view: fg_to_sfg {
  sql_table_name: PRODUCTION.FG_TO_SFG ;;

  dimension: fg_item_id {

    type: number
    sql: ${TABLE}."FG_ITEM_ID" ;;
  }

  dimension: finished_good_sku {
    type: string

    sql: ${TABLE}."FINISHED_GOOD_SKU" ;;
  }

  dimension: hep_item_id {
    type: number

    sql: ${TABLE}."HEP_ITEM_ID" ;;
  }

  dimension: hep_quantity {
    type: number
    sql: ${TABLE}."HEP_QUANTITY" ;;
  }

  dimension: hep_sku {
    type: string

    sql: ${TABLE}."HEP_SKU" ;;
  }

  dimension: mix_item_id {
    type: number

    sql: ${TABLE}."MIX_ITEM_ID" ;;
  }

  dimension: mix_quantity {
    type: number
    sql: ${TABLE}."MIX_QUANTITY" ;;
  }

  dimension: mix_sku {
    type: string

    sql: ${TABLE}."MIX_SKU" ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
