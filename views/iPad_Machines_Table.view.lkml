view: iPad_Machine_Table {
  sql_table_name:analytics_stage.ipad_stg.machine
      ;;


  dimension: machine_id {
    type: number
    primary_key: yes
    sql: ${TABLE}."MACHINE_ID" ;;
  }

  dimension: machine_name {
    type: string
    sql: ${TABLE}."MACHINE_NAME" ;;
  }

  dimension: daily_production_goal {
    type: number
    hidden: yes
    sql: ${TABLE}."DAILY_PRODUCTION_GOAL" ;;
  }

  dimension: daily_maximum_capacity {
    type: number
    hidden: yes
    sql: ${TABLE}."DAILY_MAXIMUM_CAPACITY" ;;
  }

  dimension: show_back_button {
    type: number
    hidden: yes
    sql: ${TABLE}."SHOW_BACK_BUTTON" ;;
  }

  dimension: netsuite_location_id {
    type: number
    hidden: yes
    sql: ${TABLE}."NETSUITE_LOCATION_ID" ;;
  }

  dimension: l2_l_machine_ids {
    type: string
    hidden: yes
    sql: ${TABLE}."L2L_MACHINE_IDS" ;;
  }


}
