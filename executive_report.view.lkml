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
view: executive_report {
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
        , ff.fulfilled_orders_units as ff_units
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
    hidden: yes
    type: string
    sql: ${TABLE}.week_bucket;; }

  measure: sales_amt {
    label: "Gross Sales ($)"
    hidden: yes
    type: sum
    value_format: "$#,##0"
    sql: ${TABLE}.sales_amt;; }

  measure: sales_units {
    label: "Gross Sales (#)"
    hidden: yes
    type: sum
    value_format: "#,##0"
    sql: ${TABLE}.sales_units;; }

  measure: forecast_amt {
    label: "Forecast ($)"
    hidden: yes
    type: sum
    value_format: "$#,##0"
    sql: ${TABLE}.forecast_amt;; }

  measure: forecast_units {
    label: "Forecast (#)"
    hidden: yes
    type: sum
    value_format: "#,##0"
    sql: ${TABLE}.forecast_units;; }

  measure: inv {
    label: "Inventory (#)"
    hidden: yes
    type: sum
    value_format: "#,##0"
    sql: ${TABLE}.inv;; }

  measure: prod {
    label: "Produced (#)"
    hidden: yes
    type: sum
    value_format: "#,##0"
    sql: ${TABLE}.prod;; }

  measure: ff_units {
    label: "Fulfilled (#)"
    hidden: yes
    type: sum
    value_format: "#,##0"
    sql: ${TABLE}.ff_units;; }

  measure: ff_amt {
    label: "Fulfilled ($)"
    hidden: yes
    type: sum
    value_format: "$#,##0"
    sql: ${TABLE}.ff_amt;; }

##########################   Last Week
  measure: sales_amt_lw {
    label: "Gross Sales ($) LW"
    type: sum
    value_format: "$#,##0"
    sql: case when ${TABLE}.week_bucket = 'Last Week' then ${TABLE}.sales_amt else 0 end;; }

  measure: sales_units_lw {
    label: "Gross Sales (#) LW"
    type: sum
    value_format: "#,##0"
    sql: case when ${TABLE}.week_bucket = 'Last Week' then ${TABLE}.sales_units else 0 end;; }

  measure: forecast_amt_lw {
    label: "Forecast ($) LW"
    type: sum
    value_format: "$#,##0"
    sql: case when ${TABLE}.week_bucket = 'Last Week' then ${TABLE}.forecast_amt else 0 end;; }

  measure: forecast_units_lw {
    label: "Forecast (#) LW"
    type: sum
    value_format: "#,##0"
    sql: case when ${TABLE}.week_bucket = 'Last Week' then ${TABLE}.forecast_units else 0 end;; }

  measure: inv_lw {
    label: "Inventory (#) LW"
    type: sum
    value_format: "#,##0"
    sql: case when ${TABLE}.week_bucket = 'Last Week' then ${TABLE}.inv else 0 end;; }

  measure: prod_lw {
    label: "Produced (#) LW"
    type: sum
    value_format: "#,##0"
    sql: case when ${TABLE}.week_bucket = 'Last Week' then ${TABLE}.prod else 0 end;; }

  measure: ff_units_lw {
    label: "Fulfilled (#) LW"
    type: sum
    value_format: "#,##0"
    sql: case when ${TABLE}.week_bucket = 'Last Week' then ${TABLE}.ff_units else 0 end;; }

  measure: ff_amt_lw {
    label: "Fulfilled ($) LW"
    type: sum
    value_format: "$#,##0"
    sql: case when ${TABLE}.week_bucket = 'Last Week' then ${TABLE}.ff_amt else 0 end;; }

