view: forecast_combined_monthly_rollup {
  derived_table: {
    explore_source: forecast_combined {
      column: account {}
      column: channel {}
      column: sku_id {}
      column: date_month {}
      column: date_quarter {}
      column: date_year {}
      column: date_month_name {}
      column: amount { field: forecast_combined.total_amount }
    }
    datagroup_trigger: pdt_refresh_6am
  }

  dimension: primary_key {
    primary_key: yes
    sql: CONCAT(${sku_id}, ${date_month}, ${account}, ${channel}, ${sku_id}) ;;
    hidden: yes
  }

  dimension: account {}

  dimension: channel {}

  dimension: sku_id {}

  dimension: date_month {
    group_label: "Forecast Date"
    label: "Month"
    type: date_month
  }

  dimension: date_quarter {
    group_label: "Forecast Date"
    label: "Quarter"
    type: date_quarter
  }

  dimension: date_year {
    group_label: "Forecast Date"
    label: "Year"
    type: date_year
  }

  dimension: date_month_name {
    group_label: "Forecast Date"
    label: "Month Name"
    type: date_month_name
  }

  dimension: amount {
    hidden: yes
    value_format: "$#,##0"
    type: number
  }

  measure: total_amount {
    type: sum
    sql: ${amount} ;;
    value_format: "$#,##0"
  }
}
