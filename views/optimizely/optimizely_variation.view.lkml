view: optimizely_variation {
  sql_table_name: analytics.optimizely.variation
    ;;

  dimension: pk {
    primary_key: yes
    view_label: "Optimizely"
    description: "Source: optimizely.variation"
    type: string
    sql: ${experiment_id}||${variation_id} ;;
  }

  dimension: variation_id {
    hidden: yes
    view_label: "Optimizely"
    description: "Source: optimizely.variation"
    type: number
    sql: ${TABLE}."VARIATION_ID" ;;
  }

  dimension: experiment_id {
    hidden: yes
    view_label: "Optimizely"
    description: "Source: optimizely.variation"
    type: number
    sql: ${TABLE}."EXPERIMENT_ID" ;;
  }

  dimension: variation_name {
    view_label: "Optimizely"
    description: "Source: optimizely.variation"
    type: string
    sql: ${TABLE}."VARIATION_NAME" ;;
  }

}
