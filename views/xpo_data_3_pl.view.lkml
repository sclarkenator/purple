view: xpo_data_3_pl {
  sql_table_name: CSV_UPLOADS.XPO_DATA_3PL ;;

  dimension: city {
    label: "Destination City"
    type: string
    sql: ${TABLE}."CITY" ;;
  }

  dimension: destinationzip {
    label: "Destination Zip"
    description: "This is what the table is joined on. Adding the hub data to the sales order line."
    type: string
    sql: ${TABLE}."DESTINATIONZIP" ;;
  }

  dimension: hubcityst {
    type: string
    sql: ${TABLE}."HUBCITYST" ;;
  }

  dimension: hubzip {
    type: string
    sql: ${TABLE}."HUBZIP" ;;
  }

  dimension: lmhid {
    label: "XPO HUB Code"
    type: string
    sql: ${TABLE}."LMHID" ;;
  }

  dimension: owmiles {
    label: "OW Miles"
    type: string
    sql: ${TABLE}."OWMILES" ;;
  }

  dimension: st {
    label: "Destination State"
    type: string
    sql: ${TABLE}."ST" ;;
  }

  dimension: primary_key {
    primary_key: yes
    sql: CONCAT(${lmhid}, ${destinationzip}) ;;
    hidden: yes
  }


  measure: count {
    type: count
    drill_fields: []
  }
}
