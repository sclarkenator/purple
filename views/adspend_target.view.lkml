view: adspend_target {
  sql_table_name: CSV_UPLOADS.ADSPEND_TARGET ;;

  dimension: ad_target_pk {
    hidden: yes
    type: string
    primary_key: yes
    sql: ${medium}||${target_date} ;;
  }

  measure: amount {
    label: "Spend target"
    description: "This field is only available in total or when breaking out spend by medium"
    view_label: "Daily Adspend"
    value_format: "$#,##0"
    type: sum
    sql: ${TABLE}."AMOUNT" ;;
  }

  dimension_group: target {
    view_label: "Daily Adspend"
    label: "   Target"
    description: "Use these dates if you are using the adspend target $, otherwise, use ad date."
    type: time
    timeframes: [date, day_of_week, day_of_month, week, week_of_year, month, month_name, quarter, quarter_of_year, year]
    sql: ${TABLE}.date ;;
  }

  dimension: medium {
    hidden:  yes
    type: string
    sql: ${TABLE}."MEDIUM" ;;
  }


}