##########################   Previous Week (Two Weeks Ago)
  measure: sales_amt_pw {
    label: "Gross Sales ($) PW"
    type: sum
    value_format: "$#,##0"
    sql: case when ${TABLE}.week_bucket = 'Two Weeks Ago' then ${TABLE}.sales_amt else 0 end;; }

  measure: sales_units_pw {
    label: "Gross Sales (#) PW"
    type: sum
    value_format: "#,##0"
    sql: case when ${TABLE}.week_bucket = 'Two Weeks Ago' then ${TABLE}.sales_units else 0 end;; }

  measure: forecast_amt_pw {
    label: "Forecast ($) PW"
    type: sum
    value_format: "$#,##0"
    sql: case when ${TABLE}.week_bucket = 'Two Weeks Ago' then ${TABLE}.forecast_amt else 0 end;; }

  measure: forecast_units_pw {
    label: "Forecast (#) PW"
    type: sum
    value_format: "#,##0"
    sql: case when ${TABLE}.week_bucket = 'Two Weeks Ago' then ${TABLE}.forecast_units else 0 end;; }

  measure: inv_pw {
    label: "Inventory (#) PW"
    type: sum
    value_format: "#,##0"
    sql: case when ${TABLE}.week_bucket = 'Two Weeks Ago' then ${TABLE}.inv else 0 end;; }

  measure: prod_pw {
    label: "Produced (#) PW"
    type: sum
    value_format: "#,##0"
    sql: case when ${TABLE}.week_bucket = 'Two Weeks Ago' then ${TABLE}.prod else 0 end;; }

  measure: ff_units_pw {
    label: "Fulfilled (#) PW"
    type: sum
    value_format: "#,##0"
    sql: case when ${TABLE}.week_bucket = 'Two Weeks Ago' then ${TABLE}.ff_amt else 0 end;; }

  measure: ff_amt_pw {
    label: "Fulfilled ($) PW"
    type: sum
    value_format: "$#,##0"
    sql: case when ${TABLE}.week_bucket = 'Two Weeks Ago' then ${TABLE}.ff_amt else 0 end;; }

##########################   Last Year (last week)
  measure: sales_amt_ly {
    label: "Gross Sales ($) LY"
    type: sum
    value_format: "$#,##0"
    sql: case when ${TABLE}.week_bucket = 'Last Week LY' then ${TABLE}.sales_amt else 0 end;; }

  measure: sales_units_ly {
    label: "Gross Sales (#) LY"
    type: sum
    value_format: "#,##0"
    sql: case when ${TABLE}.week_bucket = 'Last Week LY' then ${TABLE}.sales_units else 0 end;; }

  measure: forecast_amt_ly {
    label: "Forecast ($) LY"
    type: sum
    value_format: "$#,##0"
    sql: case when ${TABLE}.week_bucket = 'Last Week LY' then ${TABLE}.forecast_amt else 0 end;; }

  measure: forecast_units_ly {
    label: "Forecast (#) LY"
    type: sum
    value_format: "#,##0"
    sql: case when ${TABLE}.week_bucket = 'Last Week LY' then ${TABLE}.forecast_units else 0 end;; }

  measure: inv_ly {
    label: "Inventory (#) LY"
    type: sum
    value_format: "#,##0"
    sql: case when ${TABLE}.week_bucket = 'Last Week LY' then ${TABLE}.inv else 0 end;; }

  measure: prod_ly {
    label: "Produced (#) LY"
    type: sum
    value_format: "#,##0"
    sql: case when ${TABLE}.week_bucket = 'Last Week LY' then ${TABLE}.prod else 0 end;; }

  measure: ff_units_ly {
    label: "Fulfilled (#) LY"
    type: sum
    value_format: "#,##0"
    sql: case when ${TABLE}.week_bucket = 'Last Week LY' then ${TABLE}.ff_units else 0 end;; }

  measure: ff_amt_ly {
    label: "Fulfilled ($) LY"
    type: sum
    value_format: "$#,##0"
    sql: case when ${TABLE}.week_bucket = 'Last Week LY' then ${TABLE}.ff_amt else 0 end;; }

