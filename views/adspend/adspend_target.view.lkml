view: adspend_target {
  sql_table_name: CSV_UPLOADS.ADSPEND_TARGETS ;;

  dimension: ad_target_pk {
    hidden: yes
    type: string
    primary_key: yes
    sql: ${medium}||${target_date} ;;
  }

  dimension_group: target {
    view_label: "Daily Adspend"
    label: "   Target"
    #hidden: yes
    description: "Use these dates if you are using the adspend target $, otherwise, use ad date."
    type: time
    timeframes: [date, day_of_week, day_of_month, week, week_of_year, month, month_name, quarter, quarter_of_year, year]
    sql: ${TABLE}.date ;;
  }

  dimension: Before_today{
    view_label: "Daily Adspend"
    group_label: "   Target Date"
    label: "z - Is Before Today (mtd)"
    description: "This field is for formatting on (week/month/quarter/year) to date reports"
    type: yesno
    sql: ${TABLE}.date < current_date;; }

  dimension: medium {
    label: "Target Medium"
    group_label: "Target"
    description: "The Medium from the target import"
    view_label: "Daily Adspend"
    #hidden:  yes
    type: string
    sql: nvl(${TABLE}.medium, ${daily_adspend.medium}) ;;
  }

  measure: amount {
    label: "Spend Target ($)"
    group_label: "Target"
    description: "This field is only available in total or when breaking out spend by channel or platform"
    view_label: "Daily Adspend"
    value_format: "$#,##0"
    type: sum
    sql: ${TABLE}.amount ;;
  }

  measure: spend_k {
    label: "Spend Target ($K)"
    group_label: "Target"
    description: "This field is only available in total or when breaking out spend by channel or platform"
    view_label: "Daily Adspend"
    value_format: "$#,##0,\" K\""
    type: sum
    sql: ${TABLE}.amount ;;
  }



}
