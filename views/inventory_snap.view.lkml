#-------------------------------------------------------------------
# Owner - Jonathan Stratton
# Inventory both current and historical
#-------------------------------------------------------------------

view: inventory_snap {
  sql_table_name: PRODUCTION.INVENTORY_SNAP ;;

  measure: available {
    label: "Total Available"
    type: sum
    sql: ${TABLE}.available ;;  }

  measure: average_cost {
    label: "Total Average Cost"
    description: "Summing the average cost field"
    type: sum
    sql: ${TABLE}.average_cost ;; }

  measure: backordered {
    label: "Total Backordered"
    type: sum
    sql: ${TABLE}.backordered ;; }

  dimension_group: created {
    label: "Created"
    type: time
    timeframes: [ raw, hour_of_day, time, date, day_of_week, day_of_month, week, week_of_year, month, month_name, quarter, quarter_of_year, year]
    sql: ${TABLE}.created ;; }

  dimension: week_bucket{
    group_label: "Created Date"
    label: "z - Week Bucket"
    description: "Grouping by week, for comparing last week, to the week before, to last year"
    type: string
     sql:  CASE WHEN date_trunc(week, ${TABLE}.Created::date) = date_trunc(week, current_date) THEN 'Current Week'
             WHEN date_trunc(week, ${TABLE}.Created::date) = dateadd(week, -1, date_trunc(week, current_date)) THEN 'Last Week'
             WHEN date_trunc(week, ${TABLE}.Created::date) = dateadd(week, -2, date_trunc(week, current_date)) THEN 'Two Weeks Ago'
             WHEN date_trunc(week, ${TABLE}.Created::date) = date_trunc(week, dateadd(week, 1, dateadd(year, -1, current_date))) THEN 'Current Week LY'
             WHEN date_trunc(week, ${TABLE}.Created::date) = date_trunc(week, dateadd(week, 0, dateadd(year, -1, current_date))) THEN 'Last Week LY'
             WHEN date_trunc(week, ${TABLE}.Created::date) = date_trunc(week, dateadd(week, -1, dateadd(year, -1, current_date))) THEN 'Two Weeks Ago LY'
             ELSE 'Other' END ;; }

  measure: inbound {
    label: "Total Inbound"
    type: sum
    sql: ${TABLE}.inbound ;; }

  dimension: item_id {
    label: "Item ID"
    description: "Internal Netsuite ID"
    type: number
    sql: ${TABLE}.item_id ;; }

  dimension: location_id {
    hidden: yes
    type: number
    sql: ${TABLE}.location_id ;; }

  measure: on_hand {
    label: "Total On Hand"
    type: sum
    sql: ${TABLE}.on_hand ;; }

  measure: on_order {
    label: "Total On Order"
    type: sum
    sql: ${TABLE}.on_order ;; }

  measure: outbound {
    label: "Total Outbound"
    type: sum
    sql: ${TABLE}.outbound ;; }

  dimension: preferred_stock_level {
    label: "Preferred Stock Level"
    type: number
    sql: ${TABLE}.preferred_stock_level ;; }

  measure: preferred_stock_level_msr {
    label: "Preferred Stock Level"
    type: sum
    sql: ${TABLE}.preferred_stock_level ;; }

  dimension: primary_key {
    primary_key: yes
    sql: CONCAT(${TABLE}.location_id,${TABLE}.item_id,${TABLE}.on_hand, ${TABLE}.available) ;;
    #NOT STRICTLY UNIQUE, COULD BE DUPLICATES
  }

  dimension: unit_standard_cost {
    group_label: " Advanced"
    label: "Unit Standard Cost"
    description: "Source:netsuite.item_standard_cost"
    type:  number
    value_format: "$#,##0.00"
    sql: ${standard_cost.standard_cost} ;;
  }

  measure: total_standard_cost {
    label: "Total Standard Cost (On Hand)"
    description: "Total Cost (cost per unit * number of units) for On Hand Units. Source:netsuite.sales_order_line"
    type:  sum
    value_format: "$#,##0"
    sql:  ${TABLE}.on_hand * ${standard_cost.standard_cost} ;;
  }

  parameter: see_data_by_inv_snap {
    type: unquoted
    #hidden: yes
    allowed_value: {
      label: "Day"
      value: "day"
    }
    allowed_value: {
      label: "Week"
      value: "week"
    }
    allowed_value: {
      label: "Month"
      value: "month"
    }
    allowed_value: {
      label: "Quarter"
      value: "quarter"
    }
    allowed_value: {
      label: "Warehouse Location"
      value: "warehouse_location"
    }
    allowed_value: {
      label: "Category"
      value: "category"
    }
    allowed_value: {
      label: "Line"
      value: "line"
    }
    allowed_value: {
      label: "Model"
      value: "model"
    }
    allowed_value: {
      label: "Product Name"
      value: "name"
    }
    allowed_value: {
      label: "SKU"
      value: "sku"
    }
  }

  dimension: see_data_inv_snap {
    label: "See Data By"
    hidden: yes
    sql:
    {% if see_data_by_inv_snap._parameter_value == 'day' %}
      ${created_date}
    {% elsif see_data_by_inv_snap._parameter_value == 'week' %}
      ${created_week}
    {% elsif see_data_by_inv_snap._parameter_value == 'month' %}
      ${created_month}
    {% elsif see_data_by_inv_snap._parameter_value == 'quarter' %}
      ${created_quarter}
    {% elsif see_data_by_inv_snap._parameter_value == 'warehouse_location' %}
      ${warehouse_location.location_name}
    {% elsif see_data_by_inv_snap._parameter_value == 'category' %}
      ${item.category_name}
    {% elsif see_data_by_inv_snap._parameter_value == 'line' %}
      ${item.line_raw}
    {% elsif see_data_by_inv_snap._parameter_value == 'model' %}
      ${item.model_raw}
    {% elsif see_data_by_inv_snap._parameter_value == 'name' %}
      ${item.product_description_raw}
    {% elsif see_data_by_inv_snap._parameter_value == 'sku' %}
      ${item.sku_id}
    {% else %}
       ${created_date}
    {% endif %};;
  }


}
