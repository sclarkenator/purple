view: mattress_firm_store_details {
  sql_table_name: mattress_firm.store ;;

  dimension: store_id {
    type:  string
    primary_key: yes
    sql:  ${TABLE}.store_id ;;
  }

  dimension: district {
    type:  string
    sql:  ${TABLE}.district ;;
  }

  dimension: market {
    type:  string
    sql:  ${TABLE}.market ;;
  }

  dimension: market_state {
    type:  string
    sql:  ${TABLE}.market_state ;;
  }

  dimension: coordinates {
    type:  location
    sql_latitude: ${TABLE}.latitude ;;
    sql_longitude: ${TABLE}.longitude ;;
  }

  dimension: address {
    type:  string
    sql:  ${TABLE}.address ;;
  }

  dimension: city {
    type:  string
    sql:  ${TABLE}.city ;;
  }

  dimension: state {
    type:  string
    sql:  ${TABLE}.state ;;
  }

  dimension: zipcode {
    type:  zipcode
    sql:  ${TABLE}.zip ;;
  }

    dimension_group: start_date{
    hidden:  yes
    description: "Date Mattress Firm started selling Purple in this location"
    type:  time
    timeframes: [
      date,
      week,
      month,
      quarter,
      year
    ]
    datatype: date
    sql: ${TABLE}.start_date ;;
  }

  measure: store_count {
    type:  count

  }


 }
