view: order_items_base {
  derived_table: {
    #### TO DO: Create a transaction-item-level table with the following columns:
    # -Transaction ID
    # -Transaction timestamp
    # -Base-level item ID and name
    # -ID and name column for each of your hierarchy levels
    # -[optional] Customer ID, keep as null otherwise
    # -Transaction gross sale amount
    # -Transaction margin amount
    #### If this info is in different tables that you're joining together (e.g. a trx table to a product hierarchy, as in the example below), you may want to persist the joined table as a PDT if feasible
    #### Make sure to not change the "AS [...]" in the query below, as these column names are used later on
    sql: SELECT
      so.order_id AS transaction_id
      ,so.system,so.created AS order_created_time
      ,i.sku_id as SKU_id
      ,i.description AS SKU_name
      ,nsi.item_category_id AS category_id
      ,i.category AS category_name
      ,nsi.item_subcategory_id AS line_id
      ,i.line AS line_name
      --,i.brand AS brand_id
      --,i.brand AS brand_name
      --,i.department AS department_id
      --,i.brand AS department_name
      ,so.customer_id AS user_id
      ,sol.pre_discount_amt/ordered_qty AS sale_amt
--      ,sol.sale_price-intermediate_table.cost AS margin_amt
      , 10 AS margin_amt
      FROM sales.sales_order so
      JOIN sales.sales_order_line as sol on so.order_id = sol.order_id and so.system = sol.system
      --JOIN PUBLIC.inventory_items as intermediate_table
        --ON order_items.inventory_item_id = intermediate_table.id
      JOIN sales.item as i
        ON sol.item_id = i.item_id
      JOIN analytics_stage.ns.items nsi on i.item_id = nsi.item_id
      WHERE sol.ordered_qty <> 0;;
      #### TO DO: Uncomment this line if you'd like to persist this table for faster query-time performance
#       datagroup_trigger: daily
    }

    #### TO DO: Edit the values of this parameter according to the hierarchy levels used in the base table above
    parameter: product_level {
      view_label: "Item Affinity"
      type: unquoted
      allowed_value: {
        label: "SKU"
        value: "SKU"
      }
      allowed_value: {
        label: "Category"
        value: "category"
      }
      allowed_value: {
        label: "Line"
        value: "line"
      }
    }
  }


  view: order_items {
    derived_table: {
      sql: SELECT
              CONCAT(transaction_id,'_',{% parameter order_items_base.product_level %}_id) AS id
              , transaction_id AS order_id
              , {% parameter order_items_base.product_level %}_id as product_id
              , {% parameter order_items_base.product_level %}_name AS product
              , user_id as user_id
              , MIN(order_created_time) AS created_at
              , SUM(sale_amt) AS sale_price
              , SUM(margin_amt) AS margin
            FROM ${order_items_base.SQL_TABLE_NAME}
            WHERE 1=1
            ---- TO DO: Replace with any types of items you'd like to remove
            AND UPPER({% parameter order_items_base.product_level %}_name) <> 'UNKNOWN'
            AND {% condition order_purchase_affinity.affinity_timeframe %} order_created_time {% endcondition %}
            ---- TO DO: Replace with filters you want to be able to control the analysis on (e.g. store number, name)
            AND {% condition order_purchase_affinity.channel %} channel {% endcondition %}
            GROUP BY 1,2,3,4,5;;
    }
  }

  view: orders {
    derived_table: {
      sql: select
              oi.order_id as id
              , MIN(oi.created_at) as created_at
              ,COUNT(distinct product) as distinct_products
              FROM ${order_items.SQL_TABLE_NAME} oi
              GROUP BY oi.order_id ;;
    }
  }

  view: order_product {
    derived_table: {
      sql:
      SELECT oi.id as order_item_id
      , o.id as order_id
      , o.created_at
      , oi.product as product
      FROM ${order_items.SQL_TABLE_NAME} oi
      JOIN ${orders.SQL_TABLE_NAME} o ON o.id = oi.order_id
      GROUP BY oi.id,o.id, o.created_at, oi.product
       ;;
    }
  }

  view: order_metrics {
    derived_table: {
      sql: SELECT oi.id as order_item_id
          , SUM(oi.sale_price) over (partition by oi.order_id) as basket_sales
          , SUM(oi.margin) over (partition by oi.order_id) as basket_margin
            FROM ${order_items.SQL_TABLE_NAME} oi;;
    }
  }

  view: total_order_product {
    derived_table: {
      sql:
      SELECT oi.product as product
      , count(distinct o.id) as product_order_count    -- count of orders with product, not total order items
      , SUM(oi.sale_price) as product_sales
      , SUM(oi.margin) as product_margin
      , SUM(om.basket_sales) as basket_sales
      , SUM(om.basket_margin) as basket_margin
      , COUNT(distinct (CASE WHEN o.distinct_products=1 THEN o.id ELSE NULL END)) as product_count_purchased_alone
      , COUNT(distinct (CASE WHEN oi.user_id IS NOT NULL THEN o.id ELSE NULL END)) as product_count_purchased_by_loyalty_customer
      FROM ${order_items.SQL_TABLE_NAME} oi
      JOIN ${order_metrics.SQL_TABLE_NAME} om ON oi.id = om.order_item_id
      JOIN ${orders.SQL_TABLE_NAME} o ON o.id = oi.order_id
      WHERE {% condition order_purchase_affinity.affinity_timeframe %} o.created_at {% endcondition %}
      GROUP BY oi.product
       ;;
    }
  }

  view: product_loyal_users {
    derived_table: {
      sql: SELECT
        oi.user_id
      from ${order_items.SQL_TABLE_NAME} oi
      WHERE {% condition order_purchase_affinity.affinity_timeframe %} oi.created_at {% endcondition %}
      GROUP BY oi.user_id
      HAVING COUNT(distinct oi.product) =1;;
    }
  }

  view: orders_by_product_loyal_users {
    derived_table: {
      sql:
       SELECT
        oi.product as product,
        COUNT (distinct oi.order_id) as orders_by_loyal_customers
      FROM ${order_items.SQL_TABLE_NAME} oi
      INNER JOIN ${product_loyal_users.SQL_TABLE_NAME} plu on oi.user_id = plu.user_id
      WHERE {% condition order_purchase_affinity.affinity_timeframe %} oi.created_at {% endcondition %}
      GROUP BY oi.product
       ;;
    }
  }

  view: total_orders {
    derived_table: {
      sql:

      SELECT count(*) as count
      FROM ${orders.SQL_TABLE_NAME}
      WHERE {% condition order_purchase_affinity.affinity_timeframe %} created_at {% endcondition %}
       ;;
    }

    dimension: count {
      type: number
      sql: ${TABLE}.count ;;
      view_label: "Item Affinity"
      label: "Total Order Count"
    }
  }

  view: order_purchase_affinity {
    derived_table: {
      sql: SELECT product_a
              , product_b
              , joint_order_count
              , top1.product_order_count as product_a_order_count   -- total number of orders with product A in them
              , top2.product_order_count as product_b_order_count   -- total number of orders with product B in them
              , top1.product_count_purchased_alone as product_a_count_purchased_alone
              , top2.product_count_purchased_alone as product_b_count_purchased_alone
              , top1.product_count_purchased_by_loyalty_customer as product_a_count_purchased_by_loyalty_customer
              , top2.product_count_purchased_by_loyalty_customer as product_b_count_purchased_by_loyalty_customer
              , IFNULL(loy1.orders_by_loyal_customers,0) as product_a_count_orders_by_exclusive_customers
              , IFNULL(loy2.orders_by_loyal_customers,0) as product_b_count_orders_by_exclusive_customers
              , top1.product_sales as product_a_product_sales
              , top2.product_sales as product_b_product_sales
              , top1.product_margin as product_a_product_margin
              , top2.product_margin as product_b_product_margin
              , top1.basket_sales as product_a_basket_sales
              , top2.basket_sales as product_b_basket_sales
              , top1.basket_margin as product_a_basket_margin
              , top2.basket_margin as product_b_basket_margin
              FROM (
                SELECT op1.product as product_a
                , op2.product as product_b
                , count(*) as joint_order_count
                FROM ${order_product.SQL_TABLE_NAME} as op1
                JOIN ${order_product.SQL_TABLE_NAME} op2
                ON op1.order_id = op2.order_id
                AND op1.order_item_id <> op2.order_item_id            -- ensures we don't match on the same order items in the same order, which would corrupt our frequency metrics
                WHERE {% condition affinity_timeframe %} op1.created_at {% endcondition %}
                AND {% condition affinity_timeframe %} op2.created_at {% endcondition %}
                GROUP BY product_a, product_b
              ) as prop
              JOIN ${total_order_product.SQL_TABLE_NAME} as top1 ON prop.product_a = top1.product
              JOIN ${total_order_product.SQL_TABLE_NAME} as top2 ON prop.product_b = top2.product
              LEFT JOIN ${orders_by_product_loyal_users.SQL_TABLE_NAME} as loy1 ON prop.product_a = loy1.product
              LEFT JOIN ${orders_by_product_loyal_users.SQL_TABLE_NAME} as loy2 ON prop.product_a = loy2.product
               ;;
    }

    ##### Filters #####

    filter: affinity_timeframe {
      type: date
    }

    #### TO DO: [optional] add any store or other level filters here, or remove this one

    filter: channel {
      type: string
      suggest_explore: sales_order_line
      suggest_dimension: sales_order.channel
    }

    ##### Dimensions #####

    dimension: product_a {
      type: string
      sql: ${TABLE}.product_a ;;
      link: {
        label: "Focus on {{rendered_value}}"
        #### TO DO: Replace "/3" with id of the [...] dashboards
        url: "/dashboards/retail_model::item_affinity_analysis?Focus%20Product={{ value | encode_uri }}&Product%20Level={{ _filters['order_items_base.product_level'] | url_encode }}&Analysis%20Timeframe={{ _filters['order_purchase_affinity.affinity_timeframe'] | url_encode }}&Store%20Number={{ _filters['order_purchase_affinity.store_number'] | url_encode }}"
      }
    }

    dimension: product_a_image {
      type: string
      sql: ${product_a} ;;
      #### TO DO: Replace with link to image OR refer to https://docs.google.com/document/d/1rCe0MiMkiKnOHhv1tpvIOeLja_oyJwNg_oHqG_IU-oQ/edit?usp=sharing to auto-generate images for your products!
      html: <img src="https://us-central1-image-search-project-241014.cloudfunctions.net/imageSearch?q={{rendered_value | encode_uri }}" height=100 /> ;;
    }

    dimension: product_b {
      type: string
      sql: ${TABLE}.product_b ;;
    }

    dimension: product_b_image {
      type: string
      sql: ${product_b} ;;
      #### TO DO: Replace with link to image OR refer to https://docs.google.com/document/d/1rCe0MiMkiKnOHhv1tpvIOeLja_oyJwNg_oHqG_IU-oQ/edit?usp=sharing to auto-generate images for your products!
      html: <img src="https://us-central1-image-search-project-241014.cloudfunctions.net/imageSearch?q={{rendered_value | encode_uri }}" height=100 /> ;;
    }

    dimension: joint_order_count {
      description: "How many times item A and B were purchased in the same order"
      type: number
      sql: ${TABLE}.joint_order_count ;;
      value_format: "#"
    }

    dimension: product_a_order_count {
      description: "Total number of orders with product A in them, during specified timeframe"
      type: number
      sql: ${TABLE}.product_a_order_count ;;
      value_format: "#"
    }

    dimension: product_b_order_count {
      description: "Total number of orders with product B in them, during specified timeframe"
      type: number
      sql: ${TABLE}.product_b_order_count ;;
      value_format: "#"
    }

    #  Frequencies
    dimension: product_a_order_frequency {
      description: "How frequently orders include product A as a percent of total orders"
      type: number
      sql: 1.0*${product_a_order_count}/${total_orders.count} ;;
      value_format: "0.00%"
    }

    dimension: product_b_order_frequency {
      description: "How frequently orders include product B as a percent of total orders"
      type: number
      sql: 1.0*${product_b_order_count}/${total_orders.count} ;;
      value_format: "0.00%"
    }


    dimension: joint_order_frequency {
      description: "How frequently orders include both product A and B as a percent of total orders"
      type: number
      sql: 1.0*${joint_order_count}/${total_orders.count} ;;
      value_format: "0.00%"
    }

    # Affinity Metrics

    dimension: add_on_frequency {
      description: "How many times both Products are purchased when Product A is purchased"
      type: number
      sql: 1.0*${joint_order_count}/${product_a_order_count} ;;
      value_format: "0.00%"
    }

    dimension: lift {
      description: "The likelihood that buying product A drove the purchase of product B"
      type: number
      value_format_name: decimal_3
      sql: 1*${joint_order_frequency}/(${product_a_order_frequency} * ${product_b_order_frequency}) ;;
    }

    dimension: product_a_count_purchased_alone {
      type: number
      hidden: yes
      sql: ${TABLE}.product_a_count_purchased_alone ;;
    }

    dimension: product_a_percent_purchased_alone {
      description: "The % of times product A is purchased alone, over all transactions containing product A"
      type: number
      sql: 1.0*${product_a_count_purchased_alone}/(CASE WHEN ${product_a_order_count}=0 THEN NULL ELSE ${product_a_order_count} END);;
      value_format_name: percent_1
    }

    dimension: product_a_count_orders_by_exclusive_customers {
      type: number
      hidden: yes
      sql: ${TABLE}.product_a_count_orders_by_exclusive_customers ;;
    }

    dimension: product_a_percent_customer_exclusivity{
      description: "% of times product A is purchased by customers who only bought product A in the timeframe"
      type: number
      sql: 1.0*${product_a_count_orders_by_exclusive_customers}/(CASE WHEN ${product_a_order_count}=0 THEN NULL ELSE ${product_a_order_count} END) ;;
      value_format_name: percent_2
    }

    dimension: product_a_count_purchased_by_loyalty_customer {
      type: number
      hidden: yes
      sql: ${TABLE}.product_a_count_purchased_by_loyalty_customer ;;
    }

    dimension: product_a_percent_purchased_by_loyalty_customer {
      description: "The % of times product A is purchased by a customer with a registered loyalty number"
      type: number
      sql: 1.0*${product_a_count_purchased_by_loyalty_customer}/(CASE WHEN ${product_a_order_count}=0 THEN NULL ELSE ${product_a_order_count} END);;
      value_format_name: percent_1
    }

    dimension: product_b_count_purchased_alone {
      type: number
      hidden: yes
      sql: ${TABLE}.product_b_count_purchased_alone ;;
    }

    dimension: product_b_percent_purchased_alone {
      description: "The % of times product B is purchased alone, over all transactions containing product B"
      type: number
      sql: 1.0*${product_b_count_purchased_alone}/(CASE WHEN ${product_b_order_count}=0 THEN NULL ELSE ${product_b_order_count} END);;
      value_format_name: percent_1
    }

    dimension: product_b_count_orders_by_exclusive_customers {
      type: number
      hidden: yes
      sql: ${TABLE}.product_b_count_orders_by_exclusive_customers ;;
    }

    dimension: product_b_percent_customer_exclusivity{
      description: "% of times product B is purchased by customers who only bought product B in the timeframe"
      type: number
      sql: 1.0*${product_b_count_orders_by_exclusive_customers}/(CASE WHEN ${product_b_order_count}=0 THEN NULL ELSE ${product_b_order_count} END) ;;
      value_format_name: percent_2
    }

    dimension: product_b_count_purchased_by_loyalty_customer {
      type: number
      hidden: yes
      sql: ${TABLE}.product_b_count_purchased_by_loyalty_customer ;;
    }

    dimension: product_b_percent_purchased_by_loyalty_customer {
      description: "The % of times product B is purchased by a customer with a registered loyalty number"
      type: number
      sql: 1.0*${product_b_count_purchased_by_loyalty_customer}/(CASE WHEN ${product_b_order_count}=0 THEN NULL ELSE ${product_b_order_count} END);;
      value_format_name: percent_1
    }

## Do not display unless users have a solid understanding of  statistics and probability models
    dimension: jaccard_similarity {
      description: "The probability both items would be purchased together, should be considered in relation to total order count, the highest score being 1"
      type: number
      sql: 1.0*${joint_order_count}/(${product_a_order_count} + ${product_b_order_count} - ${joint_order_count}) ;;
      value_format: "#,##0.#0"
    }

    # Sales Metrics - Totals

    dimension: product_a_total_sales {
      view_label: "Sales and Margin - Total"
      group_label: "Product A - Sales"
      type: number
      sql: ${TABLE}.product_a_product_sales ;;
      value_format_name: curr
    }

    dimension: product_a_total_basket_sales {
      view_label: "Sales and Margin - Total"
      group_label: "Product A - Sales"
      type: number
      sql: ${TABLE}.product_a_basket_sales ;;
      value_format_name: curr
    }

    dimension: product_a_total_rest_of_basket_sales {
      view_label: "Sales and Margin - Total"
      group_label: "Product A - Sales"
      type: number
      sql: ${product_a_total_basket_sales}-IFNULL(${product_a_total_sales},0) ;;
      value_format_name: curr
    }

    dimension: product_b_total_sales {
      view_label: "Sales and Margin - Total"
      group_label: "Product B - Sales"
      type: number
      sql: ${TABLE}.product_b_product_sales ;;
      value_format_name: curr
    }

    dimension: product_b_total_basket_sales {
      view_label: "Sales and Margin - Total"
      group_label: "Product B - Sales"
      type: number
      sql: ${TABLE}.product_b_basket_sales ;;
      value_format_name: curr
    }

    dimension: product_b_total_rest_of_basket_sales {
      view_label: "Sales and Margin - Total"
      group_label: "Product B - Sales"
      type: number
      sql: ${product_b_total_basket_sales}-IFNULL(${product_b_total_sales},0) ;;
      value_format_name: curr
    }

    # Margin Metrics - Totals

    dimension: product_a_total_margin {
      view_label: "Sales and Margin - Total"
      group_label: "Product A - Margin"
      type: number
      sql: ${TABLE}.product_a_product_margin ;;
      value_format_name: curr
    }

    dimension: product_a_total_basket_margin {
      view_label: "Sales and Margin - Total"
      group_label: "Product A - Margin"
      type: number
      sql: ${TABLE}.product_a_basket_margin ;;
      value_format_name: curr
    }

    dimension: product_a_total_rest_of_basket_margin {
      view_label: "Sales and Margin - Total"
      group_label: "Product A - Margin"
      type: number
      sql: ${product_a_total_basket_margin}-IFNULL(${product_a_total_margin},0) ;;
      value_format_name: curr
    }

    dimension: product_b_total_margin {
      view_label: "Sales and Margin - Total"
      group_label: "Product B - Margin"
      type: number
      sql: ${TABLE}.product_b_product_margin ;;
      value_format_name: curr
    }

    dimension: product_b_total_basket_margin {
      view_label: "Sales and Margin - Total"
      group_label: "Product B - Margin"
      type: number
      sql: ${TABLE}.product_b_basket_margin ;;
      value_format_name: curr
    }

    dimension: product_b_total_rest_of_basket_margin {
      view_label: "Sales and Margin - Total"
      group_label: "Product B - Margin"
      type: number
      sql: ${product_b_total_basket_margin}-IFNULL(${product_b_total_margin},0) ;;
      value_format_name: curr
    }

    # Sales Metrics - Average

    dimension: product_a_average_sales {
      view_label: "Sales and Margin - Average"
      group_label: "Product A - Sales"
      type: number
      sql: 1.0*${product_a_total_sales}/${product_a_order_count} ;;
      value_format_name: curr
    }

    dimension: product_a_average_basket_sales {
      view_label: "Sales and Margin - Average"
      group_label: "Product A - Sales"
      type: number
      sql: 1.0*${product_a_total_basket_sales}/${product_a_order_count} ;;
      value_format_name: curr
    }

    dimension: product_a_average_rest_of_basket_sales {
      view_label: "Sales and Margin - Average"
      group_label: "Product A - Sales"
      type: number
      sql: 1.0*${product_a_total_rest_of_basket_sales}/${product_a_order_count} ;;
      value_format_name: curr
    }

    dimension: product_b_average_sales {
      view_label: "Sales and Margin - Average"
      group_label: "Product B - Sales"
      type: number
      sql: 1.0*${product_b_total_sales}/${product_b_order_count} ;;
      value_format_name: curr
    }

    dimension: product_b_average_basket_sales {
      view_label: "Sales and Margin - Average"
      group_label: "Product B - Sales"
      type: number
      sql: 1.0*${product_b_total_basket_sales}/${product_b_order_count} ;;
      value_format_name: curr
    }

    dimension: product_b_average_rest_of_basket_sales {
      view_label: "Sales and Margin - Average"
      group_label: "Product B - Sales"
      type: number
      sql: 1.0*${product_b_total_rest_of_basket_sales}/${product_b_order_count} ;;
      value_format_name: curr
    }

    # Margin Metrics - Average

    dimension: product_a_average_margin {
      view_label: "Sales and Margin - Average"
      group_label: "Product A - Margin"
      type: number
      sql: 1.0*${product_a_total_margin}/${product_a_order_count} ;;
      value_format_name: curr
    }

    dimension: product_a_average_basket_margin {
      view_label: "Sales and Margin - Average"
      group_label: "Product A - Margin"
      type: number
      sql: 1.0*${product_a_total_basket_margin}/${product_a_order_count} ;;
      value_format_name: curr
      drill_fields: [product_a, product_a_percent_purchased_alone, product_a_percent_customer_exclusivity]
    }

    dimension: product_a_average_rest_of_basket_margin {
      view_label: "Sales and Margin - Average"
      group_label: "Product A - Margin"
      type: number
      sql: 1.0*${product_a_total_rest_of_basket_margin}/${product_a_order_count} ;;
      value_format_name: curr
      drill_fields: [product_a, product_a_percent_purchased_alone, product_a_percent_customer_exclusivity]
    }

    dimension: product_b_average_margin {
      view_label: "Sales and Margin - Average"
      group_label: "Product B - Margin"
      type: number
      sql: 1.0*${product_b_total_margin}/${product_b_order_count} ;;
      value_format_name: curr
    }

    dimension: product_b_average_basket_margin {
      view_label: "Sales and Margin - Average"
      group_label: "Product B - Margin"
      type: number
      sql: 1.0*${product_b_total_basket_margin}/${product_b_order_count} ;;
      value_format_name: curr
      drill_fields: [product_b, product_b_percent_purchased_alone, product_b_percent_customer_exclusivity]
    }

    dimension: product_b_average_rest_of_basket_margin {
      view_label: "Sales and Margin - Average"
      group_label: "Product B - Margin"
      type: number
      sql: 1.0*${product_b_total_rest_of_basket_margin}/${product_b_order_count} ;;
      value_format_name: curr
      drill_fields: [product_b, product_b_percent_purchased_alone, product_b_percent_customer_exclusivity]
    }

    # Aggregate Measures - ONLY TO BE USED WHEN FILTERING ON AN AGGREGATE DIMENSION (E.G. BRAND_A, CATEGORY_A)


    measure: aggregated_joint_order_count {
      description: "Only use when filtering on a rollup of product items, such as brand_a or category_a"
      type: sum
      sql: ${joint_order_count} ;;
    }
  }
