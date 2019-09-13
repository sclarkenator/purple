######################################################
#   Sales
######################################################
view: sales_exec {
  derived_table: {
        explore_source: sales_order_line {
          column: sku_id { field: item.sku_id }
          column: channel2 { field: sales_order.channel2 }
          column: state { field: sf_zipcode_facts.state }
          column: week_bucket {}
          column: total_gross_Amt_non_rounded {}
          column: total_units {}
          filters: { field: sales_order.channel value: "-EMPTY" }
          filters: { field: item.merchandise value: "No" }
          filters: { field: item.finished_good_flg value: "Yes" }
          filters: { field: item.modified value: "Yes" }
          filters: { field: sales_order_line.week_bucket value: "Last Week,Two Weeks Ago,Last Week LY" }
        }
      }
      dimension: sku_id { }
      dimension: channel2 { }
      dimension: state { }
      dimension: week_bucket { }
      measure: total_gross_Amt_non_rounded { }
      measure: total_units { }
  }

######################################################
#   Wholesale Forecast
######################################################

view: wholesale_exec {
  derived_table: {
    explore_source: tim_forecast_wholesale {
      column: sku_id { field: item.sku_id }
       column: week_bucket {}
      column: total_amount {}
      column: total_units {}
      filters: { field: tim_forecast_wholesale.week_bucket value: "Last Week,Two Weeks Ago,Last Week LY" }
    }
  }
  dimension: sku_id { }
  dimension: week_bucket { }
  dimension: total_amount { }
  dimension: total_units { }
}

######################################################
#   DTC Forecast
######################################################

view: dtc_exec {
  derived_table: {
    explore_source: tim_forecast {
      column: sku_id { field: item.sku_id }
      column: week_bucket {}
      column: amount {}
      column: total_units {}
      filters: { field: tim_forecast.week_bucket value: "Last Week,Two Weeks Ago,Last Week LY" }
    }
  }
  dimension: sku_id { }
  dimension: week_bucket { }
  dimension: amount { }
  dimension: total_units { }
}

######################################################
#   Inventory
######################################################
view: inventory_exec {
  derived_table: {
    explore_source: inventory_snap {
      column: sku_id { field: item.sku_id }
      column: week_bucket {}
      column: available {}
      filters: { field: warehouse_location.location_Active value: "No" }
      filters: { field: inventory_snap.created_hour_of_day value: "11" }
      filters: { field: inventory_snap.week_bucket value: "Last Week,Two Weeks Ago,Last Week LY" }
    }
  }
  dimension: sku_id { }
  dimension: week_bucket { }
  dimension: available { }
}

######################################################
#   Produced
######################################################
view: prod_exec {
  derived_table: {
    explore_source: assembly_build {
      column: sku_id { field: item.sku_id }
      column: week_bucket {}
      column: Total_Quantity {}
      filters: { field: assembly_build.scrap value: "0" }
      filters: { field: item.merchandise value: "0" }
      filters: { field: assembly_build.week_bucket value: "Last Week,Two Weeks Ago,Last Week LY" }
    }
  }
  dimension: sku_id { }
  dimension: week_bucket { }
  dimension: Total_Quantity { }
}

######################################################
#   Fulfilled
######################################################
view: ff_exec {
  derived_table: {
    explore_source: sales_order_line {
      column: sku_id { field: item.sku_id }
      column: channel2 { field: sales_order.channel2 }
      column: state { field: sf_zipcode_facts.state }
      column: fulfilled_orders {}
      column: fulfilled_orders_units {}
      column: week_bucket_ff {}
      filters: { field: sales_order.channel value: "-EMPTY" }
      filters: { field: item.merchandise value: "No" }
      filters: { field: item.finished_good_flg value: "Yes" }
      filters: { field: item.modified value: "Yes" }
      filters: { field: sales_order_line.week_bucket_ff value: "Last Week,Two Weeks Ago,Last Week LY" }
    }
  }
  dimension: sku_id { }
  dimension: channel2 { }
  dimension: state { }
  measure: fulfilled_orders { }
  measure: fulfilled_orders_units { }
  dimension: week_bucket_ff { }
}




