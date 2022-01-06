
view: forecast_v2 {
  sql_table_name: sales.v_forecast ;;

  dimension: version {
    label: "Forecast Version"
    type: string
    description: "Working is the current data in Adaptive, Current S&OP is locked at the first Saturday of the current month, Previous is 1 month previos.  Rolling 4 month is looking at the forecast data from 4 months previous to the date being forecasted. "
    case: {
      when: { sql: ${version_raw} = 'Working' ;; label: "Working" }
      when: { sql: ${version_raw} = 'Current S&OP' ;; label: "Current S&OP" }
      when: { sql: ${version_raw} = 'Running 4 Month' ;; label: "Running 4 Month" }
    }
  }

  dimension: version_raw {
    type: string
    sql: ${TABLE}.version ;;
  }

  dimension: forecast_made_date {
    type: date
    sql: ${TABLE}.forecast_made_date ;;
  }

  dimension_group: date {
    label: "Forecast"
    type: time
    timeframes: [date, day_of_week, day_of_month, week, month, month_name, quarter, quarter_of_year, year, week_of_year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.forecast ;; }

  # dimension: date_week_of_year {
  #   ## Scott Clark 1/8/21: Added to replace week_of_year for better comps. Remove final week in 2021.
  #   type: number
  #   label: "Forecast Week of Year"
  #   description: "2021 adjusted week of year number"
  #   sql: case when ${date_date::date} >= '2020-12-28' and ${date_date::date} <= '2021-01-03' then 1
  #             when ${date_year::number}=2021 then date_part(weekofyear,${date_date::date}) + 1
  #             else date_part(weekofyear,${date_date::date}) end ;;
  # }

  dimension: before_today{
    group_label: "Forecast Date"
    label: "z - Is Before Today (mtd)"
    description: "This field is for formatting on (week/month/quarter/year) to date reports"
    type: yesno
    sql: ${TABLE}.forecast < current_date;; }

  dimension: current_week_num{
    group_label: "Forecast Date"
    label: "z - Before Current Week"
    type: yesno
    sql: date_trunc(week, ${TABLE}.forecast::date) < date_trunc(week, current_date) ;;}

  dimension: week_offset{
    group_label: "Forecast Date"
    label: "z - Week Offset"
    type: number
    sql: date_part('week',current_date) - date_part('week',${TABLE}.forecast) ;; }

  dimension: 6_weeks{
    group_label: "Forecast Date"
    label: "z - Before 6 Weeks Later"
    type: yesno
    sql: date_part('week',${TABLE}.forecast) < (date_part('week',current_date)+6);; }

  dimension: prev_week{
    group_label: "Forecast Date"
    label: "z - Previous Week"
    type: yesno
    sql:  date_trunc(week, ${TABLE}.forecast::date) = dateadd(week, -1, date_trunc(week, current_date)) ;; }

  dimension: cur_week{
    group_label: "Forecast Date"
    label: "z - Current Week"
    type: yesno
    sql: date_trunc(week, ${TABLE}.forecast) = date_trunc(week, current_date) ;;}

  dimension: week_bucket_old{
    group_label: "Forecast Date"
    label: "z - Week Bucket"
    hidden: yes
    description: "Grouping by week, for comparing last week, to the week before, to last year"
    type: string
    sql:  CASE WHEN date_trunc(week, ${TABLE}.forecast::date) = date_trunc(week, current_date) THEN 'Current Week'
             WHEN date_trunc(week, ${TABLE}.forecast::date) = dateadd(week, -1, date_trunc(week, current_date)) THEN 'Last Week'
             WHEN date_trunc(week, ${TABLE}.forecast::date) = dateadd(week, -2, date_trunc(week, current_date)) THEN 'Two Weeks Ago'
             WHEN date_trunc(week, ${TABLE}.forecast::date) = date_trunc(week, dateadd(week, 1, dateadd(year, -1, current_date))) THEN 'Current Week LY'
             WHEN date_trunc(week, ${TABLE}.forecast::date) = date_trunc(week, dateadd(week, 0, dateadd(year, -1, current_date))) THEN 'Last Week LY'
             WHEN date_trunc(week, ${TABLE}.forecast::date) = date_trunc(week, dateadd(week, -1, dateadd(year, -1, current_date))) THEN 'Two Weeks Ago LY'
             ELSE 'Other' END ;; }

  dimension: week_bucket{
    group_label: "Forecast Date"
    label: "z - Week Bucket"
    description: "Grouping by week, for comparing last week, to the week before, to last year"
    type: string
    # sql:  CASE WHEN ${date_week_of_year} = date_part (weekofyear,current_date) + 1 AND ${date_year} = date_part (year,current_date) THEN 'Current Week'
    #     WHEN ${date_week_of_year} = date_part (weekofyear,current_date) AND ${date_year} = date_part (year,current_date) THEN 'Last Week'
    #     WHEN ${date_week_of_year} = date_part (weekofyear,current_date) -1 AND ${date_year} = date_part (year,current_date) THEN 'Two Weeks Ago'
    #     WHEN ${date_week_of_year} = date_part (weekofyear,current_date) +1 AND ${date_year} = date_part (year,current_date) -1 THEN 'Current Week LY'
    #     WHEN ${date_week_of_year} = date_part (weekofyear,current_date) AND ${date_year} = date_part (year,current_date) -1 THEN 'Last Week LY'
    #     WHEN ${date_week_of_year} = date_part (weekofyear,current_date) -1 AND ${date_year} = date_part (year,current_date) -1 THEN 'Two Weeks Ago LY'
    #   ELSE 'Other' END ;;
    sql:  CASE WHEN ${date_week_of_year} = 1  AND ${date_year} = 2022 THEN 'Current Week'
    WHEN ${date_date} >= '2021-12-27' AND ${date_date} <= '2022-01-02' THEN 'Last Week'
    WHEN ${date_week_of_year} = 51 AND ${date_year} = 2021 THEN 'Two Weeks Ago'
    WHEN ${date_week_of_year} = 1  AND ${date_year} = 2021 THEN 'Current Week LY'
    WHEN ${date_week_of_year} = 52 AND ${date_year} = 2020 THEN 'Last Week LY'
    WHEN ${date_week_of_year} = 51 AND ${date_year} = 2020 THEN 'Two Weeks Ago LY'
    ELSE 'Other' END;;
  }


  dimension: sku_id {
    type:  string
    sql:${TABLE}.sku_id ;; }

  dimension: channel {
    type:  string
    sql:${TABLE}.channel ;; }

  dimension: account {
    type:  string
    sql:${TABLE}.account ;; }

  dimension: location {
    description: "This is used for the Owned Retail store locations."
    type:  string
    sql: case when ${TABLE}.channel = 'Owned Retail' then ${TABLE}.account else null end;;
  }

  dimension: top_customers {
    label: "Wholesale Accout Name (merged)"
    type:  string
    case: {
      when: { sql: ${TABLE}.account in ('Mattress Firm Instore','Mattress Firm Online') ;;  label: "Mattress Firm" }
      when: { sql: ${TABLE}.account in ('Furniture Row') ;;  label: "Furniture Row" }
      when: { sql: ${TABLE}.account in ('Macys Instore','Macys Online') ;;  label: "Macy's" }
      when: { sql: ${TABLE}.account in ('Sleep Country Canada') ;;  label: "Sleep Country" }
      when: { sql: ${TABLE}.account in ('Bed, Bath & Beyond') ;; label: "Bed Bath and Beyond" }
      when: { sql: ${TABLE}.account in ('Medical') ;; label: "Medical Cushions" }
      when: { sql: ${TABLE}.account in ('Trucking') ;; label: "Trucking" }
      else: "Other" } }

  dimension: account_manager {
    label: "Wholesale Accout Manager"
    type:  string
    case: {
      when: { sql: ${TABLE}.account in ('Mattress Firm Instore','Mattress Firm Online') ;;  label: "Jordan Petersen" }
      when: { sql: ${TABLE}.account in ('Furniture Row','Bed, Bath & Beyond') ;;  label: "Jodee Blue" }
      when: { sql: ${TABLE}.account in ('Macys Instore','Macys Online','Medical','Trucking') ;;  label: "Taylor Brown" }
      else: "Other" } }

  dimension: sales_manager {
    label: "Wholesale Sales Manager"
    type:  string
    case: {
      when: { sql: ${TABLE}.account in ('Mattress Firm Instore','Mattress Firm Online','Medical') ;;  label: "Daniel Hill" }
      when: { sql: ${TABLE}.account in ('Furniture Row','Bed, Bath & Beyond') ;;  label: "Mike Hessing" }
      when: { sql: ${TABLE}.account in ('Macys Instore','Macys Online','Trucking') ;;  label: "Mike Riley" }
      else: "Other" } }

  dimension: last_modified{
    type:  date_time
    sql:${TABLE}.modified ;; }

  dimension: total_units_dimension{
    type:  number
    value_format: "#,##0"
    sql:${TABLE}.total_units ;; }

  dimension: total_amount_dimension{
    type:  number
    value_format: "$#,##0"
    sql:${TABLE}.total_sales ;; }

  dimension: standard_units_dimension {
    type:  number
    value_format: "#,##0"
    sql:${TABLE}.units ;; }

  dimension: standard_amount_dimension {
    type:  number
    value_format: "$#,##0"
    sql:${TABLE}.gross_sales ;; }

  measure: total_units {
    label: "Total Units"
    type:  sum
    value_format: "#,##0"
    sql:${TABLE}.total_units ;; }

  measure: total_units_without_floor {
    label: "Total Units without Floor Units"
    type:  sum
    value_format: "#,##0"
    sql:coalesce(${TABLE}.total_units,0) - coalesce(${TABLE}.floor_units,0) ;; }

  measure: total_amount {
    label: "Total Amount"
    type:  sum
    value_format: "$#,##0"
    sql:${TABLE}.total_sales ;; }

  measure: standard_units {
    label: "Total Standard Units"
    type:  sum
    value_format: "#,##0"
    sql:${TABLE}.units ;; }

  measure: standard_amount {
    label: "Total Standard Sales"
    type:  sum
    value_format: "$#,##0"
    sql:${TABLE}.gross_sales ;; }

  measure: discount_units {
    label: "Total Discount Units"
    type:  sum
    value_format: "#,##0"
    sql:${TABLE}.discount_units;; }

  measure: discount_sales {
    label: "Total Discount Sales"
    type:  sum
    value_format: "$#,##0"
    sql:${TABLE}.discount_sales;; }

  measure: promo_units {
    label: "Total Promo Units"
    type:  sum
    value_format: "#,##0"
    sql:${TABLE}.promo_units;; }

  measure: floor_units {
    label: "Total Floor Units"
    type:  sum
    value_format: "#,##0"
    sql:${TABLE}.floor_units;; }

  measure: standard_unit_cost{
    label: "Standard Unit Cost"
    description: "Gives the selling price for non-discounted items. Calculation: Standard $ Amount/Standard Units"
    hidden: yes
    type:  number
    value_format: "$#,##0"
    sql: coalesce(${standard_amount}/ nullif(${standard_units},0),0) ;; }

  measure: full_sales_amount{
    label: "Full Sales Amount"
    description: "Takes standard unit cost * total units to give what would have been the full $ sales amount if no discounts were given"
    hidden: yes
    type:  number
    value_format: "$#,##0"
    sql: (${standard_unit_cost}*${total_units}) ;; }

  measure: forecasted_dtc_discount{
    #Under Construction by Jared
    label: "Forecasted DTC Discount"
    description: "Implied Discount Rate. Use only with DTC at SKU level. Calculation: 1-(total sales/hypothetical total sales at full price)"
    value_format: "0.0%"
    hidden: yes
    type:  number
    sql: coalesce((1-(${total_amount}/nullif(${full_sales_amount},0))),0);; }

  measure: total_amount_million {
    label: "Total Amount (millions)"
    type:  sum
    value_format: "$#,##0.00,,\" M\""
    sql:${TABLE}.total_sales ;; }

  measure: wholesale_units {
    label: "Wholesale Units"
    type:  sum
    value_format: "#,##0"
    sql: case when ${channel} = 'Wholesale' then ${total_units_dimension} else 0 end ;;}

  measure: wholesale_amount {
    label: "Wholesale Amount"
    type:  sum
    value_format: "$#,##0"
    sql: case when ${channel} = 'Wholesale' then ${total_amount_dimension} else 0 end ;;}

  measure: dtc_units {
    label: "DTC Units"
    description: "Excludes Amazon and Ebay"
    type:  sum
    value_format: "#,##0"
    sql: case when ${account} = 'Website' then ${total_units_dimension} else 0 end ;;}

  measure: dtc_amount {
    label: "DTC Amount"
    description: "Excludes Amazon and Ebay"
    type:  sum
    value_format: "$#,##0"
    sql: case when ${account} = 'Website' then ${total_amount_dimension} else 0 end ;;}

  measure: MF_Instore_Units {
    label: "Wholesale MF Instore Units"
    type:  sum
    value_format: "#,##0"
    sql: case when ${account} = 'Mattress Firm - Warehouse' then ${total_units_dimension} else 0 end ;;}

  measure: MF_Instore_Amount {
    label: "Wholesale MF Instore Amount"
    type:  sum
    value_format: "$#,##0"
    sql: case when ${account} = 'Mattress Firm - Warehouse' then ${total_amount_dimension} else 0 end ;;}

  measure: MF_Online_Units {
    label: "Wholesale MF Online Units"
    type:  sum
    value_format: "#,##0"
    sql: case when ${account} = 'Mattress Firm - Drop Ship' then ${total_units_dimension} else 0 end ;;}

  measure: MF_Online_Amount {
    label: "Wholesale MF Online Amount"
    type:  sum
    value_format: "$#,##0"
    sql: case when ${account} = 'Mattress Firm - Drop Ship' then ${total_amount_dimension} else 0 end ;;}

  measure: FR_Units {
    label: "Wholesale FR Units"
    type:  sum
    value_format: "#,##0"
    sql: case when ${account} = 'Furniture Row Warehouse' then ${total_units_dimension} else 0 end ;;}

  measure: FR_Amount {
    label: "Wholesale FR Amount"
    type:  sum
    value_format: "$#,##0"
    sql: case when ${account} = 'Furniture Row Warehouse' then ${total_amount_dimension} else 0 end ;;}

  measure: Macys_Instore_Units {
    label: "Wholesale Macys Instore Units"
    type:  sum
    value_format: "#,##0"
    sql: case when ${account} = 'Macys - Warehouse' then ${total_units_dimension} else 0 end ;;}

  measure: Macys_Instore_Amount {
    label: "Wholesale Macys Instore Amount"
    type:  sum
    value_format: "$#,##0"
    sql: case when ${account} = 'Macys - Warehouse' then ${total_amount_dimension} else 0 end ;;}

  measure: Macys_Online_Units {
    label: "Wholesale Macys Online Units"
    type:  sum
    value_format: "#,##0"
    sql: case when ${account} = 'Macys - Dropship' then ${total_units_dimension} else 0 end ;;}

  measure: Macys_Online_Amount {
    label: "Wholesale Macy Online Amount"
    type:  sum
    value_format: "$#,##0"
    sql: case when ${account} = 'Macys - Dropship' then ${total_amount_dimension} else 0 end ;;}

  measure: SCC_Units {
    label: "Wholesale SCC Units"
    type:  sum
    value_format: "#,##0"
    sql: case when ${account} ilike '%Sleep Country%' then ${total_units_dimension} else 0 end ;;}

  measure: SCC_Amount {
    label: "Wholesale SCC Amount"
    type:  sum
    value_format: "$#,##0"
    sql: case when ${account} ilike '%Sleep Country%' then ${total_amount_dimension} else 0 end ;;}

  measure: BBB_Units {
    label: "Wholesale BBB Units"
    type:  sum
    value_format: "#,##0"
    sql: case when ${account} = 'Bed Bath & Beyond - In Store' then ${total_units_dimension} else 0 end ;;}

  measure: BBB_Amount {
    label: "Wholesale BBB Amount"
    type:  sum
    value_format: "$#,##0"
    sql: case when ${account} = 'Bed Bath & Beyond - In Store' then ${total_amount_dimension} else 0 end ;;}

  measure: Medical_Units {
    label: "Wholesale Medical Units"
    type:  sum
    value_format: "#,##0"
    sql: case when ${account} in ('Med', 'Access Health','Direct Supply','GelTechCo', 'Marketing Concepts', 'Medical - Other', 'Medline - Dropship', 'Medline Industries', 'Medline Industries - Warehouse','Nimacare', 'Proline Medical','The Posture Works', 'Wellco') then ${total_units_dimension} else 0 end ;;}

  measure: Medical_Amount {
    label: "Wholesale Medical Amount"
    type:  sum
    value_format: "$#,##0"
    sql: case when ${account} in ('Med', 'Access Health','Direct Supply','GelTechCo', 'Marketing Concepts', 'Medical - Other', 'Medline - Dropship', 'Medline Industries', 'Medline Industries - Warehouse','Nimacare', 'Proline Medical','The Posture Works', 'Wellco') then ${total_amount_dimension} else 0 end ;;}

  measure: Trucking_Units {
    label: "Wholesale Trucking Units"
    type:  sum
    value_format: "#,##0"
    sql: case when ${account} in ('Truck', 'Cushion Portal', 'DAS Inc') then ${total_units_dimension} else 0 end ;;}

  measure: Trucking_Amount {
    label: "Wholesale Trucking Amount"
    type:  sum
    value_format: "$#,##0"
    sql: case when ${account} in ('Truck', 'Cushion Portal', 'DAS Inc') then ${total_amount_dimension} else 0 end ;;}

  measure: BD_Units {
    label: "Wholesale Bloomingdales Units"
    type:  sum
    value_format: "#,##0"
    sql: case when ${account} in ('Bloomingdales - Dropship', 'Bloomingdales - Warehouse') then ${total_units_dimension} else 0 end ;;}

  measure: BD_Amount {
    label: "Wholesale Bloomingdales Amount"
    type:  sum
    value_format: "$#,##0"
    sql: case when ${account} in ('Bloomingdales - Dropship', 'Bloomingdales - Warehouse') then ${total_amount_dimension} else 0 end ;;}

  measure: HOM_Units {
    label: "Wholesale HOM Units"
    type:  sum
    value_format: "#,##0"
    sql: case when ${account} = 'HOM Furniture - Warehouse' then ${total_units_dimension} else 0 end ;;}

  measure: hom_Amount {
    label: "Wholesale HOM Amount"
    type:  sum
    value_format: "$#,##0"
    sql: case when ${account} = 'HOM Furniture - Warehouse' then ${total_amount_dimension} else 0 end ;;}

  measure: amazon_units {
    label: "Amazon Units"
    type:  sum
    value_format: "#,##0"
    sql: case when ${account} in ('AMAZON-US', 'AMAZON-CA','Amazon') then ${total_units_dimension} else 0 end ;;}

  measure: amazon_amount {
    label: "Amazon Amount"
    type:  sum
    value_format: "$#,##0"
    sql: case when ${account} in ('AMAZON-US', 'AMAZON-CA','Amazon') then ${total_amount_dimension} else 0 end ;;}

  measure: retail_units {
    type:  sum
    value_format: "#,##0"
    sql: case when ${channel} = 'Owned Retail' then ${total_units_dimension} else 0 end ;;}

  measure: retail_amount {
    type:  sum
    value_format: "$#,##0"
    sql: case when ${channel} = 'Owned Retail' then ${total_amount_dimension} else 0 end ;;}

  measure: to_date {
    label: "Goal to Date"
    description: "This field is for formatting on (week/month/quarter/year) to date reports"
    type: sum
    value_format: "#,##0"
    sql: case when ${TABLE}.forecast < current_date then ${total_amount_dimension} else 0 end;; }

  measure: total_sku_ids {
    hidden: yes
    type: count_distinct
    sql: ${sku_id} ;;
  }

  dimension: primary_key {
    primary_key: yes
    sql: CONCAT(${sku_id}, ${date_date}, ${account}, ${channel}, ${version}) ;;
    hidden: yes
  }

}
