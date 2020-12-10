view: fips {
  sql_table_name: "CSV_UPLOADS"."FIPS"
    ;;

  dimension: county_name {
    type: string
    hidden: yes
    sql: ${TABLE}."COUNTY_NAME" ;;
  }

  dimension: description {
    type: string
    hidden: yes
    sql: ${TABLE}."DESCRIPTION" ;;
  }

  dimension: fips {
    type: string
    hidden: yes
    sql: ${TABLE}."FIPS" ;;
  }

  dimension: rucc_2013 {
    type: string
    hidden: yes
    sql: ${TABLE}."RUCC_2013" ;;
  }

  dimension: state {
    type: string
    hidden: yes
    sql: ${TABLE}."STATE" ;;
  }

  measure: count {
    type: count
    hidden: yes
    drill_fields: [county_name]
  }

  dimension: is_metro {
    type: yesno
    hidden: yes
    label: " * Is Metro"
    description: "FIPS in metro area county with more than 250K population"
    view_label: "Geography"
    sql: ${rucc_2013} in ('1')  ;;
  }

  dimension: is_rural {
    type: yesno
    hidden:  yes
    label: " * Is Rural"
    description: "FIPS in metro area county with more than 250K population"
    view_label: "Geography"
    sql: ${rucc_2013} in ('5', '6', '7','8','9')  ;;
  }

  dimension: is_suburban {
    type: yesno
    hidden:  yes
    label: " * Is Suburban"
    description: "FIPS in metro area county with more than 250K population"
    view_label: "Geography"
    sql: ${rucc_2013} in ('2','3','4')  ;;
  }


}
