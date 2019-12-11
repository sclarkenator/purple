view: zipcode_radius {
  sql_table_name: CSV_UPLOADS.ZIPCODE_RADIUS ;;

  dimension: primary_key {
    primary_key: yes
    hidden: yes
    type: string
    sql: ${TABLE}.zipcode||${TABLE}.description ;;
  }

  dimension: description {
    type: string
    sql: ${TABLE}."DESCRIPTION" ;;
    hidden: yes
  }

  dimension: zipcode {
    type: zipcode
    sql: ${TABLE}."ZIPCODE" ;;
    hidden: yes
  }

  dimension: zipcode_miles{
    label: "Miles from Retail Location"
    description: "Bucketed miles from Retial Location (5, 10, 15)"
    view_label: "Geography"
    type: string
    sql: case when ${zipcode_radius.description} like '% 5%' then '5'
      when ${zipcode_radius.description} like '% 10%' then '10'
      when ${zipcode_radius.description} like '% 15%' then '15'
      end;;
    hidden: yes
  }

  dimension: retail_store_city_radius {
    label: "Retail Store City Radius"
    description: "Retail Store with associated city radius"
    view_label: "Geography"
    type: string
    sql: case when ${zipcode_radius.description} like '%Seattle%' then 'Seattle'
      when ${zipcode_radius.description} like '%Santa Monica%' then 'Santa Monica'
      when ${zipcode_radius.description} like '%Salt Lake City%' then 'Salt Lake City'
      when ${zipcode_radius.description} like '%San Diego%' then 'San Diego'
      when ${zipcode_radius.description} like '%San Jose%' then 'San Jose'
      end;;
    hidden: yes
  }

  measure: count {
    type: count
    drill_fields: []
    hidden: yes
  }
}
