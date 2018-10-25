view: retail_stores {
  sql_table_name: CSV_UPLOADS.RETAIL_STORES ;;

  dimension: address {
    hidden: yes
    type: string
    sql: ${TABLE}."ADDRESS" ;;
  }

  dimension: beds {
    hidden: yes
    type: string
    sql: ${TABLE}."BEDS" ;;
  }

  dimension: city {
    hidden: yes
    type: string
    sql: ${TABLE}."CITY" ;;
  }

  dimension: retailer {
    case: {
      when: {
        label: "Mattress Firm"
        sql: ${TABLE}.retailer = 'MF' ;;
      }

      when: {
        label: "Furniture Row"
        sql:   ${TABLE}.retailer = 'FR' ;;
      }

      when: {
        label: "Macy's"
        sql:   ${TABLE}.retailer = 'MA' ;;
      }
    }
  }

  dimension: state {
    #hidden: yes
    type: string
    sql: ${TABLE}."STATE" ;;
  }

  dimension: zip {
    type: zipcode
    sql: ${TABLE}."ZIP" ;;
  }

  measure: count_MF {
    type: count
    filters: {
      field: retailer
      value: "MF"
    }
  }

  measure: count_MA {
      type: count
      filters: {
        field: retailer
        value: "MA"
      }
  }
  measure: count_FR {
    type: count
    filters: {
      field: retailer
      value: "FR"
    }
  }

  measure: count {
    type: count
  }


}
