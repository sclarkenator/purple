view: tim_forecast_combined {

  derived_table: {
    sql:
      with zz as (
        --wholesale forecast merged with dates to get a count/day
        select b.date
            , a.sku_id
            , coalesce(a.total_units/c.days_in_week,0) as total_units
            , coalesce(a.total_amount/c.days_in_week,0) as total_amount
            , coalesce(a.MF_Instore_Units/c.days_in_week,0) as MF_Instore_Units
            , coalesce(a.MF_Online_Units/c.days_in_week,0) as MF_Online_Units
            , coalesce(a.FR_Units/c.days_in_week,0) as FR_Units
            , coalesce(a.Macys_Instore_Units/c.days_in_week,0) as Macys_Instore_Units
            , coalesce(a.Macys_Online_Units/c.days_in_week,0) as Macys_Online_Units
            , coalesce(a.SCC_Units/c.days_in_week,0) as SCC_Units
            , coalesce(a.BBB_Units/c.days_in_week,0) as BBB_Units
            , coalesce(a.Medical_Units/c.days_in_week,0) as Medical_Units
            , coalesce(a.Trucking_Units/c.days_in_week,0) as Trucking_Units
            , coalesce(a.MF_Instore_Amount/c.days_in_week,0) as MF_Instore_Amount
            , coalesce(a.MF_Online_Amount/c.days_in_week,0) as MF_Online_Amount
            , coalesce(a.FR_Amount/c.days_in_week,0) as FR_Amount
            , coalesce(a.Macys_Instore_Amount/c.days_in_week,0) as Macys_Instore_Amount
            , coalesce(a.Macys_Online_Amount/c.days_in_week,0) as Macys_Online_Amount
            , coalesce(a.SCC_Amount/c.days_in_week,0) as SCC_Amount
            , coalesce(a.BBB_Amount/c.days_in_week,0) as BBB_Amount
            , coalesce(a.Medical_Amount/c.days_in_week,0) as Medical_Amount
            , coalesce(a.Trucking_Amount/c.days_in_week,0) as Trucking_Amount
            , coalesce(a.Other_Units/c.days_in_week,0) as Other_Units
            , coalesce(a.Other_Amount/c.days_in_week,0) as Other_Amount
            , coalesce(a.HOM_Units/c.days_in_week,0) as HOM_Units
            , coalesce(a.HOM_Amount/c.days_in_week,0) as HOM_Amount
            , coalesce(a.BD_Units/c.days_in_week,0) as BD_Units
            , coalesce(a.BD_Amount/c.days_in_week,0) as BD_Amount
        from analytics.csv_uploads.FORECATED_UNITS_WHOLESALES a
        left join (
          select
              year::text || '-' ||case when week_of_year < 10 then concat('0',week_of_year::text) else week_of_year::text end as year_week
              , year
              , week_of_year
              , count (date) as days_in_week
              , min(date) as start_date
              , max(date) as end_date
          from analytics.util.warehouse_date
          where year > 2018
          group by year, week_of_year
          order by 1
        ) c on c.year_week = a.week
        left join analytics.util.warehouse_date b on b.date >= c.start_date and b.date <= c.end_date
        order by 2, 1
      ), yy as (
        --DTC forecast merged with dates to get a count/day
        select b.date
            , a.sku_id
            , a.amount/c.days_in_month as amount
            , a.units/c.days_in_month as paid_units
            , a.promo_units/c.days_in_month as promo_units
        from analytics.csv_uploads.forecasted_targets a
        left join analytics.util.warehouse_date b on b.month = month(a.date::date) and b.year = year(a.date::date)
        left join (
          select year, month, count (date) as days_in_month
          from analytics.util.warehouse_date
          group by year, month
        ) c on c.year = b.year and c.month = b.month
      )
      select coalesce(zz.date, yy.date) as date
          , coalesce(zz.sku_id, yy.sku_id) as sku_id

          , coalesce(zz.total_units, 0) + coalesce(yy.paid_units,0) + coalesce(yy.promo_units, 0) as total_units
          , coalesce(zz.total_amount, 0) + coalesce(yy.total_amount,0) as total_amount

          , coalesce(zz.total_units, 0) as wholesale_units
          , coalesce(yy.paid_units,0) + coalesce(yy.promo_units, 0) as dtc_units
          , coalesce(zz.total_amount, 0)  as wholesale_amount
          , coalesce(yy.amount,0) as dtc_amount

          , yy.promo_units

          , zz.MF_Instore_Units
          , zz.MF_Online_Units
          , zz.FR_Units
          , zz.Macys_Instore_Units
          , zz.Macys_Online_Units
          , zz.SCC_Units
          , zz.BBB_Units
          , zz.Medical_Units
          , zz.Trucking_Units
          , zz.MF_Instore_Amount
          , zz.MF_Online_Amount
          , zz.FR_Amount
          , zz.Macys_Instore_Amount
          , zz.Macys_Online_Amount
          , zz.SCC_Amount
          , zz.BBB_Amount
          , zz.Medical_Amount
          , zz.Trucking_Amount
          , zz.Other_Units
          , zz.Other_Amount
      from zz
      full outer join yy on yy.sku_id = zz.sku_id and yy.date = zz.date
      left join (
        select item_id, sku_id
          from (
            select item_id
              , sku_id
              , type
              , row_number () over (partition by sku_id order by type) as row_num
            from analytics.sales.item i
            order by 2,1
          ) a
          where a.row_num = 1
        order by 2,1
      ) i on i.sku_id = coalesce(yy.sku_id, zz.sku_id)
  ;; }

  dimension_group: date {
    label: "Forecast"
    type: time
    timeframes: [date, day_of_week, day_of_month, week, week_of_year, month, month_name, quarter, quarter_of_year, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.date ;; }

  dimension: Before_today{
    group_label: "Forecast Date"
    label: "z - Is Before Today (mtd)"
    #hidden:  yes
    description: "This field is for formatting on (week/month/quarter/year) to date reports"
    type: yesno
    sql: ${TABLE}.date < current_date;; }

  dimension: current_week_num{
    group_label: "Forecast Date"
    label: "z - Before Current Week"
    type: yesno
    sql: date_part('week',${TABLE}.date) < date_part('week',current_date);; }

  dimension: week_offset{
    group_label: "Forecast Date"
    label: "z - Week Offset"
    type: number
    sql: date_part('week',current_date) - date_part('week',${TABLE}.date) ;; }

  dimension: 6_weeks{
    group_label: "Forecast Date"
    label: "z - Before 6 Weeks Later"
    type: yesno
    sql: date_part('week',${TABLE}.date) < (date_part('week',current_date)+6);; }

  dimension: prev_week{
    group_label: "Forecast Date"
    label: "z - Previous Week"
    type: yesno
    sql: date_part('week',${TABLE}.date) = date_part('week',current_date)-1;; }

  dimension: cur_week{
    group_label: "Forecast Date"
    label: "z - Current Week"
    type: yesno
    sql: date_part('week',${TABLE}.date) = date_part('week',current_date);; }

  dimension: sku_id {
    type:  string
    sql:${TABLE}.sku_id ;; }

  measure: total_units {
    label: "Total Units"
    type:  sum
    value_format: "#,##0"
    sql:${TABLE}.total_units ;; }

  measure: total_amount {
    label: "Total Amount"
    type:  sum
    value_format: "$#,##0.00"
    sql:${TABLE}.total_amount ;; }


  measure: total_amount_million {
    label: "Total Amount (millions)"
    type:  sum
    value_format: "$#,##0.00,,\" M\""
    sql:${TABLE}.total_amount ;; }

  measure: wholesale_units {
    label: "Total Wholesale Units"
    type:  sum
    value_format: "#,##0"
    sql:${TABLE}.wholesale_units ;; }

  measure: wholesale_amount {
    label: "Total Wholesale Amount"
    type:  sum
    value_format: "$#,##0.00"
    sql:${TABLE}.wholesale_amount ;; }

  measure: dtc_units {
    label: "Total DTC Units"
    type:  sum
    value_format: "#,##0"
    sql:${TABLE}.dtc_units ;; }

  measure: dtc_amount {
    label: "Total DTC Amount"
    type:  sum
    value_format: "$#,##0.00"
    sql:${TABLE}.dtc_amount ;; }

  measure: MF_Instore_Units {
    label: "Wholesale MF Instore Units"
    type:  sum
    value_format: "#,##0"
    sql:${TABLE}.MF_Instore_Units ;; }

  measure: MF_Instore_Amount {
    label: "Wholesale MF Instore Amount"
    type:  sum
    value_format: "$#,##0.00"
    sql:${TABLE}.MF_Instore_Amount ;; }

  measure: MF_Online_Units {
    label: "Wholesale MF Online Units"
    type:  sum
    value_format: "#,##0"
    sql:${TABLE}.MF_Online_Units ;; }

  measure: MF_Online_Amount {
    label: "Wholesale MF Online Amount"
    type:  sum
    value_format: "$#,##0.00"
    sql:${TABLE}.MF_Online_Amount ;; }

  measure: FR_Units {
    label: "Wholesale FR Units"
    type:  sum
    value_format: "#,##0"
    sql:${TABLE}.FR_Units ;; }

  measure: FR_Amount {
    label: "Wholesale FR Amount"
    type:  sum
    value_format: "$#,##0.00"
    sql:${TABLE}.FR_Amount ;; }

  measure: Macys_Instore_Units {
    label: "Wholesale Macys Instore Units"
    type:  sum
    value_format: "#,##0"
    sql:${TABLE}.Macys_Instore_Units ;; }

  measure: Macys_Instore_Amount {
    label: "Wholesale Macys Instore Amount"
    type:  sum
    value_format: "$#,##0.00"
    sql:${TABLE}.Macys_Instore_Amount ;; }

  measure: Macys_Online_Units {
    label: "Wholesale Macys Online Units"
    type:  sum
    value_format: "#,##0"
    sql:${TABLE}.Macys_Online_Units ;; }

  measure: Macys_Online_Amount {
    label: "Wholesale Macy Online Amount"
    type:  sum
    value_format: "$#,##0.00"
    sql:${TABLE}.Macys_Online_Amount ;; }

  measure: SCC_Units {
    label: "Wholesale SCC Units"
    type:  sum
    value_format: "#,##0"
    sql:${TABLE}.SCC_Units ;; }

  measure: SCC_Amount {
    label: "Wholesale SCC Amount"
    type:  sum
    value_format: "$#,##0.00"
    sql:${TABLE}.SCC_Amount ;; }

  measure: BBB_Units {
    label: "Wholesale BBB Units"
    type:  sum
    value_format: "#,##0"
    sql:${TABLE}.BBB_Units ;; }

  measure: BBB_Amount {
    label: "Wholesale BBB Amount"
    type:  sum
    value_format: "$#,##0.00"
    sql:${TABLE}.BBB_Amount ;; }

  measure: Medical_Units {
    label: "Wholesale Medical Units"
    type:  sum
    value_format: "#,##0"
    sql:${TABLE}.Medical_Units ;; }

  measure: Medical_Amount {
    label: "Wholesale Medical Amount"
    type:  sum
    value_format: "$#,##0.00"
    sql:${TABLE}.Medical_Amount ;; }

  measure: Trucking_Units {
    label: "Wholesale Trucking Units"
    type:  sum
    value_format: "#,##0"
    sql:${TABLE}.Trucking_Units ;; }

  measure: Trucking_Amount {
    label: "Wholesale Trucking Amount"
    type:  sum
    value_format: "$#,##0.00"
    sql:${TABLE}.Trucking_Amount ;; }

  measure: Other_Units {
    label: "Wholesale Other Units"
    type:  sum
    value_format: "#,##0"
    sql:${TABLE}.Other_Units ;; }

  measure: Other_Amount {
    label: "Wholesale Other Amount"
    type:  sum
    value_format: "$#,##0.00"
    sql:${TABLE}.Other_Amount ;; }

  measure: BD_Units {
    label: "Wholesale Bloomingdales Units"
    type:  sum
    value_format: "#,##0"
    sql:${TABLE}.Other_Units ;; }

  measure: BD_Amount {
    label: "Wholesale Bloomingdales Amount"
    type:  sum
    value_format: "$#,##0.00"
    sql:${TABLE}.Other_Amount ;; }

  measure: HOM_Units {
    label: "Wholesale HOM Units"
    type:  sum
    value_format: "#,##0"
    sql:${TABLE}.Other_Units ;; }

  measure: hom_Amount {
    label: "Wholesale HOM Amount"
    type:  sum
    value_format: "$#,##0.00"
    sql:${TABLE}.Other_Amount ;; }

  measure: to_date {
    label: "Total Goal to Date"
    description: "This field is for formatting on (week/month/quarter/year) to date reports"
    type: sum
    value_format: "#,##0"
    sql: case when ${TABLE}.date < current_date then ${TABLE}.total_amount else 0 end;; }

}
