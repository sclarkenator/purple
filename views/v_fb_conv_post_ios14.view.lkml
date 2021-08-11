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

  measure: spend {
    type: sum
    value_format: "$#,##0.00"
    sql: ${TABLE}.SPEND ;;
  }

  measure: impressions {
    type: sum
    value_format: "$#,##0.00"
    sql: ${TABLE}.impressions ;;
  }

  measure: clicks {
    type: sum
    value_format: "$#,##0.00"
    sql: ${TABLE}.clicks ;;
  }

  measure: CPM {
    label: "CPM"
    description: "CPM = (Spend/Impressions)*1000"
    type: number
    value_format: "$#,##0.00"
    sql: 1000 * DIV0(${spend},${impressions}) ;;
  }

  measure: CPC {
    label: "CPC"
    description: "Cost Per Click = Spend/Clicks"
    value_format: "$#,##0.00"
    type: number
    sql: DIV0(${spend},${clicks}) ;;
  }

 measure: purchase_conversion_value_7_dc {
    type: sum
    value_format: "$0"
    sql: ${TABLE}."PURCHASE_CONVERSION_VALUE_7DC" ;;
  }

  measure: purhcase_conversion_value_1_d_view {
    type: sum
    value_format: "$0"
    sql: ${TABLE}."PURHCASE_CONVERSION_VALUE_1_D_VIEW" ;;
  }

  measure: count {
    type: count
    drill_fields: [campaign_name, adset_name, ad_name]
  }
}
