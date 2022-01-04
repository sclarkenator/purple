view: v_refurb_pillows_wm {
  sql_table_name: "L2L"."V_REFURB_PILLOWS_WM" ;;

  dimension: area {
    type: string
    sql: ${TABLE}."AREA" ;;
  }

  dimension_group: created {
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
    sql: CAST(${TABLE}."CREATED" AS TIMESTAMP_NTZ) ;;
  }

  dimension: date_of_inspection {
    type: string
    sql: ${TABLE}."DATE_OF_INSPECTION" ;;
  }

  dimension: description {
    type: string
    sql: ${TABLE}."DESCRIPTION" ;;
  }

  dimension: dispatch_num {
    type: string
    sql: ${TABLE}."DISPATCH_NUM" ;;
  }

  dimension: item_1 {
    type: string
    sql: ${TABLE}."ITEM_1" ;;
  }

  dimension: item_2 {
    type: string
    sql: ${TABLE}."ITEM_2" ;;
  }

  dimension: item_3 {
    type: string
    sql: ${TABLE}."ITEM_3" ;;
  }

  dimension: item_4 {
    type: string
    sql: ${TABLE}."ITEM_4" ;;
  }

  dimension: item_5 {
    type: string
    sql: ${TABLE}."ITEM_5" ;;
  }

  dimension: item_6 {
    type: string
    sql: ${TABLE}."ITEM_6" ;;
  }

  dimension: item_7 {
    type: string
    sql: ${TABLE}."ITEM_7" ;;
  }

  dimension: item_8 {
    type: string
    sql: ${TABLE}."ITEM_8" ;;
  }

  dimension: line {
    type: string
    sql: ${TABLE}."LINE" ;;
  }

  dimension: machine_code {
    type: string
    sql: ${TABLE}."MACHINE_CODE" ;;
  }

  dimension_group: modified {
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
    sql: CAST(${TABLE}."MODIFIED" AS TIMESTAMP_NTZ) ;;
  }

  dimension: name {
    type: string
    sql: ${TABLE}."NAME" ;;
  }

  dimension: name_of_person_overlooking_project {
    type: string
    sql: ${TABLE}."NAME_OF_PERSON_OVERLOOKING_PROJECT" ;;
  }

  dimension: notes_description_of_other_1 {
    type: string
    sql: ${TABLE}."NOTES_DESCRIPTION_OF_OTHER_1" ;;
  }

  dimension: notes_description_of_other_2 {
    type: string
    sql: ${TABLE}."NOTES_DESCRIPTION_OF_OTHER_2" ;;
  }

  dimension: notes_description_of_other_3 {
    type: string
    sql: ${TABLE}."NOTES_DESCRIPTION_OF_OTHER_3" ;;
  }

  dimension: notes_description_of_other_4 {
    type: string
    sql: ${TABLE}."NOTES_DESCRIPTION_OF_OTHER_4" ;;
  }

  dimension: notes_description_of_other_5 {
    type: string
    sql: ${TABLE}."NOTES_DESCRIPTION_OF_OTHER_5" ;;
  }

  dimension: notes_description_of_other_6 {
    type: string
    sql: ${TABLE}."NOTES_DESCRIPTION_OF_OTHER_6" ;;
  }

  dimension: notes_description_of_other_7 {
    type: string
    sql: ${TABLE}."NOTES_DESCRIPTION_OF_OTHER_7" ;;
  }

  dimension: notes_description_of_other_8 {
    type: string
    sql: ${TABLE}."NOTES_DESCRIPTION_OF_OTHER_8" ;;
  }

  dimension: number {
    type: string
    sql: ${TABLE}."NUMBER" ;;
  }

  dimension: product_numbers {
    type: string
    sql: ${TABLE}."PRODUCT_NUMBERS" ;;
  }

  dimension: product_sku_name {
    type: string
    sql: ${TABLE}."PRODUCT_SKU_NAME" ;;
  }

  dimension: rma_or_bol {
    type: string
    sql: ${TABLE}."RMA_OR_BOL" ;;
  }

  dimension: rownum {
    type: number
    sql: ${TABLE}."ROWNUM" ;;
  }

  dimension: shipping_information {
    type: string
    sql: ${TABLE}."SHIPPING_INFORMATION" ;;
  }

  dimension: site {
    type: string
    sql: ${TABLE}."SITE" ;;
  }

  dimension: status {
    type: string
    sql: ${TABLE}."STATUS" ;;
  }

  dimension: technology {
    type: string
    sql: ${TABLE}."TECHNOLOGY" ;;
  }

  dimension: to_be_done_description_on_how_to_get_shipping_information {
    type: string
    sql: ${TABLE}."TO_BE_DONE_DESCRIPTION_ON_HOW_TO_GET_SHIPPING_INFORMATION" ;;
  }

  dimension: will_it_ship_with_others {
    type: string
    sql: ${TABLE}."WILL_IT_SHIP_WITH_OTHERS" ;;
  }

  measure: total_rownum {
    type: sum
    sql: ${rownum} ;;
  }

  measure: average_rownum {
    type: average
    sql: ${rownum} ;;
  }

  measure: quantity_sanitized {
    type: sum
    sql: ${TABLE}."QUANTITY_SANITIZED" ;;
  }

  measure: qty_received {
    type: sum
    sql: ${TABLE}."QTY_RECEIVED" ;;
  }

  measure: hep_indent {
    type: sum
    sql: ${TABLE}."HEP_INDENT" ;;
  }

  measure: count {
    type: count
    drill_fields: [product_sku_name, name]
  }
}
