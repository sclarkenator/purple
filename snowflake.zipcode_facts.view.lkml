view: sf_zipcode_facts {
  sql_table_name: LOOKER_DATABLOCKS.GSOD.ZIPCODE ;;

  dimension: zipcode {
    primary_key: yes
    hidden: yes
    map_layer_name: us_zipcode_tabulation_areas
    type: zipcode
    sql: ${TABLE}.zip_code ;;
  }

  dimension: us_flag {
    hidden: yes
    view_label: "Geography"
    label: "     * In US"
    description: "Order placed for delivery in US"
    sql: case when ${TABLE}.zipcode is null then 0 else 1 end ;;
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

  dimension: city_1 {
    hidden: yes
    view_label: "Geography"
    label: "City"
    description: "Ship-to city for order"
    type: string
    sql: ${TABLE}.city ;;
  }

  dimension: state_1 {
    hidden: yes
    view_label: "Geography"
    label: "State"
    description: "Ship-to state"
    type: string
    map_layer_name: us_states
    sql: ${TABLE}.state ;;
  }

  dimension: price_test_state {
    group_label: "Customer Address"
    type: string
    hidden:  yes
    sql: case when ${TABLE}.state in ('NC','OH','WA','CO','FL','WI') then 'test'
        else 'control' end ;;
      }

  dimension: fulfillment_region_1 {
    hidden: yes
    label: "US Region"
    view_label: "Geography"
    description: "Geographic grouping based on ship-to state"
    type: string
    case: {
      when: {
        sql: ${TABLE}.state in ('CA','OR','WA','HI','AK','NV') ;;
        label: "WEST"
      }
      when: {
        sql: ${TABLE}.state in ('UT','MT','ID','CO','WY') ;;
        label: "MOUNTAIN"
      }
      when: {
        sql: ${TABLE}.state in ('AZ','NM','TX','OK') ;;
        label: "SOUTHWEST"
      }
      when: {
        sql: ${TABLE}.state in ('ND','SD','NE','KS','MO','IA','MN') ;;
        label: "PLAINS"
      }
      when: {
        sql: ${TABLE}.state in ('WI','MI','IL','IN','OH') ;;
        label: "GREAT LAKES"
      }
      when: {
        sql: ${TABLE}.state in ('AR','LA','MS','AL','GA','TN','KY','WV','VA','NC','SC','FL') ;;
        label: "SOUTHEAST"
      }
      when: {
        sql: ${TABLE}.state in ('ME','NH','VT','MA','RI','CT','PA','NY','DE','MD','DC','NJ') ;;
        label: "NORTHEAST"
      }
    }
  }

 dimension: fulfillment_region {
    label: "US Region"
    hidden:  yes
    view_label: "Geography"
    description: "Geographic grouping based on ship-to state"
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
    view_label: "Geography"
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
