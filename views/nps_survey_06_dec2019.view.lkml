view: nps_survey_06_dec2019 {
  sql_table_name: CSV_UPLOADS.NPS_SURVEY_06DEC2019 ;;

  dimension: back_cushion {
    type: string
    sql: ${TABLE}."Back Cushion" ;;
  }

  dimension: delivery_experience_satisfaction {
    type: string
    sql: ${TABLE}."Delivery Experience Satisfaction" ;;
  }

  dimension: distribution_channel {
    type: string
    sql: ${TABLE}."Distribution Channel" ;;
  }

  dimension: double_cushion {
    type: string
    sql: ${TABLE}."Double Cushion" ;;
  }

  dimension: duration_in_seconds {
    type: number
    sql: ${TABLE}."Duration (in seconds)" ;;
  }

  dimension_group: end {
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
    sql: ${TABLE}."End Date" ;;
  }

  dimension: external_data_reference {
    type: string
    sql: ${TABLE}."External Data Reference" ;;
  }

  dimension: finished {
    type: yesno
    sql: ${TABLE}."FINISHED" ;;
  }

  dimension: harmony_pillow {
    type: string
    sql: ${TABLE}."Harmony Pillow" ;;
  }

  dimension: harmony_pillow__tall {
    type: string
    sql: ${TABLE}."Harmony Pillow - Tall" ;;
  }

  dimension: hybrid_mattress__cal_king {
    type: string
    sql: ${TABLE}."Hybrid Mattress - Cal King" ;;
  }

  dimension: hybrid_mattress__full {
    type: string
    sql: ${TABLE}."Hybrid Mattress - Full" ;;
  }

  dimension: hybrid_mattress__king {
    type: string
    sql: ${TABLE}."Hybrid Mattress - King" ;;
  }

  dimension: hybrid_mattress__split_king {
    type: string
    sql: ${TABLE}."Hybrid Mattress - Split King" ;;
  }

  dimension: hybrid_mattress__split_king_2 {
    type: string
    sql: ${TABLE}."Hybrid Mattress - Split King 2" ;;
  }

  dimension: hybrid_mattress__twin_xl {
    type: string
    sql: ${TABLE}."Hybrid Mattress - Twin XL" ;;
  }

  dimension: hybrid_mattress__twin_xl_2 {
    type: string
    sql: ${TABLE}."Hybrid Mattress - Twin XL 2" ;;
  }

  dimension: hybrid_premier_3__cal_king {
    type: string
    sql: ${TABLE}."Hybrid Premier 3 - Cal King" ;;
  }

  dimension: hybrid_premier_3__cal_king_2 {
    type: string
    sql: ${TABLE}."Hybrid Premier 3 - Cal King 2" ;;
  }

  dimension: hybrid_premier_3__queen {
    type: string
    sql: ${TABLE}."Hybrid Premier 3 - Queen" ;;
  }

  dimension: hybrid_premier_3__queen_2 {
    type: string
    sql: ${TABLE}."Hybrid Premier 3 - Queen 2" ;;
  }

  dimension: hybrid_premier_3__split_king {
    type: string
    sql: ${TABLE}."Hybrid Premier 3 - Split King" ;;
  }

  dimension: hybrid_premier_3__twin_xl {
    type: string
    sql: ${TABLE}."Hybrid Premier 3 - Twin XL" ;;
  }

  dimension: hybrid_premier_3__twin_xl_2 {
    type: string
    sql: ${TABLE}."Hybrid Premier 3 - Twin XL 2" ;;
  }

  dimension: hybrid_premier_3_mattress__full {
    type: string
    sql: ${TABLE}."Hybrid Premier 3 Mattress - Full" ;;
  }

  dimension: hybrid_premier_3_mattress__full_2 {
    type: string
    sql: ${TABLE}."Hybrid Premier 3 Mattress - Full 2" ;;
  }

  dimension: hybrid_premier_3_mattress__king {
    type: string
    sql: ${TABLE}."Hybrid Premier 3 Mattress - King" ;;
  }

  dimension: hybrid_premier_3_mattress__king_2 {
    type: string
    sql: ${TABLE}."Hybrid Premier 3 Mattress - King 2" ;;
  }

  dimension: hybrid_premier_4__cal_king {
    type: string
    sql: ${TABLE}."Hybrid Premier 4 - Cal King" ;;
  }

  dimension: hybrid_premier_4__cal_king_2 {
    type: string
    sql: ${TABLE}."Hybrid Premier 4 - Cal King 2" ;;
  }

  dimension: hybrid_premier_4__queen {
    type: string
    sql: ${TABLE}."Hybrid Premier 4 - Queen" ;;
  }

  dimension: hybrid_premier_4__queen_2 {
    type: string
    sql: ${TABLE}."Hybrid Premier 4 - Queen 2" ;;
  }

  dimension: hybrid_premier_4__split_king {
    type: string
    sql: ${TABLE}."Hybrid Premier 4 - Split King" ;;
  }

  dimension: hybrid_premier_4__split_king_2 {
    type: string
    sql: ${TABLE}."Hybrid Premier 4 - Split King 2" ;;
  }

  dimension: hybrid_premier_4__twin_xl {
    type: string
    sql: ${TABLE}."Hybrid Premier 4 - Twin XL" ;;
  }

  dimension: hybrid_premier_4__twin_xl_2 {
    type: string
    sql: ${TABLE}."Hybrid Premier 4 - Twin XL 2" ;;
  }

  dimension: hybrid_premier_4_mattress__full {
    type: string
    sql: ${TABLE}."Hybrid Premier 4 Mattress - Full" ;;
  }

  dimension: hybrid_premier_4_mattress__full_2 {
    type: string
    sql: ${TABLE}."Hybrid Premier 4 Mattress - Full 2" ;;
  }

  dimension: hybrid_premier_4_mattress__king {
    type: string
    sql: ${TABLE}."Hybrid Premier 4 Mattress - King" ;;
  }

  dimension: hybrid_premier_4_mattress__king_2 {
    type: string
    sql: ${TABLE}."Hybrid Premier 4 Mattress - King 2" ;;
  }

  dimension: ip_address {
    type: string
    sql: ${TABLE}."IP Address" ;;
  }

  dimension: location_latitude {
    type: string
    sql: ${TABLE}."Location Latitude" ;;
  }

  dimension: location_longitude {
    type: string
    sql: ${TABLE}."Location Longitude" ;;
  }

  dimension: mattress_protector__full_xl {
    type: string
    sql: ${TABLE}."Mattress Protector - Full XL" ;;
  }

  dimension: mattress_protector__split_king_ {
    type: string
    sql: ${TABLE}."Mattress Protector - Split King " ;;
  }

  dimension: mattress_protector__split_king_2 {
    type: string
    sql: ${TABLE}."Mattress Protector - Split King 2" ;;
  }

  dimension: nps_comment {
    type: string
    sql: ${TABLE}."NPS Comment" ;;
  }

  dimension: nps_question {
    type: string
    sql: ${TABLE}."NPS Question" ;;
  }

  measure: avg_nps_question {
    type: average
    sql: ${TABLE}."NPS Question" ;;
  }

  dimension: nps_question_group {
    type: string
    sql: ${TABLE}."NPS Question Group" ;;
  }

  dimension: platform_base__queen {
    type: string
    sql: ${TABLE}."Platform Base - Queen" ;;
  }

  dimension: platform_base__twin {
    type: string
    sql: ${TABLE}."Platform Base - Twin" ;;
  }

  dimension: platform_base__twin_xl {
    type: string
    sql: ${TABLE}."Platform Base - Twin XL" ;;
  }

  dimension: portablecushion {
    type: string
    sql: ${TABLE}."Portable Cushion" ;;
  }

  dimension: power_base__queen {
    type: string
    sql: ${TABLE}."PowerBase - Queen" ;;
  }

  dimension: power_base__split_king {
    type: string
    sql: ${TABLE}."PowerBase - Split King" ;;
  }

  dimension: power_base__twin_xl {
    type: string
    sql: ${TABLE}."PowerBase - Twin XL" ;;
  }

  dimension: progress {
    type: number
    sql: ${TABLE}."PROGRESS" ;;
  }

  dimension: purple_mattress__cal_king {
    type: string
    sql: ${TABLE}."Purple Mattress - Cal King" ;;
  }

  dimension: purple_mattress__full {
    type: string
    sql: ${TABLE}."Purple Mattress - Full" ;;
  }

  dimension: purple_mattress__king {
    type: string
    sql: ${TABLE}."Purple Mattress - King" ;;
  }

  dimension: purple_mattress__queen {
    type: string
    sql: ${TABLE}."Purple Mattress - Queen" ;;
  }

  dimension: purple_mattress__split_king {
    type: string
    sql: ${TABLE}."Purple Mattress - Split King" ;;
  }

  dimension: purple_mattress__twin {
    type: string
    sql: ${TABLE}."Purple Mattress - Twin" ;;
  }

  dimension: purple_mattress__twin_xl {
    type: string
    sql: ${TABLE}."Purple Mattress - Twin XL" ;;
  }

  dimension: purple_pillow {
    type: string
    sql: ${TABLE}."Purple Pillow" ;;
  }

  dimension: purple_plush_pillow {
    type: string
    sql: ${TABLE}."Purple Plush Pillow" ;;
  }

  dimension: purple_plush_pillow__king {
    type: string
    sql: ${TABLE}."Purple Plush Pillow - King" ;;
  }

  dimension: recipient_email {
    type: string
    sql: ${TABLE}."Recipient Email" ;;
  }

  dimension: recipient_first_name {
    type: string
    sql: ${TABLE}."Recipient First Name" ;;
  }

  dimension: recipient_last_name {
    type: string
    sql: ${TABLE}."Recipient Last Name" ;;
  }

  dimension_group: recorded {
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
    sql: ${TABLE}."Recorded Date" ;;
  }

  dimension: response_id {
    type: string
    sql: ${TABLE}."Response ID" ;;
  }

  dimension: response_type {
    type: string
    sql: ${TABLE}."Response Type" ;;
  }

  dimension: royalcushion {
    type: string
    sql: ${TABLE}."Royal Cushion" ;;
  }

  dimension: sheets__full_purple {
    type: string
    sql: ${TABLE}."Sheets - Full (Purple)" ;;
  }

  dimension: sheets__full_sand {
    type: string
    sql: ${TABLE}."Sheets - Full (Sand)" ;;
  }

  dimension: sheets__full_slate {
    type: string
    sql: ${TABLE}."Sheets - Full (Slate)" ;;
  }

  dimension: sheets__full_white {
    type: string
    sql: ${TABLE}."Sheets - Full (White)" ;;
  }

  dimension: sheets__king_purple {
    type: string
    sql: ${TABLE}."Sheets - King (Purple)" ;;
  }

  dimension: sheets__king_sand {
    type: string
    sql: ${TABLE}."Sheets - King (Sand)" ;;
  }

  dimension: sheets__king_slate {
    type: string
    sql: ${TABLE}."Sheets - King (Slate)" ;;
  }

  dimension: sheets__king_white {
    type: string
    sql: ${TABLE}."Sheets - King (White)" ;;
  }

  dimension: sheets__split_king_purple {
    type: string
    sql: ${TABLE}."Sheets - Split King (Purple)" ;;
  }

  dimension: sheets__split_king_sand {
    type: string
    sql: ${TABLE}."Sheets - Split King (Sand)" ;;
  }

  dimension: sheets__split_king_slate {
    type: string
    sql: ${TABLE}."Sheets - Split King (Slate)" ;;
  }

  dimension: sheets__split_king_white {
    type: string
    sql: ${TABLE}."Sheets - Split King (White)" ;;
  }

  dimension: sheets__twin_purple {
    type: string
    sql: ${TABLE}."Sheets - Twin (Purple)" ;;
  }

  dimension: sheets__twin_sand {
    type: string
    sql: ${TABLE}."Sheets - Twin (Sand)" ;;
  }

  dimension: sheets__twin_slate {
    type: string
    sql: ${TABLE}."Sheets - Twin (Slate)" ;;
  }

  dimension: sheets__twin_white {
    type: string
    sql: ${TABLE}."Sheets - Twin (White)" ;;
  }

  dimension: shopping_experience_satisfaction {
    type: string
    sql: ${TABLE}."Shopping Experience Satisfaction" ;;
  }

  dimension: simplycushion {
    type: string
    sql: ${TABLE}."Simply Cushion" ;;
  }

  dimension: sleep_mask {
    type: string
    sql: ${TABLE}."Sleep Mask" ;;
  }

  dimension_group: start {
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
    sql: ${TABLE}."Start Date" ;;
  }

  dimension: ultimatecushion {
    type: string
    sql: ${TABLE}."Ultimate Cushion" ;;
  }

  dimension: user_language {
    type: string
    sql: ${TABLE}."User Language" ;;
  }

  dimension: weighted_blanket {
    type: string
    sql: ${TABLE}."Weighted Blanket" ;;
  }

  measure: count {
    type: count
    drill_fields: [recipient_last_name, recipient_first_name]
  }
}
