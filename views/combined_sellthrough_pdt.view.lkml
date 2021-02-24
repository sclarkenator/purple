######################################################
#   MF Sell-Through
#   https://purple.looker.com/dashboards-next/4045
######################################################

view: mf_pdt {
  derived_table: {
    explore_source: mattress_firm_sales {
      column: final_units {}
      column: finalized_date {}
      column: zipcode { field: mattress_firm_store_details.zipcode }
      column: category_name { field: item.category_name }
      filters: {field: mattress_firm_sales.finalized_date value: "after 2018/01/01"}
    }
  }
  dimension: final_units {type: number}
  dimension: finalized_date {type: date}
  dimension: zipcode {type: zipcode}
  dimension: category_name {type: string}
}

######################################################
#   DTC/OR Sell-Through
#   https://purple.looker.com/dashboards-next/4045
######################################################

view: dtc_or_pdt {
  derived_table: {
    explore_source: sales_order_line {
      column: created_date {}
      column: channel2 { field: sales_order.channel2 }
      column: category_name { field: item.category_name }
      column: zip {}
      column: total_units {}
      filters: {field: sales_order_line.created_date value: "after 2016/01/01"}
      filters: {field: sales_order.is_exchange_upgrade_warranty value: ""}
      filters: {field: sales_order.channel value: "DTC,Owned Retail"}
      filters: {field: cancelled_order.is_cancelled value: "No"}
    }
  }
  dimension: created_date {type: date}
  dimension: channel2 {type: string}
  dimension: category_name {type: string}
  dimension: zip {type: zipcode}
  dimension: total_units {type: number}
}

######################################################
#   CREATING FINAL TABLE
#   https://purple.looker.com/dashboards-next/4045
######################################################

view: combined_sellthrough_pdt {
  label: "Combined Sell-Through PDT"
 derived_table: {
    sql:
    select finalized_date::date as date
      , zipcode::string as zip
      , category_name
      , null as channel
      , final_units as total_units
    from ${mf_pdt.SQL_TABLE_NAME}
    union all
    select created_date::date
      , zip::string
      , category_name
      , channel2 as channel
      , total_units
    from ${dtc_or_pdt.SQL_TABLE_NAME};;
  }

  dimension: date {
   hidden: yes
   type: date
    sql: ${TABLE}.date::date ;;
  }
  dimension_group: date {
    label: " Order"
    type: time
    timeframes: [raw, date, day_of_week, day_of_week_index, day_of_month, day_of_year, week, week_of_year, month, month_name, quarter, quarter_of_year, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.date::date ;;
  }

  dimension: channel {
    description:  "Which Netsuite Channel was the order processed through (DTC, Wholesale, Owned Retail). Source: netsuite.sales_order"
    type: string
    sql: case when ${TABLE}.channel is null then 'Wholesale' else ${TABLE}.channel end ;;
  }

  dimension: zipcode {
    description:  "Which Netsuite Channel was the order processed through (DTC, Wholesale, Owned Retail, etc). Source: netsuite.sales_order"
    type: string
    sql: ${TABLE}.zip ;;
  }

  dimension: category {
    description:  "Mattress/Bedding/Bases/Seating/Other. Source: netsuite.item"
    type: string
    sql: ${TABLE}.category_name ;;
  }

  measure: total_units {
    description: "Total units purchased, excludes cancelled orders. Accounts for wholesale returned. Source:netsuite.sales_order_line"
    type: sum
    sql: ${TABLE}.total_units ;;
  }

}
