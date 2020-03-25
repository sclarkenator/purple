#-------------------------------------------------------------------
# Owner - Tim Schultz
# Pulling Build of Materials (BOM) demand matrix from netsuite
#   created by Hyrum for visualization
#-------------------------------------------------------------------

view: bom_demand_matrix {
  sql_table_name: production.bom_demand_matrix ;;

  dimension: key {
    primary_key:yes
    hidden: yes
    type: number
    sql: ${TABLE}.component_id||'-'||${TABLE}.item_id ;;  }

  dimension: component_id {
    hidden: no
    label: "Component ID"
    description: "Internal ID linking to the item of the product being made"
    type: number
    sql: ${TABLE}.component_id ;;  }

  dimension: item_id {
    hidden:  yes
    type: number
    sql: ${TABLE}.item_id ;;  }

  dimension: INGREDIENT {
    label: "Sub-Component Name"
    description: "Name of the items that are part of a product made"
    type: string
    sql: ${TABLE}.INGREDIENT ;;  }

  dimension: base_unit {
    label: "Base Unit"
    description: "Unit type for measuring (EAS,Oz,Lbs,Ft,Etc)"
    type: string
    sql: ${TABLE}.base_unit ;;  }

  dimension: ROW_NUM_WEST {
    label: "Row Number West"
    description: "Ordering the components that go into a product by the least available amount at West"
    type: number
    sql: ${TABLE}.ROW_NUM_WEST ;;  }

  dimension: ROW_NUM_ALPINE {
    label: "Row Number Apline"
    description: "Ordering the components that go into a product by the least available amount at Apline"
    type: number
    sql: ${TABLE}.ROW_NUM_ALPINE ;;  }

  measure: quantity {
    label: "Quantity Needed"
    description: "Count of a specifc component needed to create a product"
    type: max
    sql: ${TABLE}.quantity ;;  }

  measure: AVAILABLE_WEST {
    label: "Min Availble West"
    description: "Minimun count of a component available at West"
    type: min
    sql: ${TABLE}.AVAILABLE_WEST ;;  }

  measure: AVAILABLE_ALPINE {
    label: "Min Availble Apline"
    description: "Minimun count of a component available at Alpine"
    type: min
    sql: ${TABLE}.AVAILABLE_ALPINE ;;  }

  measure: UNITS_WEST {
    label: "Min Units West"
    description: "Available/Quantity Needed.  Minimium units we can create in West."
    type: min
    sql: ${TABLE}.UNITS_WEST ;;  }

  measure: UNITS_ALPINE {
    label: "Min Units Apline"
    description: "Available/Quantity Needed.  Minimium units we can create in Apline."
    type: min
    sql: ${TABLE}.UNITS_ALPINE ;;  }

}
