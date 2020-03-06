######################################################

#   DTC Gross Sales (Units) by Date and SKU (https://purple.looker.com/looks/4143)
######################################################
view: inventory_available_report_dtc_sales {
  derived_table: {
    explore_source: sales_order_line {
      column: created_date {}
      column: sku_id { field: item.sku_id }
      column: total_units {}
      filters: {  field: item.finished_good_flg value: "Yes"  }
      filters: {  field: sales_order.channel value: "DTC" }
      filters: {  field: item.modified value: "Yes" }
      filters: {  field: item.merchandise value: "No" }
      filters: {  field: sales_order_line.created_date value: "3 months ago for 3 months,before 1 months from now"  }
    }
  }
  dimension_group: created_date { label: "Sales Order     Order Date" description: "Time and date order was placed" type: time
    timeframes:[date, day_of_week, day_of_month, week, week_of_year, month, month_name, quarter, quarter_of_year, year]
    convert_tz: no datatype: timestamp  }
  dimension: sku_id { label: "Product SKU ID" description: "SKU ID for item (XX-XX-XXXXXX)" }
  measure: total_units {  label: "Sales Order Line Gross Sales (units)" description: "Total units purchased, before returns and cancellations" type: sum }
}

######################################################
#   Forecast Units by Date and SKU (https://purple.looker.com/looks/4142)
######################################################
view: inventory_available_report_forecast {
  derived_table: {
    explore_source: forecast_combined {
      column: date_date {}
      column: total_units {}
      column: sku_id { field: item.sku_id }
      filters: {  field: forecast_combined.date_date value: "3 months,before 1 months from now" }
    }
  }
  dimension_group: date_date {  label: "Forecast Combined Forecast Date" type: time
    timeframes:[date, day_of_week, day_of_month, week, week_of_year, month, month_name, quarter, quarter_of_year, year]
    convert_tz: no datatype: timestamp  }
  dimension: sku_id { label: "Product SKU ID" description: "SKU ID for item (XX-XX-XXXXXX)" }
  measure: total_units {  value_format: "#,##0" type: sum }
}

######################################################
#   Inventory on Hand (https://purple.looker.com/looks/4144)
######################################################
view: inventory_available_report_inventory_on_hand {
  derived_table: {
    explore_source: inventory_snap {
      column: created_date {}
      column: on_hand {}
      column: sku_id { field: item.sku_id }
      filters: {  field: inventory_snap.created_date value: "3 months,before 1 months from now"  }
      filters: {  field: warehouse_location.location_Active value: "No" }
      filters: {  field: inventory_snap.created_hour_of_day value: ">13"  }
      filters: {  field: warehouse_location.location_name value: "510 West Coast Consolidation,100-Purple West,105-WEST PRODUCTION Sub W/H,150-Apline,500 - FOB,M!) - Mainfreight Carson,G&M Mattress and Foam Corp,Brentwood Homes"}
    }
  }
  dimension_group: created_date { type: time
    timeframes:[date, day_of_week, day_of_month, week, week_of_year, month, month_name, quarter, quarter_of_year, year]
    convert_tz: no datatype: timestamp  }
  dimension: sku_id { description: "SKU ID for item (XX-XX-XXXXXX)" }
  measure: on_hand {  label: "Inventory Snap Total On Hand" type: sum }
}

######################################################
#   Historical Inventory Stock Level (https://purple.looker.com/looks/4146)
######################################################
view: inventory_available_report_stock_level {
  derived_table: {
    explore_source: inventory_snap {
      column: created_date {}
      column: preferred_stock_level_msr {}
      column: sku_id { field: item.sku_id }
      filters: {  field: inventory_snap.created_date value: "3 months,before 1 months from now"  }
      filters: {  field: warehouse_location.location_Active value: "No" }
      filters: {  field: inventory_snap.created_hour_of_day value: ">13"  }
      filters: {  field: warehouse_location.location_name value: "510 West Coast Consolidation,100-Purple West,105-WEST PRODUCTION Sub W/H,150-Apline,500 - FOB,M!) - Mainfreight Carson,G&M Mattress and Foam Corp,Brentwood Homes"}
    }
  }
  dimension_group: created_date { type: time
    timeframes:[date, day_of_week, day_of_month, week, week_of_year, month, month_name, quarter, quarter_of_year, year]
    convert_tz: no datatype: timestamp  }
  dimension: sku_id { description: "SKU ID for item (XX-XX-XXXXXX)" }
  measure: preferred_stock_level_msr {  label: "Inventory Snap Preferred Stock Level" type: sum }
}

