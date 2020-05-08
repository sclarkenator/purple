view: magazine_numbers {
  sql_table_name: "CSV_UPLOADS"."MAGAZINE_NUMBERS"
    ;;

  dimension: campaign {
    description: "Promotion Type"
    type: string
    sql: ${TABLE}."CAMPAIGN" ;;
  }

  dimension: code {
    description: "Discount Code"
    type: string
    sql: ${TABLE}."CODE" ;;
  }

  dimension_group: launch {
    description: "Date when Campaign was launched"
    type: time
    timeframes: [
      raw,
      date,
      day_of_month,
      day_of_week,
      day_of_year,
      week,
      week_of_year,
      month,
      month_name,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}."LAUNCH_DATE" ;;
  }

  dimension: magazine {
    description: "Magazine Name"
    type: string
    sql: ${TABLE}."MAGAZINE" ;;
  }

  dimension: phone_number {
    description: "Unique phone number listed in magazine"
    type: string
    sql: ${TABLE}."PHONE_NUMBER" ;;
  }

  measure: spend {
    description: "Ad Spend for Magazine Promotion"
    type: sum
    sql: ${TABLE}."SPEND" ;;
  }

  measure: count {
    type: count
    hidden: yes
    drill_fields: []
  }
}
