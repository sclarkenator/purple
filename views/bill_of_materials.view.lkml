view: bill_of_materials {
  sql_table_name: "PRODUCTION"."BUILD_OF_MATERIALS"
    ;;
  dimension: child_id {
    type: number
    sql: ${TABLE}."CHILD_ID" ;;
  }

  dimension: component_id {
    type: number
    sql: ${TABLE}."COMPONENT_ID" ;;
  }


  dimension: parent_id {
    type: number
    sql: ${TABLE}."PARENT_ID" ;;
  }

  dimension: quantity {
    type: number
    sql: ${TABLE}."QUANTITY" ;;
  }

  dimension: pk {
    type: string
    primary_key: yes
    sql: ${component_id} || ${parent_id} || ${child_id} ;;
  }

  measure: total_quantity {
    type: sum
    sql: ${TABLE}."QUANTITY" ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}