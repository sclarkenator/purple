view: nps_survey_dec2019 {
  sql_table_name: CSV_UPLOADS.NPS_SURVEY_DEC2019 ;;

  dimension: back_cushion {
    type: string
    sql: ${TABLE}."BACK_CUSHION" ;;
  }

  dimension_group: created {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}."CREATED_DATE" ;;
  }

  dimension: delivery_experience_satisfaction {
    type: string
    sql: ${TABLE}."DELIVERY_EXPERIENCE_SATISFACTION" ;;
  }

  dimension: double_cushion {
    type: string
    sql: ${TABLE}."DOUBLE_CUSHION" ;;
  }

  dimension: email {
    type: string
    sql: ${TABLE}."EMAIL" ;;
  }

  dimension: everywhere_cushion {
    type: string
    sql: ${TABLE}."EVERYWHERE_CUSHION" ;;
  }

  dimension_group: fulfilled {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}."FULFILLED_DATE" ;;
  }

  dimension: harmony_pillow {
    type: string
    sql: ${TABLE}."HARMONY_PILLOW" ;;
  }

  dimension: harmony_pillow_tall {
    type: string
    sql: ${TABLE}."HARMONY_PILLOW_TALL" ;;
  }

  dimension: hybrid_mattress_cal_king {
    type: string
    sql: ${TABLE}."HYBRID_MATTRESS_CAL_KING" ;;
  }

  dimension: hybrid_mattress_full {
    type: string
    sql: ${TABLE}."HYBRID_MATTRESS_FULL" ;;
  }

  dimension: hybrid_mattress_king {
    type: string
    sql: ${TABLE}."HYBRID_MATTRESS_KING" ;;
  }

  dimension: hybrid_mattress_queen {
    type: string
    sql: ${TABLE}."HYBRID_MATTRESS_QUEEN" ;;
  }

  dimension: hybrid_mattress_split_king {
    type: string
    sql: ${TABLE}."HYBRID_MATTRESS_SPLIT_KING" ;;
  }

  dimension: hybrid_mattress_twin_xl {
    type: string
    sql: ${TABLE}."HYBRID_MATTRESS_TWIN_XL" ;;
  }

  dimension: hybrid_premier_3_cal_king {
    type: string
    sql: ${TABLE}."HYBRID_PREMIER_3_CAL_KING" ;;
  }

  dimension: hybrid_premier_3_mattress_full {
    type: string
    sql: ${TABLE}."HYBRID_PREMIER_3_MATTRESS_FULL" ;;
  }

  dimension: hybrid_premier_3_mattress_king {
    type: string
    sql: ${TABLE}."HYBRID_PREMIER_3_MATTRESS_KING" ;;
  }

  dimension: hybrid_premier_3_queen {
    type: string
    sql: ${TABLE}."HYBRID_PREMIER_3_QUEEN" ;;
  }

  dimension: hybrid_premier_3_split_king {
    type: string
    sql: ${TABLE}."HYBRID_PREMIER_3_SPLIT_KING" ;;
  }

  dimension: hybrid_premier_3_twin_xl {
    type: string
    sql: ${TABLE}."HYBRID_PREMIER_3_TWIN_XL" ;;
  }

  dimension: hybrid_premier_4_cal_king {
    type: string
    sql: ${TABLE}."HYBRID_PREMIER_4_CAL_KING" ;;
  }

  dimension: hybrid_premier_4_mattress_full {
    type: string
    sql: ${TABLE}."HYBRID_PREMIER_4_MATTRESS_FULL" ;;
  }

  dimension: hybrid_premier_4_mattress_king {
    type: string
    sql: ${TABLE}."HYBRID_PREMIER_4_MATTRESS_KING" ;;
  }

  dimension: hybrid_premier_4_queen {
    type: string
    sql: ${TABLE}."HYBRID_PREMIER_4_QUEEN" ;;
  }

  dimension: hybrid_premier_4_split_king {
    type: string
    sql: ${TABLE}."HYBRID_PREMIER_4_SPLIT_KING" ;;
  }

  dimension: hybrid_premier_4_twin_xl {
    type: string
    sql: ${TABLE}."HYBRID_PREMIER_4_TWIN_XL" ;;
  }

  dimension: item_id {
    type: string
    sql: ${TABLE}."ITEM_ID" ;;
  }

  dimension: mattress_protector_california_king {
    type: string
    sql: ${TABLE}."MATTRESS_PROTECTOR_CALIFORNIA_KING" ;;
  }

  dimension: mattress_protector_full {
    type: string
    sql: ${TABLE}."MATTRESS_PROTECTOR_FULL" ;;
  }

  dimension: mattress_protector_full_xl {
    type: string
    sql: ${TABLE}."MATTRESS_PROTECTOR_FULL_XL" ;;
  }

  dimension: mattress_protector_king {
    type: string
    sql: ${TABLE}."MATTRESS_PROTECTOR_KING" ;;
  }

  dimension: mattress_protector_queen {
    type: string
    sql: ${TABLE}."MATTRESS_PROTECTOR_QUEEN" ;;
  }

  dimension: mattress_protector_split_king {
    type: string
    sql: ${TABLE}."MATTRESS_PROTECTOR_SPLIT_KING" ;;
  }

  dimension: mattress_protector_twin {
    type: string
    sql: ${TABLE}."MATTRESS_PROTECTOR_TWIN" ;;
  }

  dimension: mattress_protector_twin_xl {
    type: string
    sql: ${TABLE}."MATTRESS_PROTECTOR_TWIN_XL" ;;
  }

  dimension: nps_comment {
    type: string
    sql: ${TABLE}."NPS_COMMENT" ;;
  }

  dimension: nps_question {
    type: string
    sql: ${TABLE}."NPS_QUESTION" ;;
  }

  dimension: nps_question_group {
    type: string
    sql: ${TABLE}."NPS_QUESTION_GROUP" ;;
  }

  dimension: order_id {
    type: string
    sql: ${TABLE}."ORDER_ID" ;;
  }

  dimension: pet_bed_large {
    type: string
    sql: ${TABLE}."PET_BED_LARGE" ;;
  }

  dimension: pet_bed_medium {
    type: string
    sql: ${TABLE}."PET_BED_MEDIUM" ;;
  }

  dimension: pet_bed_small {
    type: string
    sql: ${TABLE}."PET_BED_SMALL" ;;
  }

  dimension: platform_base_california_king {
    type: string
    sql: ${TABLE}."PLATFORM_BASE_CALIFORNIA_KING" ;;
  }

  dimension: platform_base_full {
    type: string
    sql: ${TABLE}."PLATFORM_BASE_FULL" ;;
  }

  dimension: platform_base_king {
    type: string
    sql: ${TABLE}."PLATFORM_BASE_KING" ;;
  }

  dimension: platform_base_queen {
    type: string
    sql: ${TABLE}."PLATFORM_BASE_QUEEN" ;;
  }

  dimension: platform_base_twin {
    type: string
    sql: ${TABLE}."PLATFORM_BASE_TWIN" ;;
  }

  dimension: platform_base_twin_xl {
    type: string
    sql: ${TABLE}."PLATFORM_BASE_TWIN_XL" ;;
  }

  dimension: portable_cushion {
    type: string
    sql: ${TABLE}."PORTABLE_CUSHION" ;;
  }

  dimension: powerbase_queen {
    type: string
    sql: ${TABLE}."POWERBASE_QUEEN" ;;
  }

  dimension: powerbase_split_king {
    type: string
    sql: ${TABLE}."POWERBASE_SPLIT_KING" ;;
  }

  dimension: powerbase_twin_xl {
    type: string
    sql: ${TABLE}."POWERBASE_TWIN_XL" ;;
  }

  dimension: purple_mattress_cal_king {
    type: string
    sql: ${TABLE}."PURPLE_MATTRESS_CAL_KING" ;;
  }

  dimension: purple_mattress_full {
    type: string
    sql: ${TABLE}."PURPLE_MATTRESS_FULL" ;;
  }

  dimension: purple_mattress_king {
    type: string
    sql: ${TABLE}."PURPLE_MATTRESS_KING" ;;
  }

  dimension: purple_mattress_queen {
    type: string
    sql: ${TABLE}."PURPLE_MATTRESS_QUEEN" ;;
  }

  dimension: purple_mattress_split_king {
    type: string
    sql: ${TABLE}."PURPLE_MATTRESS_SPLIT_KING" ;;
  }

  dimension: purple_mattress_twin {
    type: string
    sql: ${TABLE}."PURPLE_MATTRESS_TWIN" ;;
  }

  dimension: purple_mattress_twin_xl {
    type: string
    sql: ${TABLE}."PURPLE_MATTRESS_TWIN_XL" ;;
  }

  dimension: purple_pillow {
    type: string
    sql: ${TABLE}."PURPLE_PILLOW" ;;
  }

  dimension: purple_plush_pillow {
    type: string
    sql: ${TABLE}."PURPLE_PLUSH_PILLOW" ;;
  }

  dimension: purple_plush_pillow_king {
    type: string
    sql: ${TABLE}."PURPLE_PLUSH_PILLOW_KING" ;;
  }

  dimension: royal_cushion {
    type: string
    sql: ${TABLE}."ROYAL_CUSHION" ;;
  }

  dimension: sheets_full_purple {
    type: string
    sql: ${TABLE}."SHEETS_FULL_PURPLE" ;;
  }

  dimension: sheets_full_sand {
    type: string
    sql: ${TABLE}."SHEETS_FULL_SAND" ;;
  }

  dimension: sheets_full_slate {
    type: string
    sql: ${TABLE}."SHEETS_FULL_SLATE" ;;
  }

  dimension: sheets_full_white {
    type: string
    sql: ${TABLE}."SHEETS_FULL_WHITE" ;;
  }

  dimension: sheets_king_purple {
    type: string
    sql: ${TABLE}."SHEETS_KING_PURPLE" ;;
  }

  dimension: sheets_king_sand {
    type: string
    sql: ${TABLE}."SHEETS_KING_SAND" ;;
  }

  dimension: sheets_king_slate {
    type: string
    sql: ${TABLE}."SHEETS_KING_SLATE" ;;
  }

  dimension: sheets_king_white {
    type: string
    sql: ${TABLE}."SHEETS_KING_WHITE" ;;
  }

  dimension: sheets_split_king_purple {
    type: string
    sql: ${TABLE}."SHEETS_SPLIT_KING_PURPLE" ;;
  }

  dimension: sheets_split_king_sand {
    type: string
    sql: ${TABLE}."SHEETS_SPLIT_KING_SAND" ;;
  }

  dimension: sheets_split_king_slate {
    type: string
    sql: ${TABLE}."SHEETS_SPLIT_KING_SLATE" ;;
  }

  dimension: sheets_split_king_white {
    type: string
    sql: ${TABLE}."SHEETS_SPLIT_KING_WHITE" ;;
  }

  dimension: sheets_twin_purple {
    type: string
    sql: ${TABLE}."SHEETS_TWIN_PURPLE" ;;
  }

  dimension: sheets_twin_sand {
    type: string
    sql: ${TABLE}."SHEETS_TWIN_SAND" ;;
  }

  dimension: sheets_twin_slate {
    type: string
    sql: ${TABLE}."SHEETS_TWIN_SLATE" ;;
  }

  dimension: sheets_twin_white {
    type: string
    sql: ${TABLE}."SHEETS_TWIN_WHITE" ;;
  }

  dimension: shopping_experience_satisfaction {
    type: string
    sql: ${TABLE}."SHOPPING_EXPERIENCE_SATISFACTION" ;;
  }

  dimension: simply_cushion {
    type: string
    sql: ${TABLE}."SIMPLY_CUSHION" ;;
  }

  dimension: sku_id {
    type: string
    sql: ${TABLE}."SKU_ID" ;;
  }

  dimension: sleep_mask {
    type: string
    sql: ${TABLE}."SLEEP_MASK" ;;
  }

  dimension_group: survey_recorded {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}."SURVEY_RECORDED_DATE" ;;
  }

  dimension: tranid {
    type: string
    sql: ${TABLE}."TRANID" ;;
  }

  dimension: ultimate_cushion {
    type: string
    sql: ${TABLE}."ULTIMATE_CUSHION" ;;
  }

  dimension: weighted_blanket {
    type: string
    sql: ${TABLE}."WEIGHTED_BLANKET" ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
