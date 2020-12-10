view: optimizely_experiment {
  sql_table_name: analytics.optimizely.experiment
    ;;

  dimension: experiment_id {
    primary_key: yes
    hidden: yes
    view_label: "Optimizely"
    description: "Source: optimizely.experiment"
    type: number
    sql: ${TABLE}."EXPERIMENT_ID" ;;
  }

  dimension: experiment_name {
    view_label: "Optimizely"
    description: "Source: optimizely.experiment"
    type: string
    sql: ${TABLE}."EXPERIMENT_NAME" ;;
  }

}
