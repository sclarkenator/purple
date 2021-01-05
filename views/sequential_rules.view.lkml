view: sequential_rules {
  sql_table_name: "DS"."SEQUENTIAL_RULES"
    ;;

  dimension: antecedent {
    type: string
    sql: ${TABLE}."ANTECEDENT" ;;
  }

  dimension: confidence {
    type: number
    sql: ${TABLE}."CONFIDENCE" ;;
  }

  measure: confidence_max {
    type: max
    sql: ${TABLE}.confidence ;;
  }

  measure: confidence_min {
    type: min
    sql: ${TABLE}.confidence ;;
  }

  dimension: consequent {
    type: string
    sql: ${TABLE}."CONSEQUENT" ;;
  }

  dimension: days_diff {
    type: string
    sql: ${TABLE}."DAYS_DIFF" ;;
  }

  dimension: instances {
    type: number
    sql: ${TABLE}."INSTANCES" ;;
  }

  measure: instances_max {
    type: max
    sql: ${TABLE}."INSTANCES" ;;
  }

  measure: instances_min {
    type: min
    sql: ${TABLE}."INSTANCES" ;;
  }

  dimension: rule_id {
    type: number
    sql: ${TABLE}."RULE_ID" ;;
  }

  dimension: support {
    type: number
    sql: ${TABLE}."SUPPORT" ;;
  }

  measure: support_max {
    type: max
    sql: ${TABLE}."SUPPORT" ;;
  }

  measure: support_min {
    type: min
    sql: ${TABLE}."SUPPORT" ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
