view: vendor {
  sql_table_name: PRODUCTION.VENDOR ;;

  dimension: vendor_id {
    primary_key: yes
    type: number
    sql: ${TABLE}."VENDOR_ID" ;;
  }

  dimension: accountnumber {
    type: string
    sql: ${TABLE}."ACCOUNTNUMBER" ;;
  }

  dimension: altphone {
    type: string
    sql: ${TABLE}."ALTPHONE" ;;
  }

  dimension: city {
    type: string
    sql: ${TABLE}."CITY" ;;
  }

  dimension: companyname {
    type: string
    sql: ${TABLE}."COMPANYNAME" ;;
  }

  dimension: country {
    type: string
    map_layer_name: countries
    sql: ${TABLE}."COUNTRY" ;;
  }

  dimension_group: created {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}."CREATED" ;;
  }

  dimension: email {
    type: string
    sql: ${TABLE}."EMAIL" ;;
  }

  dimension: fax {
    type: string
    sql: ${TABLE}."FAX" ;;
  }

  dimension_group: insert_ts {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}."INSERT_TS" ;;
  }

  dimension: is_active {
    type: number
    sql: ${TABLE}."IS_ACTIVE" ;;
  }

  dimension: is_person {
    type: number
    sql: ${TABLE}."IS_PERSON" ;;
  }

  dimension: line1 {
    type: string
    sql: ${TABLE}."LINE1" ;;
  }

  dimension: line2 {
    type: string
    sql: ${TABLE}."LINE2" ;;
  }

  dimension: name {
    type: string
    sql: ${TABLE}."NAME" ;;
  }

  dimension: phone {
    type: string
    sql: ${TABLE}."PHONE" ;;
  }

  dimension: state {
    type: string
    sql: ${TABLE}."STATE" ;;
  }

  dimension_group: update_ts {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}."UPDATE_TS" ;;
  }

  dimension: zipcode {
    type: zipcode
    sql: ${TABLE}."ZIPCODE" ;;
  }

  measure: count {
    type: count
    drill_fields: [vendor_id, name, companyname]
  }
}
