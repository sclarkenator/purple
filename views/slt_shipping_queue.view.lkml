# The name of this view in Looker is "Slt Shipping Queue"
view: slt_shipping_queue {
  # The sql_table_name parameter indicates the underlying database table
  # to be used for all fields in this view.
  sql_table_name: "PRODUCTION"."SLT_SHIPPING_QUEUE"
    ;;
  # No primary key is defined for this view. In order to join this view in an Explore,
  # define primary_key: yes on a dimension that has no repeated values.

  # Here's what a typical dimension looks like in LookML.
  # A dimension is a groupable field that can be used to filter query results.
  # This dimension will be called "Customer" in Explore.

  dimension: customer {
    group_label: "Fulfillment Issues"
    type: number
    sql: ${TABLE}."CUSTOMER" ;;
  }

  # A measure is a field that uses a SQL aggregate function. Here are defined sum and average
  # measures for this dimension, but you can also add measures of many different aggregates.
  # Click on the type parameter to see all the options in the Quick Help panel on the right.

  measure: total_customer {
    label: "Customer"
    group_label: "Fulfillment Issue Totals"
    type: sum
    value_format: "#,##0"
    sql: ${customer} ;;
  }

  measure: average_customer {
    label: "Customer"
    group_label: "Fulfillment Issue Avg."
    type: average
    value_format: "#,##0.0"
    sql: ${customer} ;;
  }

  # Dates and timestamps can be represented in Looker using a dimension group of type: time.
  # Looker converts dates and timestamps to the specified timeframes within the dimension group.

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

  dimension: fulfillment {
    group_label: "Fulfillment Issues"
    type: number
    sql: ${TABLE}."FULFILLMENT" ;;
  }

  measure: total_fulfillment {
    label: "Fulfillment"
    group_label: "Fulfillment Issue Totals"
    type: sum
    value_format: "#,##0"
    sql: ${fulfillment} ;;
  }

  measure: average_fulfillment {
    label: "Fulfillment"
    group_label: "Fulfillment Issue Avg."
    type: average
    value_format: "#,##0.0"
    sql: ${fulfillment} ;;
  }

  dimension: highjump {
    group_label: "Fulfillment Issues"
    type: number
    sql: ${TABLE}."HIGHJUMP" ;;
  }

  measure: total_highjump {
    label: "HighJump"
    group_label: "Fulfillment Issue Totals"
    type: sum
    value_format: "#,##0"
    sql: ${highjump} ;;
  }

  measure: average_highjump {
    label: "HighJump"
    group_label: "Fulfillment Issue Avg."
    type: average
    value_format: "#,##0.0"
    sql: ${highjump} ;;
  }

  dimension: inventory {
    group_label: "Fulfillment Issues"
    type: number
    sql: ${TABLE}."INVENTORY" ;;
  }

  measure: total_inventory {
    label: "Inventory"
    group_label: "Fulfillment Issue Totals"
    type: sum
    value_format: "#,##0"
    sql: ${inventory} ;;
  }

  measure: average_inventory {
    label: "Inventory"
    group_label: "Fulfillment Issue Avg."
    type: average
    value_format: "#,##0.0"
    sql: ${inventory} ;;
  }

  dimension: percent_shipped_dim {
    group_label: "Queue Performance"
    type: number
    sql: ${TABLE}."PERCENT_SHIPPED" ;;
  }

  measure: percent_shipped  {
    group_label: "Queue Performance"
    type: number
    value_format: "0.0%"
    sql: div0(${shipped},${planned}) ;;
  }

  dimension: planned_dim {
    group_label: "Queue Performance"
    type: number
    sql: ${TABLE}."PLANNED" ;;
  }

  measure: planned {
    group_label: "Queue Performance"
    type: sum
    value_format: "#,##0"
    sql: ${planned_dim} ;;
  }

  measure: average_planned {
    group_label: "Queue Performance"
    type: average
    value_format: "#,##0.0"
    sql: ${planned_dim} ;;
  }

  dimension: shipped_dim {
    group_label: "Queue Performance"
    type: number
    sql: ${TABLE}."SHIPPED" ;;
  }
  measure: shipped {
    group_label: "Queue Performance"
    type: sum
    value_format: "#,##0"
    sql: ${shipped_dim} ;;
  }

  measure: average_shipped {
    group_label: "Queue Performance"
    type: average
    value_format: "#,##0.0"
    sql: ${shipped} ;;
  }

  dimension: site {
    type: string
    sql: ${TABLE}."SITE" ;;
  }

  dimension: transportation {
    group_label: "Fulfillment Issues"
    type: number
    sql: ${TABLE}."TRANSPORTATION" ;;
  }
  measure: total_transportation {
    label: "Transportation"
    group_label: "Fulfillment Issue Totals"
    type: sum
    value_format: "#,##0"
    sql: ${transportation} ;;
  }

  measure: average_transportation {
    label: "Transportation"
    group_label: "Fulfillment Issue Avg."
    type: average
    value_format: "#,##0.0"
    sql: ${transportation} ;;
  }

  measure: count {
    hidden: yes
    type: count
    drill_fields: []
  }
}
