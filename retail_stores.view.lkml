view: retail_stores {
  sql_table_name: CSV_UPLOADS.RETAIL_STORES ;;

  dimension: addressfake {
    #hidden: yes
    type: string
    sql: ${TABLE}."ADDRESS" ;;
  }

  dimension: bedfakes {
    hidden: yes
    type: string
    sql: ${TABLE}."BEDS" ;;
  }

  dimension: citfakey {
    hidden: yes
    type: string
    sql: ${TABLE}."CITY" ;;
  }

  dimension: retailefaker {
    case: {
      when: { label: "Mattress Firm" sql: ${TABLE}.retailer = 'MF' ;;}
      when: { label: "Furniture Row" sql:   ${TABLE}.retailer = 'FR' ;;}
      when: { label: "Macy's" sql:   ${TABLE}.retailer = 'MA' ;;}
      when: { label: "Slep Experts" sql:   ${TABLE}.retailer = 'SE' ;;}
      when: { label: "Rest & Relax" sql:   ${TABLE}.retailer = 'RR' ;;}
    }
  }

  dimension: statfakee {
    #hidden: yes
    type: string
    map_layer_name:  us_states
    drill_fields: [zipfake,addressfake]
    sql: ${TABLE}."STATE" ;;
  }

  dimension: zipfake {
    type: zipcode
    drill_fields: [addressfake]
    sql: ${TABLE}."ZIP" ;;
  }

  measure: count_MFfake {
    type: count
    filters: {
      field: retailefaker
      value: "MF"
    }
  }

  measure: count_MAfake {
      type: count
      filters: {
        field: retailefaker
        value: "MA"
      }
  }
  measure: count_FRfake {
    type: count
    filters: {
      field: retailefaker
      value: "FR"
    }
  }

  measure: count {
    type: count
  }


}
