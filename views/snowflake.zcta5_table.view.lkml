view: zcta5 {
  derived_table: {
    sql:  select LPAD(cast(ZCTA5 as string), 5, '0') zipcode
       ,state_abbreviation st
       ,state st_cd
       ,min(county) FIPS
       ,avg(zpop) pop
       ,avg(zhu) hhld
from looker_datablocks.ACS.ZCTA_to_tract_w_state
group by 1,2,3
order by 1 ;;
  }

  dimension: primary_key {
    primary_key: yes
    hidden: yes
    type: string
    sql:  ${TABLE}.zipcode|| ${TABLE}.st_cd ;;
  }

  dimension: us_flag {
    view_label: "Geography"
    label: "     * In US (Yes / No)"
    description: "Order placed for delivery in US"
    sql: case when ${TABLE}.zipcode is null then 0 else 1 end ;;
  }

  dimension: zipcode {
    label: "Zip code (5)"
    hidden:  yes
    description: "5-digit US zip code"
    view_label: "Geography"
    type: string
    sql: ${TABLE}.zipcode ;;
  }

  dimension: state {
    view_label: "Customer"
    group_label: "Customer Address"
    type: string
    hidden: yes
    map_layer_name: us_states
    sql: ${TABLE}.st ;;
  }


  dimension: state_1 {
    view_label: "Geography"
    label: "State"
    description: "Ship-to state"
    type: string
    map_layer_name: us_states
    sql: ${TABLE}.st ;;
  }

  dimension: fulfillment_region_1 {
    label: "US Region"
    view_label: "Geography"
    description: "Geographic grouping based on ship-to state"
    type: string
    case: {
      when: {
        sql: ${TABLE}.st in ('CA','OR','WA','HI','AK','NV') ;;
        label: "WEST"
      }
      when: {
        sql: ${TABLE}.st in ('UT','MT','ID','CO','WY') ;;
        label: "MOUNTAIN"
      }
      when: {
        sql: ${TABLE}.st in ('AZ','NM','TX','OK') ;;
        label: "SOUTHWEST"
      }
      when: {
        sql: ${TABLE}.st in ('ND','SD','NE','KS','MO','IA','MN') ;;
        label: "PLAINS"
      }
      when: {
        sql: ${TABLE}.st in ('WI','MI','IL','IN','OH') ;;
        label: "GREAT LAKES"
      }
      when: {
        sql: ${TABLE}.st in ('AR','LA','MS','AL','GA','TN','KY','WV','VA','NC','SC','FL') ;;
        label: "SOUTHEAST"
      }
      when: {
        sql: ${TABLE}.st in ('ME','NH','VT','MA','RI','CT','PA','NY','DE','MD','DC','NJ') ;;
        label: "NORTHEAST"
      }
    }
  }

  dimension: county_fips {
    view_label: "Geography"
    hidden: yes
    type: string
    sql: ${TABLE}.county ;;
  }

  measure: count {
    hidden: yes
    type: count
  }

  measure:  population {
    view_label: "Geography"
    description: "Population from 2015 ACS"
    type: sum
    sql: ${TABLE}.pop ;;
  }

  measure:  households {
    view_label: "Geography"
    description: "Total households from 2015 ACS"
    type: sum
    sql: ${TABLE}.hhld ;;
  }

}
