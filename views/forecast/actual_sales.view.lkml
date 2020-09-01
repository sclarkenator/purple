  view: actual_sales {
    derived_table: {
      explore_source: sales_order_line {
        column: created_date {}
        column: ship_order_by_date { field: sales_order.ship_order_by_date}
        column: item_id { field: item.item_id }
        column: sku_id { field: item.sku_id }
        column: channel { field: sales_order.channel }
        column: total_gross_Amt_non_rounded {}
        column: total_units {}
        column: source { field: sales_order.source }
        filters: {
          field: sales_order.channel
          value: ""
        }
        filters: {
          field: item.merchandise
          value: ""
        }
        filters: {
          field: item.finished_good_flg
          value: "Yes"
        }
        filters: {
          field: item.modified
          value: "Yes"
        }
      }
      datagroup_trigger: pdt_refresh_6am
    }
    dimension: PK {
      primary_key: yes
      hidden: yes
      sql: CONCAT(${TABLE}.created_date,${TABLE}.ship_order_by_date, ${sku_id}, ${channel},${source}) ;;
    }
    dimension_group: created {
      hidden: no
      label: "Sales Order     Order Date"
      description: "Time and date order was placed. Source: netsuite.sales_order_line"
      type: time
      timeframes: [raw, hour_of_day, date, day_of_week, day_of_week_index, day_of_month, day_of_year, week, week_of_year, month, month_name, quarter, quarter_of_year, year]
      sql: ${TABLE}.created_date ;;
    }
    dimension_group: ship_order_by {
      hidden: yes
      label: "Fulfillment Ship by or Order Date"
      description: "Using ship by date unless blank then order date. Source: netsuite.sales_order"
      type: time
      timeframes: [raw, hour_of_day, date, day_of_week, day_of_week_index, day_of_month, day_of_year, week, week_of_year, month, month_name, quarter, quarter_of_year, year]
      sql: ${TABLE}.ship_order_by_date ;;
    }
    dimension: item_id {
      hidden: no
      label: "Product Item ID"
      description: "Source: netsuite.item"
    }
    dimension: sku_id {
      hidden: no
      label: "Product SKU ID"
      description: "SKU ID for item (XX-XX-XXXXXX). Source: netsuite.item"
    }
    dimension: channel {
      hidden: yes
      label: "Sales Order Channel Filter"
    }
    dimension: gross_Amt_non_rounded {
      hidden: yes
      type: number
      sql:  ${TABLE}.total_gross_Amt_non_rounded ;;
    }
    dimension: units {
      hidden: yes
      type: number
      sql:  ${TABLE}.total_units ;;
    }
    dimension: source {
      description: "System where order was placed. Source:netsuite.sales_order"
    }
    measure: total_gross_Amt_non_rounded {
      group_label: "Gross Sales"
      label:  "Gross Sales ($)"
      description:  "Total the customer paid, excluding tax and freight, in $. Source:netsuite.sales_order_line"
      type: sum
      value_format: "$#,##0"
      sql:  ${gross_Amt_non_rounded} ;;
    }
    measure: total_gross_Amt_amazon {
      group_label: "Gross Sales"
      label:  "Gross Sales ($) Amazon"
      description:  "Total the customer paid, excluding tax and freight, in $. Source:netsuite.sales_order_line"
      filters: [source: "Amazon-FBM-US, Amazon-FBA-US, Amazon-FBA-CA"]
      type: sum
      value_format: "$#,##0"
      sql:  ${gross_Amt_non_rounded} ;;
    }
    measure: total_gross_Amt_dtc {
      group_label: "Gross Sales"
      label:  "Gross Sales ($) DTC"
      description:  "Total the customer paid, excluding tax and freight, in $. Source:netsuite.sales_order_line"
      filters: [channel: "DTC"]
      type: sum
      value_format: "$#,##0"
      sql:  ${gross_Amt_non_rounded} ;;
    }
    measure: total_gross_Amt_retail {
      group_label: "Gross Sales"
      label:  "Gross Sales ($) Retail"
      description:  "Total the customer paid, excluding tax and freight, in $. Source:netsuite.sales_order_line"
      filters: [channel: "Owned Retail"]
      type: sum
      value_format: "$#,##0"
      sql:  ${gross_Amt_non_rounded} ;;
    }
    measure: total_gross_Amt_wholesale {
      group_label: "Gross Sales"
      label:  "Gross Sales ($) Wholesale"
      description:  "Total the customer paid, excluding tax and freight, in $. Source:netsuite.sales_order_line"
      filters: [channel: "Wholesale"]
      type: sum
      value_format: "$#,##0"
      sql:  ${gross_Amt_non_rounded} ;;
    }
    measure: total_units {
      group_label: "Gross Sales"
      label:  "Gross Sales (units)"
      description: "Total units purchased, before returns and cancellations. Source:netsuite.sales_order_line"
      type: sum
      sql:  ${units} ;;
    }
    measure: total_units_amazon {
      group_label: "Gross Sales"
      label:  "Gross Sales (units) Amazon"
      description: "Total units purchased, before returns and cancellations. Source:netsuite.sales_order_line"
      filters: [source: "Amazon-FBM-US, Amazon-FBA-US, Amazon-FBA-CA"]
      type: sum
      sql:  ${units} ;;
    }
    measure: total_units_dtc {
      group_label: "Gross Sales"
      label:  "Gross Sales (units) DTC"
      description: "Total units purchased, before returns and cancellations. Source:netsuite.sales_order_line"
      filters: [channel: "DTC"]
      type: sum
      sql:  ${units} ;;
    }
    measure: total_units_retail {
      group_label: "Gross Sales"
      label:  "Gross Sales (units) Owned Retail"
      description: "Total units purchased, before returns and cancellations. Source:netsuite.sales_order_line"
      filters: [channel: "Owned Retail"]
      type: sum
      sql:  ${units} ;;
    }
    measure: total_units_wholesale {
      group_label: "Gross Sales"
      label:  "Gross Sales (units) Wholesale"
      description: "Total units purchased, before returns and cancellations. Source:netsuite.sales_order_line"
      filters: [channel: "Wholesale"]
      type: sum
      sql:  ${units} ;;
    }
    measure: total_sku_ids {
      hidden: yes
      type: count_distinct
      sql: ${sku_id} ;;
    }
  }
