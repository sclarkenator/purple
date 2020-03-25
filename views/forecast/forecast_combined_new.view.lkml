view: forecast_combined_new {
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
    #hidden:  yes
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

  measure: total_units {
    label: "Total Units"
    type:  sum
    value_format: "#,##0"
    sql:${TABLE}.units ;; }

  measure: total_amount {
    label: "Gross Sales"
    type:  sum
    value_format: "$#,##0.00"
    sql:${TABLE}.gross_sales ;; }

  measure: discount_units {
    label: "Discount Units"
    type:  sum
    value_format: "#,##0"
    sql:${TABLE}.discount_units;; }

  measure: discount_sales {
    label: "Discount Sales"
    type:  sum
    value_format: "$#,##0.00"
    sql:${TABLE}.discount_sales;; }

  measure: promo_units {
    label: "Promo Units"
    type:  sum
    value_format: "#,##0"
    sql:${TABLE}.promo__units;; }

  measure: total_amount_million {
    label: "Gross Sales (millions)"
    type:  sum
    value_format: "$#,##0.00,,\" M\""
    sql:${TABLE}.gross_sales ;; }

  measure: wholesale_units {
    label: "Total Wholesale Units"
    type:  sum
    value_format: "#,##0"
    sql: case when ${channel} = 'Wholesale' then ${total_units} else 0 end ;;}

  measure: wholesale_amount {
    label: "Total Wholesale Amount"
    type:  sum
    value_format: "$#,##0.00"
    sql: case when ${channel} = 'Wholesale' then ${total_amount} else 0 end ;;}

  measure: dtc_units {
    label: "Total DTC Units"
    type:  sum
    value_format: "#,##0"
    sql: case when ${channel} = 'DTC' then ${total_units} else 0 end ;;}

  measure: dtc_amount {
    label: "Total DTC Amount"
    type:  sum
    value_format: "$#,##0.00"
    sql: case when ${channel} = 'DTC' then ${total_amount} else 0 end ;;}

  measure: MF_Instore_Units {
    label: "Wholesale MF Instore Units"
    type:  sum
    value_format: "#,##0"
    sql: case when ${account} = 'MFRM_Ware' then ${total_units} else 0 end ;;}

  measure: MF_Instore_Amount {
    label: "Wholesale MF Instore Amount"
    type:  sum
    value_format: "$#,##0.00"
    sql: case when ${account} = 'MFRM_Ware' then ${total_amount} else 0 end ;;}

  measure: MF_Online_Units {
    label: "Wholesale MF Online Units"
    type:  sum
    value_format: "#,##0"
    sql: case when ${account} = 'MFRM_DTC' then ${total_units} else 0 end ;;}

  measure: MF_Online_Amount {
    label: "Wholesale MF Online Amount"
    type:  sum
    value_format: "$#,##0.00"
    sql: case when ${account} = 'MFRM_DTC' then ${total_amount} else 0 end ;;}

  measure: FR_Units {
    label: "Wholesale FR Units"
    type:  sum
    value_format: "#,##0"
    sql: case when ${account} = 'FR' then ${total_units} else 0 end ;;}

  measure: FR_Amount {
    label: "Wholesale FR Amount"
    type:  sum
    value_format: "$#,##0.00"
    sql: case when ${account} = 'FR' then ${total_amount} else 0 end ;;}

  measure: Macys_Instore_Units {
    label: "Wholesale Macys Instore Units"
    type:  sum
    value_format: "#,##0"
    sql: case when ${account} = 'Macys_Ware' then ${total_units} else 0 end ;;}

  measure: Macys_Instore_Amount {
    label: "Wholesale Macys Instore Amount"
    type:  sum
    value_format: "$#,##0.00"
    sql: case when ${account} = 'Macys_Ware' then ${total_amount} else 0 end ;;}

  measure: Macys_Online_Units {
    label: "Wholesale Macys Online Units"
    type:  sum
    value_format: "#,##0"
    sql: case when ${account} = 'Macys_DTC' then ${total_units} else 0 end ;;}

  measure: Macys_Online_Amount {
    label: "Wholesale Macy Online Amount"
    type:  sum
    value_format: "$#,##0.00"
    sql: case when ${account} = 'Macys_DTC' then ${total_amount} else 0 end ;;}

  measure: SCC_Units {
    label: "Wholesale SCC Units"
    type:  sum
    value_format: "#,##0"
    sql: case when ${account} = 'SCC' then ${total_units} else 0 end ;;}

  measure: SCC_Amount {
    label: "Wholesale SCC Amount"
    type:  sum
    value_format: "$#,##0.00"
    sql: case when ${account} = 'SCC' then ${total_amount} else 0 end ;;}

  measure: BBB_Units {
    label: "Wholesale BBB Units"
    type:  sum
    value_format: "#,##0"
    sql: case when ${account} = 'BBB' then ${total_units} else 0 end ;;}

  measure: BBB_Amount {
    label: "Wholesale BBB Amount"
    type:  sum
    value_format: "$#,##0.00"
    sql: case when ${account} = 'BBB' then ${total_amount} else 0 end ;;}

  measure: Medical_Units {
    label: "Wholesale Medical Units"
    type:  sum
    value_format: "#,##0"
    sql: case when ${account} = 'Med' then ${total_units} else 0 end ;;}

  measure: Medical_Amount {
    label: "Wholesale Medical Amount"
    type:  sum
    value_format: "$#,##0.00"
    sql: case when ${account} = 'Med' then ${total_amount} else 0 end ;;}

  measure: Trucking_Units {
    label: "Wholesale Trucking Units"
    type:  sum
    value_format: "#,##0"
    sql: case when ${account} = 'Truck' then ${total_units} else 0 end ;;}

  measure: Trucking_Amount {
    label: "Wholesale Trucking Amount"
    type:  sum
    value_format: "$#,##0.00"
    sql: case when ${account} = 'Truck' then ${total_amount} else 0 end ;;}

  measure: Other_Units {
    label: "Wholesale Other Units"
    type:  sum
    value_format: "#,##0"
    sql: case when ${account} = 'Other' then ${total_units} else 0 end ;;}

  measure: Other_Amount {
    label: "Wholesale Other Amount"
    type:  sum
    value_format: "$#,##0.00"
    sql: case when ${account} = 'Other' then ${total_amount} else 0 end ;;}

  measure: BD_Units {
    label: "Wholesale Bloomingdales Units"
    type:  sum
    value_format: "#,##0"
    sql: case when ${account} in ('Bloom_DTC', 'Bloom_Ware') then ${total_units} else 0 end ;;}

  measure: BD_Amount {
    label: "Wholesale Bloomingdales Amount"
    type:  sum
    value_format: "$#,##0.00"
    sql: case when ${account} in ('Bloom_DTC', 'Bloom_Ware') then ${total_amount} else 0 end ;;}

  measure: HOM_Units {
    label: "Wholesale HOM Units"
    type:  sum
    value_format: "#,##0"
    sql: case when ${account} = 'HOM' then ${total_units} else 0 end ;;}

  measure: hom_Amount {
    label: "Wholesale HOM Amount"
    type:  sum
    value_format: "$#,##0.00"
    sql: case when ${account} = 'HOM' then ${total_amount} else 0 end ;;}

  measure: amazon_units {
    label: "Amazon Units"
    type:  sum
    value_format: "#,##0"
    sql: case when ${account} in ('AMAZON-US', 'AMAZON-CA') then ${total_units} else 0 end ;;}

  measure: amazon_amount {
    label: "Amazon Amount"
    type:  sum
    value_format: "$#,##0.00"
    sql: case when ${account} in ('AMAZON-US', 'AMAZON-CA') then ${total_amount} else 0 end ;;}

  measure: retail_units {
    type:  sum
    value_format: "#,##0"
    sql: case when ${account} = 'Owned Retail' then ${total_units} else 0 end ;;}

  measure: retail_amount {
    type:  sum
    value_format: "$#,##0.00"
    sql: case when ${account} = 'Owned Retail' then ${total_amount} else 0 end ;;}

  measure: to_date {
    label: "Total Goal to Date"
    description: "This field is for formatting on (week/month/quarter/year) to date reports"
    type: sum
    value_format: "#,##0"
    sql: case when ${TABLE}.forecast < current_date then ${TABLE}.total_amount else 0 end;; }


  dimension: primary_key {
    primary_key: yes
    sql: CONCAT(${sku_id}, ${date_date}) ;;
    hidden: yes
  }

}
