#-------------------------------------------------------------------
# Owner - Jonathan Stratton
# Inventory both current and historical
#-------------------------------------------------------------------

view: inventory_snap {
  sql_table_name: PRODUCTION.INVENTORY_SNAP ;;

  measure: on_hand {
    label: "  On Hand"
    description: "The quantity of an item physically in a warehouse."
    type: sum
    sql: ${TABLE}.ON_HAND ;; }

  measure: open_orders {
    label: "  Open orders"
    description: "Total unfulfilled units ordered across all channels in the last 35 days that are due within the next 7 days"
    type: sum
    sql: nvl(${TABLE}.open_order,0)  ;; }

  measure: dtc_open_orders {
    group_label: "Open order channel"
    label: "DTC"
    description: "Total unfulfilled units ordered for DTC in the last 35 days that are due within the next 7 days"
    type: sum
    sql: nvl(${TABLE}.dtc_open_order,0)  ;; }

  measure: wholesale_open_orders {
    group_label: "Open order channel"
    label: "Wholesale"
    description: "Total unfulfilled units ordered for wholesale in the last 35 days that are due within the next 7 days"
    type: sum
    sql: nvl(${TABLE}.wholesale_open_order,0)  ;; }

  measure: retail_open_orders {
    group_label: "Open order channel"
    label: "Retail"
    description: "Total unfulfilled units ordered for Retail in the last 35 days that are due within the next 7 days"
    type: sum
    sql: nvl(${TABLE}.retail_open_order,0)  ;; }

  measure: available {
    label: " Available"
    description: "The sum of surplus items in all warehouses less open orders"
    type: sum
    sql: case when ${TABLE}.calculated_available is null then ${TABLE}.available else nvl(${TABLE}.calculated_available,0) end  ;; }

  measure: backordered {
    label: " Backordered"
    description: "On-hand - open orders where open orders > on hand, aggregated from the location-level"
    type: sum
    sql: nvl(${TABLE}.calculated_backordered,0)*-1 ;; }

  measure: available_1 {
    group_label: "Netsuite_values"
    label: "Total Available"
    type: sum
    sql: ${TABLE}.available ;;  }

  measure: average_cost {
    hidden: yes
    label: "Total Average Cost"
    description: "Summing the average cost field"
    type: sum
    sql: ${TABLE}.average_cost ;; }

  measure: backordered_1 {
    group_label: "Netsuite_values"
    label: "Total Backordered"
    type: sum
    sql: ${TABLE}.backordered ;; }

  dimension_group: created {
    label: "Inventory Snap"
    type: time
    timeframes: [ raw, hour_of_day, time, date, day_of_week, day_of_month, week, month, month_name, quarter, quarter_of_year, year]
    sql: to_timestamp_ntz(${TABLE}.CREATED) ;; }

  dimension: created_week_of_year {
    ## Scott Clark 1/8/21: Added to replace week_of_year for better comps. Remove final week in 2021.
    type: number
    label: "Inventory Snap Week of Year"
    description: "2021 adjusted week of year number"
    sql: case when ${created_date::date} >= '2020-12-28' and ${created_date::date} <= '2021-01-03' then 1
              when ${created_year::number}=2021 then date_part(weekofyear,${created_date::date}) + 1
              else date_part(weekofyear,${created_date::date}) end ;;}

  dimension: week_bucket_old{
    group_label: "Inventory Snap Date"
    label: "z - Week Bucket"
    hidden:  yes
    description: "Grouping by week, for comparing last week, to the week before, to last year"
    type: string
     sql:  CASE WHEN date_trunc(week, ${TABLE}.Created::date) = date_trunc(week, current_date) THEN 'Current Week'
             WHEN date_trunc(week, ${TABLE}.Created::date) = dateadd(week, -1, date_trunc(week, current_date)) THEN 'Last Week'
             WHEN date_trunc(week, ${TABLE}.Created::date) = dateadd(week, -2, date_trunc(week, current_date)) THEN 'Two Weeks Ago'
             WHEN date_trunc(week, ${TABLE}.Created::date) = date_trunc(week, dateadd(week, 1, dateadd(year, -1, current_date))) THEN 'Current Week LY'
             WHEN date_trunc(week, ${TABLE}.Created::date) = date_trunc(week, dateadd(week, 0, dateadd(year, -1, current_date))) THEN 'Last Week LY'
             WHEN date_trunc(week, ${TABLE}.Created::date) = date_trunc(week, dateadd(week, -1, dateadd(year, -1, current_date))) THEN 'Two Weeks Ago LY'
             ELSE 'Other' END ;; }


  dimension: week_bucket{
    group_label: "Inventory Snap Date"
    label: "z - Week Bucket"
    description: "Grouping by week, for comparing last week, to the week before, to last year"
    type: string
     sql:  CASE WHEN ${created_week_of_year} = date_part (weekofyear,current_date) + 1 AND ${created_year} = date_part (year,current_date) THEN 'Current Week'
            WHEN ${created_week_of_year} = date_part (weekofyear,current_date) AND ${created_year} = date_part (year,current_date) THEN 'Last Week'
            WHEN ${created_week_of_year} = date_part (weekofyear,current_date) -1 AND ${created_year} = date_part (year,current_date) THEN 'Two Weeks Ago'
            WHEN ${created_week_of_year} = date_part (weekofyear,current_date) +1 AND ${created_year} = date_part (year,current_date) -1 THEN 'Current Week LY'
            WHEN ${created_week_of_year} = date_part (weekofyear,current_date) AND ${created_year} = date_part (year,current_date) -1 THEN 'Last Week LY'
            WHEN ${created_week_of_year} = date_part (weekofyear,current_date) -1 AND ${created_year} = date_part (year,current_date) -1 THEN 'Two Weeks Ago LY'
            ELSE 'Other' END ;; }


  measure: inbound {
    group_label: "Netsuite_values"
    label: "Total Inbound"
    type: sum
    sql: ${TABLE}.inbound ;; }

  dimension: item_id {
    hidden: yes
    label: "Item ID"
    description: "Internal Netsuite ID"
    type: number
    sql: ${TABLE}.item_id ;; }

  dimension: location_id {
    hidden: yes
    type: number
    sql: ${TABLE}.location_id ;; }

  measure: on_order_1 {
    group_label: "Netsuite_values"
    label: "Total On Order"
    type: sum
    sql: ${TABLE}.on_order ;; }

  measure: outbound {
    group_label: "Netsuite_values"
    label: "Total Outbound"
    type: sum
    sql: ${TABLE}.outbound ;; }

  dimension: preferred_stock_level {
    label: "Preferred Stock Level"
    type: number
    sql: ${TABLE}.preferred_stock_level ;; }

  measure: preferred_stock_level_msr {
    group_label: "Netsuite_values"
    label: "Preferred Stock Level"
    type: sum
    sql: ${TABLE}.preferred_stock_level ;; }

  dimension: primary_key {
    primary_key: yes
    hidden: yes
    sql: CONCAT(${TABLE}.location_id,${TABLE}.item_id,${created_date},${created_hour_of_day},${TABLE}.on_hand) ;;
    #NOT STRICTLY UNIQUE, COULD BE DUPLICATES
  }

  dimension: standard_cost {
    group_label: " Advanced"
    label: "Unit Standard Cost"
    description: "Source:Inventory snapshot table"
    hidden:  yes
    type:  number
    value_format: "$#,##0.00"
    sql: ${TABLE}.standard_cost ;;
  }

  dimension: on_hand_dm {
    hidden: yes
    group_label: " Advanced"
    type: number
    value_format: "#,##0"
    sql: ${TABLE}.on_hand ;;
  }

  dimension: unit_standard_cost {
    group_label: " Advanced"
    hidden: yes
    label: "Unit Standard Cost"
    description: "Source:netsuite.item_standard_cost"
    type:  number
    value_format: "$#,##0.00"
    sql: ${standard_cost.standard_cost} ;;
  }

  measure: total_standard_cost {
    label: "Total Standard Cost (On Hand)"
    description: "Total Cost (cost per unit * number of units) for On Hand Units"
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
