view: sf_zipcode_facts {
  sql_table_name: LOOKER_DATABLOCKS.GSOD.ZIPCODE ;;

  dimension: zipcode {
    primary_key: yes
    hidden: yes
    map_layer_name: us_zipcode_tabulation_areas
    type: zipcode
    sql: ${TABLE}.zip_code ;;
  }

  dimension: latitude {
    hidden: yes
    type: number
    sql: ${TABLE}.latitude ;;
  }

  dimension: longitude {
    hidden: yes
    type: number
    sql: ${TABLE}.longitude ;;
  }

  dimension: city {
    group_label: "Customer Address"
    type: string
    sql: ${TABLE}.city ;;
  }

  dimension: state {
    group_label: "Customer Address"
    type: string
    sql: ${TABLE}.state ;;
  }

  dimension: county_name {
    group_label: "County"
    hidden: yes
    type: string
    sql: ${TABLE}.county ;;
  }

  dimension: location {
    type: location
    hidden: yes
    sql_latitude: ${TABLE}.latitude ;;
    sql_longitude: ${TABLE}.longitude ;;
  }

  measure: count {
    hidden: yes
    type: count
  }

  set: detail {
    fields: [
      zipcode,
      latitude,
      longitude,
      city,
      state,
      county_name,
      location
    ]
  }
}
