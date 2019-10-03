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
    group_label: "Advanced"
    type: string
    sql: ${TABLE}.city ;;
  }

  dimension: state {
    label: " State"
    type: string
    map_layer_name: us_states
    sql: ${TABLE}.state ;;
  }

  dimension: price_test_state {
    group_label: "Advanced"
    type: string
    sql: case when ${TABLE}.state in ('NC','OH','WA','CO','FL','WI') then 'test'
        else 'control' end ;;
      }

  dimension: fulfillment_region {
    label: "US Fulfillment Region"
    group_label: "Advanced"
    type: string
    sql: case when ${TABLE}.state = 'CA'
              then 'California'
          when ${TABLE}.state in ('TX', 'FL', 'NY', 'OH', 'IL', 'PA', 'VA', 'NC', 'GA', 'MI',
                                  'MN', 'MD', 'TN', 'IN', 'MO', 'WI', 'OK', 'SC', 'AL', 'LA',
                                  'KY', 'KS', 'IA', 'AR', 'NE', 'MS', 'ND', 'WV', 'DE', 'DC',
                                  'SD', 'MA', 'NJ', 'NH', 'ME', 'VT', 'CT', 'RI')
              then 'East'
          when ${TABLE}.state in ('UT', 'CO', 'AZ', 'NV', 'ID', 'NM', 'MT', 'WY')
              then 'Mountain West'
          when ${TABLE}.state in ('WA', 'OR')
              then 'Northwest'
          --when ${TABLE}.state is null
              --then 'Unknown'
          else 'Other/Unknown' END ;;
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