######################################################
#   Production Goals (https://purple.looker.com/looks/4145)
######################################################
view: inventory_available_report_production_goals {
  derived_table: {
    explore_source: production_goal {
      column: forecast_date {}
      column: sku_id { field: item.sku_id }
      column: units_fg_produced { field: production_goal_by_item.units_fg_produced }
      filters: {  field: production_goal.forecast_date value: "3 months,before 1 months from now"  }
    }
  }
  dimension_group: forecast_date {  label: "Production Goals Forecast Date" type: time
    timeframes:[date, day_of_week, day_of_month, week, week_of_year, month, month_name, quarter, quarter_of_year, year]
    convert_tz: no datatype: timestamp  }
  dimension: sku_id { label: "Product SKU ID" description: "SKU ID for item (XX-XX-XXXXXX)" }
  measure: units_fg_produced {  label: "Production Goals Finished Goods Produced (units)" description: "Number of Finished Goods Produced (units) by SKU" type: sum }
}



######################################################
#   CREATING FINAL TABLE
######################################################
view: inventory_available_report {
  derived_table: {
    sql:
      select d.date
        , dtc.sku_id as sku_id
        , dtc.total_units as actual_units
        , forecast.total_units as forecasted_units
        , on_hand.on_hand as units_on_hand
        , stock_level.preferred_stock_level_msr as preferred_stock_level
        , production_goals.units_fg_produced as goal_units
      from analytics.util.warehouse_date d
      full outer join ${inventory_available_report_dtc_sales.SQL_TABLE_NAME} dtc on dtc.created_date::date = d.date
      full outer join ${inventory_available_report_forecast.SQL_TABLE_NAME} forecast  on forecast.date_date::date = coalesce(d.date, dtc.created_date::date)
        and forecast.sku_id = dtc.sku_id
      full outer join ${inventory_available_report_inventory_on_hand.SQL_TABLE_NAME} on_hand on on_hand.created_date::date = coalesce(d.date, dtc.created_date::date, forecast.date_date::date)
        and on_hand.sku_id = coalesce(forecast.sku_id, dtc.sku_id)
      full outer join ${inventory_available_report_stock_level.SQL_TABLE_NAME} stock_level on stock_level.created_date::date = coalesce(d.date, dtc.created_date::date, forecast.date_date::date, on_hand.created_date::date)
        and stock_level.sku_id = coalesce(on_hand.sku_id, forecast.sku_id, dtc.sku_id)
      full outer join ${inventory_available_report_production_goals.SQL_TABLE_NAME} production_goals on production_goals.forecast_date::date = coalesce(d.date, dtc.created_date::date, forecast.date_date::date, on_hand.created_date::date, stock_level.created_date::date)
        and production_goals.sku_id = coalesce(stock_level.sku_id, on_hand.sku_id, forecast.sku_id, dtc.sku_id)
      where date::date >= '2019-01-01' and date::date < '2022-01-01'  ;;

#      datagroup_trigger: pdt_refresh_6am
    }

    dimension: date {type: date hidden: yes}
    dimension_group: date {
      label: "Created"
      type: time
      timeframes: [raw, hour_of_day, date, day_of_week, day_of_week_index, day_of_month, day_of_year, week, week_of_year, month, month_name, quarter, quarter_of_year, year]
      convert_tz: no
      datatype: timestamp
      sql: to_timestamp_ntz(${date}) ;;  }

    dimension: sku_id {
      hidden: no
      label: "Product SKU ID"
      type: string
      description: "SKU ID for item (xx-xx-xxxxxx)"
      sql: ${TABLE}.sku_id ;;  }

    measure: actual_units {
      label: "Actual Units"
      description: "Total number of Actual Units Sold"
      value_format: "#,##0"
      type: sum
      sql: ${TABLE}.actual_units ;; }

    measure: forecasted_units {
      label: "Forecasted Units"
      description: "Total number of Forecasted Units"
      value_format: "#,##0"
      type: sum
      sql: ${TABLE}.forecasted_units ;; }

    measure: units_on_hand {
      label: "Units On Hand"
      description: "Total Inventory units On Hand"
      value_format: "#,##0"
      type: sum
      sql: ${TABLE}.units_on_hand ;; }

    measure: preferred_stock_level {
      label: "Preferred Stock Level"
      description: "Total Preferred Stock Level"
      value_format: "#,##0"
      type: sum
      sql: ${TABLE}.preferred_stock_level ;; }

    measure: goal_units {
      label: "Goal Units Produced"
      description: "Total number of Goal Units"
      value_format: "#,##0"
      type: sum
      sql: ${TABLE}.goal_units ;; }

  }
