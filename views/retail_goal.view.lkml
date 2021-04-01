#--------------------------------------
# Create By: Blake Walton 2020-11-17
#--------------------------------------
view: retail_goal {
  sql_table_name: analytics.retail.retail_goal
    ;;

  dimension: PK {
    primary_key: yes
    type: string
    hidden: yes
    sql: ${goal_date}||-||${location} ;;
  }

  dimension_group: goal {
    description: "Source: csv_file.retail_goal"
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      month_num,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}."GOAL_DATE" ;;
  }

  dimension: location {
    description: "Owned Retail Store Location Name. Source: csv_file.retail_goal"
    type: string
    sql: case when ${TABLE}."LOCATION" = 'Salt Lake' then 'UT - Factory Outlet SLC'
    when ${TABLE}."LOCATION" = 'San Diego' then 'CA - Fashion Valley'
    when ${TABLE}."LOCATION" = 'Lehi' then 'UT - Lehi HQ'
    when ${TABLE}."LOCATION" = 'Austin' then 'TX - Domain Northside'
    when ${TABLE}."LOCATION" = 'Lynnwood' then 'WA - Alderwood Mall'
    when ${TABLE}."LOCATION" = 'Columbus' then 'OH - Easton Town Center'
    when ${TABLE}."LOCATION" = 'Santa Clara' then 'CA - Valley Fair'
    when ${TABLE}."LOCATION" = 'Santa Monica' then 'CA - Santa Monica Place'
    when ${TABLE}."LOCATION" = 'Tysons' then 'VA - Tysons Corner Center'
    else ${TABLE}."LOCATION" end;;
  }

  measure: beds {
    description: "Source: csv_file.retail_goal"
    type: sum
    value_format: "#,##0"
    sql: ${TABLE}."BEDS" ;;
  }

  measure: revenue {
    description: "Source: csv_file.retail_goal"
    type: sum
    value_format:  "$#,##0"
    sql: ${TABLE}."REVENUE" ;;
  }

}
