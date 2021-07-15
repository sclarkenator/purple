view: v_fb_conv_post_ios14 {
  sql_table_name: "MARKETING"."V_FB_CONV_POST_IOS14"
    ;;

  dimension: ad_id {
    type: string
    sql: ${TABLE}."AD_ID" ;;
  }

  dimension: ad_name {
    type: string
    sql: ${TABLE}."AD_NAME" ;;
  }

  dimension: adset_id {
    type: number
    sql: ${TABLE}."ADSET_ID" ;;
  }

  dimension: adset_name {
    type: string
    sql: ${TABLE}."ADSET_NAME" ;;
  }

  dimension: campaign_id {
    type: number
    sql: ${TABLE}."CAMPAIGN_ID" ;;
  }

  dimension: campaign_name {
    type: string
    sql: ${TABLE}."CAMPAIGN_NAME" ;;
  }

  dimension_group: date {
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
    sql: ${TABLE}."DATE" ;;
  }

  dimension: purchase_conversion_value_7_dc {
    type: number
    sql: ${TABLE}."PURCHASE_CONVERSION_VALUE_7DC" ;;
  }

  dimension: purhcase_conversion_value_1_d_view {
    type: number
    sql: ${TABLE}."PURHCASE_CONVERSION_VALUE_1_D_VIEW" ;;
  }

  measure: count {
    type: count
    drill_fields: [campaign_name, adset_name, ad_name]
  }
}