##########################   Week over Week
  measure: sales_amt_ww {
    label: "Gross Sales ($) W/W"
    type: number
    value_format: "0.0\%"
    sql: case when ${sales_amt_lw} > 0 and ${sales_amt_pw} > 0 then 100*${sales_amt_lw}/nullif(${sales_amt_pw},0)
            when ${sales_amt_lw} > 0 then 0
            else 0 end;; }

  measure: sales_units_ww {
    label: "Gross Sales (#) W/W"
    type: number
    value_format: "0.0\%"
    sql: case when ${sales_units_lw} > 0 and ${sales_units_pw} > 0 then 100*${sales_units_lw}/nullif(${sales_units_pw},0)
            when ${sales_units_lw} > 0 then 1
            else 0 end;; }

  measure: forecast_amt_ww {
    label: "Forecast ($) W/W"
    type: number
    value_format: "0.0\%"
    sql: case when ${forecast_amt_lw} > 0 and ${forecast_amt_pw} > 0 then 100*${forecast_amt_lw}/nullif(${forecast_amt_pw},0)
            when ${forecast_amt_lw} > 0 then 1
            else 0 end;; }

  measure: forecast_units_ww {
    label: "Forecast (#) W/W"
    type: number
    value_format: "0.0\%"
    sql: case when ${forecast_units_lw} > 0 and ${forecast_units_pw} > 0 then 100*${forecast_units_lw}/nullif(${forecast_units_pw},0)
            when ${forecast_units_lw} > 0 then 1
            else 0 end;; }

  measure: inv_ww {
    label: "Inventory (#) W/W"
    type: number
    value_format: "0.0\%"
    sql: case when ${inv_lw} > 0 and ${inv_pw} > 0 then 100*${inv_lw}/nullif(${inv_pw},0)
            when ${inv_lw} > 0 then 1
            else 0 end;; }

  measure: prod_ww {
    label: "Produced (#) W/W"
    type: number
    value_format: "0.0\%"
    sql: case when ${prod_lw} > 0 and ${prod_pw} > 0 then 100*${prod_lw}/nullif(${prod_pw},0)
            when ${prod_lw} > 0 then 1
            else 0 end;; }

  measure: ff_units_ww {
    label: "Fulfilled (#) W/W"
    type: number
    value_format: "0.0\%"
    sql: case when ${ff_units_lw} > 0 and ${ff_units_pw} > 0 then 100*${ff_units_lw}/nullif(${ff_units_pw},0)
            when ${ff_units_lw} > 0 then 1
            else 0 end;; }

  measure: ff_amt_ww {
    label: "Fulfilled ($) W/W"
    type: number
    value_format: "0.0\%"
    sql: case when ${ff_amt_lw} > 0 and ${ff_amt_pw} > 0 then 100*${ff_amt_lw}/nullif(${ff_amt_pw},0)
            when ${ff_amt_lw} > 0 then 1
            else 0 end;; }

##########################   Year over Year
  measure: sales_amt_yy {
    label: "Gross Sales ($) Y/Y"
    type: number
    value_format: "0.0\%"
    sql: case when ${sales_amt_lw} > 0 and ${sales_amt_ly} > 0 then 100*${sales_amt_lw}/nullif(${sales_amt_ly},0)
            when ${sales_amt_lw} > 0 then 1
            else 0 end;; }

  measure: sales_units_yy {
    label: "Gross Sales (#) Y/Y"
    type: number
    value_format: "0.0\%"
    sql: case when ${sales_units_lw} > 0 and ${sales_units_ly} > 0 then 100*${sales_units_lw}/nullif(${sales_units_ly},0)
            when ${sales_units_lw} > 0 then 1
            else 0 end;; }

  measure: forecast_amt_yy {
    label: "Forecast ($) Y/Y"
    type: number
    value_format: "0.0\%"
    sql: case when ${forecast_amt_lw} > 0 and ${forecast_amt_ly} > 0 then 100*${forecast_amt_lw}/nullif(${forecast_amt_ly},0)
            when ${forecast_amt_lw} > 0 then 1
            else 0 end;; }

  measure: forecast_units_yy {
    label: "Forecast (#) Y/Y"
    type: number
    value_format: "0.0\%"
    sql: case when ${forecast_units_lw} > 0 and ${forecast_units_ly} > 0 then 100*${forecast_units_lw}/nullif(${forecast_units_ly},0)
            when ${forecast_units_lw} > 0 then 1
            else 0 end;; }

  measure: inv_yy {
    label: "Inventory (#) Y/Y"
    type: number
    value_format: "0.0\%"
    sql: case when ${inv_lw} > 0 and ${inv_ly} > 0 then 100*${inv_lw}/nullif(${inv_ly},0)
            when ${inv_lw} > 0 then 1
            else 0 end;; }

  measure: prod_yy {
    label: "Produced (#) Y/Y"
    type: number
    value_format: "0.0\%"
    sql: case when ${prod_lw} > 0 and ${prod_ly} > 0 then 100*${prod_lw}/nullif(${prod_ly},0)
            when ${prod_lw} > 0 then 1
            else 0 end;; }

  measure: ff_units_yy {
    label: "Fulfilled (#) Y/Y"
    type: number
    value_format: "0.0\%"
    sql: case when ${ff_units_lw} > 0 and ${ff_units_ly} > 0 then 100*${ff_units_lw}/nullif(${ff_units_ly},0)
            when ${ff_units_lw} > 0 then 1
            else 0 end;; }

  measure: ff_amt_yy {
    label: "Fulfilled ($) Y/Y"
    type: number
    value_format: "0.0\%"
    sql: case when ${ff_amt_lw} > 0 and ${ff_amt_ly} > 0 then 100*${ff_amt_lw}/nullif(${ff_amt_ly},0)
            when ${ff_amt_lw} > 0 then 1
            else 0 end;; }

