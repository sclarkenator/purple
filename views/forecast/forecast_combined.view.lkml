
view: forecast_combined {
sql_table_name: sales.forecast ;;


  dimension_group: date {
    label: "Forecast"
    type: time
    timeframes: [date, day_of_week, day_of_month, week, week_of_year, month, month_name, quarter, quarter_of_year, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.forecast ;; }

  dimension: Before_today{
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

  dimension: week_bucket{
    group_label: "Forecast Date"
    label: "z - Week Bucket"
    description: "Grouping by week, for comparing last week, to the week before, to last year"
    type: string
     sql:  CASE WHEN date_trunc(week, ${TABLE}.forecast::date) = date_trunc(week, current_date) THEN 'Current Week'
             WHEN date_trunc(week, ${TABLE}.forecast::date) = dateadd(week, -1, date_trunc(week, current_date)) THEN 'Last Week'
             WHEN date_trunc(week, ${TABLE}.forecast::date) = dateadd(week, -2, date_trunc(week, current_date)) THEN 'Two Weeks Ago'
             WHEN date_trunc(week, ${TABLE}.forecast::date) = date_trunc(week, dateadd(week, 1, dateadd(year, -1, current_date))) THEN 'Current Week LY'
             WHEN date_trunc(week, ${TABLE}.forecast::date) = date_trunc(week, dateadd(week, 0, dateadd(year, -1, current_date))) THEN 'Last Week LY'
             WHEN date_trunc(week, ${TABLE}.forecast::date) = date_trunc(week, dateadd(week, -1, dateadd(year, -1, current_date))) THEN 'Two Weeks Ago LY'
             ELSE 'Other' END ;; }

  dimension: sku_id {
    type:  string
    sql:${TABLE}.sku_id ;; }

  dimension: channel {
    type:  string
    sql:${TABLE}.channel ;; }

  dimension: account {
    type:  string
    sql:${TABLE}.account ;; }

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

  measure: standard_unit_cost{
    label: "Standard Unit Cost"
    description: "Gives the selling price for non-discounted items. Calculation: Standard $ Amount/Standard Units"
    hidden: no
    type:  number
    value_format: "$#,##0"
    sql: coalesce(${standard_amount}/ nullif(${standard_units},0),0) ;; }

  measure: full_sales_amount{
    label: "Full Sales Amount"
    description: "Takes standard unit cost * total units to give what would have been the full $ sales amount if no discounts were given"
    hidden: no
    type:  number
    value_format: "$#,##0"
    sql: (${standard_unit_cost}*${total_units}) ;; }

  measure: forecasted_dtc_discount{
    label: "Forecasted DTC Discount"
    description: "Implied Discount Rate. Use only with DTC at SKU level. Calculation: 1-(total sales/hypothetical total sales at full price)"
    value_format: "0.0%"
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
    sql: case when ${account} = 'Sleep Country' then ${total_units_dimension} else 0 end ;;}

  measure: SCC_Amount {
    label: "Wholesale SCC Amount"
    type:  sum
    value_format: "$#,##0"
    sql: case when ${account} = 'Sleep Country' then ${total_amount_dimension} else 0 end ;;}

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
    sql: case when ${account} in ('AMAZON-US', 'AMAZON-CA') then ${total_units_dimension} else 0 end ;;}

  measure: amazon_amount {
    label: "Amazon Amount"
    type:  sum
    value_format: "$#,##0"
    sql: case when ${account} in ('AMAZON-US', 'AMAZON-CA') then ${total_amount_dimension} else 0 end ;;}

  measure: retail_units {
    type:  sum
    value_format: "#,##0"
    sql: case when ${account} = 'Owned Retail' then ${total_units_dimension} else 0 end ;;}

  measure: retail_amount {
    type:  sum
    value_format: "$#,##0"
    sql: case when ${account} = 'Owned Retail' then ${total_amount_dimension} else 0 end ;;}

  measure: to_date {
    label: "Goal to Date"
    description: "This field is for formatting on (week/month/quarter/year) to date reports"
    type: sum
    value_format: "#,##0"
    sql: case when ${TABLE}.forecast < current_date then ${total_amount_dimension} else 0 end;; }


  dimension: primary_key {
    primary_key: yes
    sql: CONCAT(${sku_id}, ${date_date}, ${account}, ${channel}) ;;
    hidden: yes
  }

}
