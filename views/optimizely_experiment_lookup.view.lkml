view: optimizely_experiment_lookup {
  derived_table: {
    sql: select distinct va.event_features_shopify_order_id shopify_order_id
        , e.name experiment_name
        , v.name variation_name
      from optimizely_stage.optimizely.visitor_action va
      join optimizely_stage.optimizely.experiment_history e on e.id::string = va.experiment_id::string
      join optimizely_stage.optimizely.experiment_variation_history v on v.id::string = va.variation_id::string
      where va.event_features_shopify_order_id is not null
       ;;
  }

  dimension: pk {
    primary_key: yes
    hidden: yes
    sql: ${TABLE}."SHOPIFY_ORDER_ID"||${TABLE}."EXPERIMENT_NAME"||${TABLE}."VARIATION_NAME" ;;
  }

  measure: count {
    type: count
    hidden: yes
    drill_fields: [detail*]
  }

  dimension: shopify_order_id {
    type: string
    hidden: yes
    sql: ${TABLE}."SHOPIFY_ORDER_ID" ;;
  }

  dimension: experiment_name {
    view_label: "Sales Order"
    group_label: " Advanced"
    label: "Optimzely Experiment Name"
    description: "Name of the experiment(s) the order was a part of in Optimizely. Note that an order can be a part of multiple experiments."
    type: string
    sql: ${TABLE}."EXPERIMENT_NAME" ;;
  }

  dimension: variation_name {
    view_label: "Sales Order"
    group_label: " Advanced"
    label: "Optimizely Variation Name"
    description: "For orders that were part of a test this is the name of the test condition (variant) the purchase was part of. Note that if an order was included in two tests there will be a different variant for each."
    type: string
    sql: ${TABLE}."VARIATION_NAME" ;;
  }

  set: detail {
    fields: [shopify_order_id, experiment_name, variation_name]
  }
}