##########################   to Plan
  measure: sales_amt_tp {
    label: "Gross Sales ($) to Plan"
    type: number
    value_format: "0.0\%"
    sql: case when ${sales_amt_lw} > 0 and ${forecast_amt_lw} > 0 then 100*${sales_amt_lw}/nullif(${forecast_amt_lw},0)
            when ${sales_amt_lw} > 0 then 1
            else 0 end;; }

  measure: sales_units_tp {
    label: "Gross Sales (#) to Plan"
    type: number
    value_format: "0.0\%"
    sql: case when ${sales_units_lw} > 0 and ${forecast_units_lw} > 0 then 100*${sales_units_lw}/nullif(${forecast_units_lw},0)
            when ${sales_units_lw} > 0 then 1
            else 0 end;; }

  measure: ff_units_tp {
    label: "Fulfilled (#) to Produced"
    type: number
    value_format: "0.0\%"
    sql: case when ${ff_units_lw} > 0 and ${prod_lw} > 0 then 100*${ff_units_lw}/nullif(${prod_lw},0)
            when ${ff_units_lw} > 0 then 1
            else 0 end;; }

##########################   Filters
   measure: sales_amt_f {
    label: "Gross Sales ($) Filter"
    type: yesno
    sql: ${sales_amt_lw}+${sales_amt_pw}+${sales_amt_ly} > 0 ;; }

  measure: sales_units_f {
    label: "Gross Sales (#) Filter"
    type: yesno
    sql: ${sales_units_lw}+${sales_units_pw}+${sales_units_ly} > 0 ;; }

  measure: forecast_amt_f {
    label: "Forecast ($) Filter"
    type: yesno
    sql: ${forecast_amt_lw}+${forecast_amt_pw}+${forecast_amt_ly} > 0 ;; }

  measure: forecast_units_f {
    label: "Forecast (#) Filter"
    type: yesno
    sql: ${forecast_units_lw}+${forecast_units_pw}+${forecast_units_ly} > 0 ;; }

  measure: inv_f {
    label: "Inventory (#) Filter"
    type: yesno
    sql: ${inv_lw}+${inv_pw}+${inv_ly} > 0 ;; }

  measure: prod_f {
    label: "Produced (#) Filter"
    type: yesno
    sql: ${prod_lw}+${prod_pw}+${prod_ly} > 0 ;; }

  measure: ff_units_f {
    label: "Fulfilled (#) Filter"
    type: yesno
    sql: ${ff_units_lw}+${ff_units_pw}+${ff_units_ly} > 0 ;; }

  measure: ff_amt_f {
    label: "Fulfilled ($) Filter"
    type: yesno
    sql: ${ff_amt_lw}+${ff_amt_pw}+${ff_amt_ly} > 0 ;; }

}
