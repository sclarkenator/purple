view: bom_demand_matrix {
  sql_table_name: production.bom_demand_matrix ;;

  dimension: key {
    primary_key:yes
    hidden: yes
    type: number
    sql: ${TABLE}.component_id||'-'||${TABLE}.item_id ;;
  }

  dimension: component_id {
    #hidden:  yes
    type: number
    sql: ${TABLE}.component_id ;;
  }

  dimension: item_id {
    hidden:  yes
    type: number
    sql: ${TABLE}.item_id ;;
  }

  dimension: INGREDIENT {
    type: string
    sql: ${TABLE}.INGREDIENT ;;
  }

  dimension: ROW_NUM_WEST {
    type: number
    sql: ${TABLE}.ROW_NUM_WEST ;;
  }

  dimension: ROW_NUM_ALPINE {
    type: number
    sql: ${TABLE}.ROW_NUM_ALPINE ;;
  }



  measure: quantity {
    label: "quantity_needed"
    type: max
    sql: ${TABLE}.quantity ;;
  }

  measure: AVAILABLE_WEST {
    type: min
    sql: ${TABLE}.AVAILABLE_WEST ;;
  }

  measure: AVAILABLE_ALPINE {
    type: min
    sql: ${TABLE}.AVAILABLE_ALPINE ;;
  }

  measure: UNITS_WEST {
    type: min
    sql: ${TABLE}.UNITS_WEST ;;
  }

  measure: UNITS_ALPINE {
    type: min
    sql: ${TABLE}.UNITS_ALPINE ;;
  }

}