#######################################################################################################################
#   CREATING FINAL TABLE
#######################################################################################################################
view: executive_report{
  derived_table: {
    sql:
      with aa as(
        select sku_id
          , week_bucket
          , 'Wholesale' as channel
          , null as state
          , total_amount
          , total_units
        from ${wholesale_exec.SQL_TABLE_NAME}
        union all
        select sku_id
          , week_bucket
          , 'DTC' as channel
          , null as state
          , amount
          , total_units
        from ${dtc_exec.SQL_TABLE_NAME}
      )
      select coalesce(sales.sku_id, aa.sku_id, inv.sku_id, prod.sku_id, ff.sku_id)  as sku_id
        , coalesce(sales.channel2, aa.channel, inv.channel, prod.channel, ff.channel)  as channel
        , coalesce(sales.state, aa.state, inv.state, prod.state, ff.state) as state
        , coalesce(sales.week_bucket, aa.week_bucket, inv.week_bucket, prod.week_bucket, ff.week_bucket) as week_bucket
        , sales.total_gross_Amt_non_rounded as sales_amt
        , sales.total_units as sales_units
        , aa.total_amount as forecast_amt
        , aa.total_units as forecast_units
        , inv.available as inv
        , prod.Total_Quantity as prod
        , ff.fulfilled_orders as ff_amt
        , ff.fulfilled_orders as ff_units
      from ${sales_exec.SQL_TABLE_NAME} sales
      full outer join aa on aa.sku_id = sales.sku_id and aa.channel = sales.channel2 and aa.state = sales.state
      full outer join (select sku_id
          , null as channel
          , null as state
          , week_bucket
          , available
        from ${inventory_exec.SQL_TABLE_NAME}
      ) inv on inv.sku_id = coalesce(sales.sku_id, aa.sku_id)
        and inv.channel = coalesce(sales.channel2, aa.channel)
        and inv.state = coalesce(sales.state, aa.state, inv.state)
        and inv.week_bucket = coalesce(sales.week_bucket, aa.week_bucket)
      full outer join (select sku_id
          , null as channel
          , null as state
          , week_bucket
          , Total_Quantity
        from ${prod_exec.SQL_TABLE_NAME}
      ) prod on prod.sku_id = coalesce(sales.sku_id, aa.sku_id, inv.sku_id)
        and prod.channel = coalesce(sales.channel2, aa.channel, inv.channel)
        and prod.state = coalesce(sales.state, aa.state, inv.state)
        and prod.week_bucket = coalesce(sales.week_bucket, aa.week_bucket, inv.week_bucket)
      full outer join (select sku_id
          , null as channel
          , null as state
          , week_bucket_ff as week_bucket
          , fulfilled_orders
          , fulfilled_orders_units
        from ${ff_exec.SQL_TABLE_NAME}
      ) ff on ff.sku_id = coalesce(sales.sku_id, aa.sku_id, inv.sku_id, prod.sku_id)
        and ff.channel = coalesce(sales.channel2, aa.channel, inv.channel, prod.channel)
        and ff.state = coalesce(sales.state, aa.state, inv.state, prod.state)
        and ff.week_bucket = coalesce(sales.week_bucket, aa.week_bucket, inv.week_bucket, prod.week_bucket)
    ;;
  }

   dimension: sku_id {
     label: "Sku ID"
     type: string
     sql: ${TABLE}.sku_id;; }

   dimension: channel {
     label: "Channel"
     type: string
     sql: ${TABLE}.channel;; }

   dimension: state {
     label: "State"
     type: string
     sql: ${TABLE}.state;; }

  dimension: week_bucket {
    label: "Week Bucket"
    type: string
    sql: ${TABLE}.week_bucket;; }

   measure: sales {
     label: "Gross Sales ($)"
     type: sum
     value_format: "$#,##0"
     sql: ${TABLE}.sales_amt;; }

  measure: sales_units {
    label: "Gross Sales (#)"
    type: sum
    value_format: "#,##0"
    sql: ${TABLE}.sales_units;; }

  measure: forecast_amt {
    label: "Forecast ($)"
    type: sum
    value_format: "$#,##0"
    sql: ${TABLE}.forecast_amt;; }

  measure: forecast_units {
    label: "Forecast (#)"
    type: sum
    value_format: "#,##0"
    sql: ${TABLE}.forecast_units;; }

  measure: inv {
    label: "Inventory (#)"
    type: sum
    value_format: "#,##0"
    sql: ${TABLE}.inv;; }

  measure: prod {
    label: "Produced (#)"
    type: sum
    value_format: "#,##0"
    sql: ${TABLE}.prod;; }

  measure: ff_units {
    label: "Fulfilled (#)"
    type: sum
    value_format: "#,##0"
    sql: ${TABLE}.ff_units;; }

  measure: ff_amt {
    label: "Fulfilled ($)"
    type: sum
    value_format: "$#,##0"
    sql: ${TABLE}.ff_amt;; }
}
