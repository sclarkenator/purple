view: wholesale_stores {
  sql_table_name: analytics.sales.WHOLESALE_STORE ;;

  dimension: Customer {
    label: "Customer"
    type: string
    sql: ${TABLE}.customer ;;
  }

  dimension: Store_name {
    label: "Store Name"
    type: string
    sql: ${TABLE}.location ;;
  }

  dimension: Address {
    label: "Street Address"
    group_label: "Location"
    type: string
    sql: ${TABLE}.Street ;;
  }

  dimension: City {
    label: "City"
    group_label: "Location"
    type: string
    sql: ${TABLE}.city ;;
  }

  dimension: State {
    label: "State"
    group_label: "Location"
    type: string
    map_layer_name: us_states
  # sql: ${TABLE}.State
   sql: case when ${TABLE}.State = 'California' then 'CA'
        when ${TABLE}.State = 'District of Columbia' then 'DC'
        when ${TABLE}.State = 'Illinois' then 'IL'
        when ${TABLE}.State = 'Maryland' then 'MD'
        when ${TABLE}.State = 'New York' then 'NY'
        when ${TABLE}.State = 'Pennsylvania' then 'PA'
        when ${TABLE}.State = 'Texas' then 'TX'
        when ${TABLE}.State = 'Virginia' then 'VA'
        else ${TABLE}.State end ;;
  }

  dimension: zip {
    label: "Zip Code"
    group_label: "Location"
    type: zipcode
    map_layer_name: us_zipcode_tabulation_areas
    sql: ${TABLE}.zip ;;
  }

  dimension: country {
    label: "Country"
    group_label: "Location"
    type: string
    map_layer_name: countries
    sql: ${TABLE}.country ;;
  }

  dimension_group: open_date {
  type: time
  timeframes: [date, day_of_week, day_of_month, week, week_of_year, month, month_name, quarter, quarter_of_year, year]
  sql: ${TABLE}.open_date ;;
  }

  dimension: beds {
    label: "Bed in Store"
    type: string
    sql: ${TABLE}.beds ;;
  }

  dimension: primary_key {
    primary_key: yes
    sql: CONCAT(${open_date_date}, ${Customer}) ;;
    hidden: yes
  }

  measure: count {
    type: count
  }
}
