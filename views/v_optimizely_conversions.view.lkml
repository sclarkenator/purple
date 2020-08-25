view: v_optimizely_conversions {
  sql_table_name: "HEAP"."V_OPTIMIZELY_CONVERSIONS"
    ;;

  dimension: campaign_id {
    description: "Campaign ID with Optimizely. Source: optimizely.v_optimizely_conversions"
    type: string
    sql: ${TABLE}."CAMPAIGN_ID" ;;
  }

  dimension: experiment_id {
    description: "Experiment ID with Optimizely. Source: optimizely.v_optimizely_conversions"
    type: string
    sql: ${TABLE}."EXPERIMENT_ID" ;;
  }

  dimension: is_holdback {
    description: "Is Hold back?. Source: optimizely.v_optimizely_conversions"
    type: yesno
    sql: ${TABLE}."IS_HOLDBACK" ;;
  }

  dimension: session_id {
    description: "Session ID with Optimizely. Source: optimizely.v_optimizely_conversions"
    type: string
    sql: ${TABLE}."SESSION_ID" ;;
  }

  dimension: related_tranid {
    label: "Related ID"
    description: "Related ID. Source: optimizely.v_optimizely_conversions"
    type: string
    sql: ${TABLE}."SHOPIFYORDERID" ;;
  }

  dimension: uuid {
    description: "UU ID with Optimizely. Source: optimizely.v_optimizely_conversions"
    type: string
    sql: ${TABLE}."UUID" ;;
  }

  dimension: variation_id {
    description: "Variation ID with Optimizely. Source: optimizely.v_optimizely_conversions"
    type: string
    sql: ${TABLE}."VARIATION_ID" ;;
  }

  dimension: visitor_id {
    description: "Visitor ID with Optimizely. Source: optimizely.v_optimizely_conversions"
    type: string
    sql: ${TABLE}."VISITOR_ID" ;;
  }

  measure: count {
    hidden: yes
    type: count
    drill_fields: []
  }
}
