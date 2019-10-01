view: slicktext_contact {
  sql_table_name: MARKETING.SLICKTEXT_CONTACT ;;

  dimension: birthdate {
    type: string
    sql: ${TABLE}."BIRTHDATE" ;;
  }

  dimension: city {
    type: string
    sql: ${TABLE}."CITY" ;;
  }

  dimension: contact_id {
    type: number
    sql: ${TABLE}."CONTACT_ID" ;;
    primary_key: yes
  }

  dimension: country {
    type: string
    map_layer_name: countries
    sql: ${TABLE}."COUNTRY" ;;
  }

  dimension: email {
    type: string
    sql: ${TABLE}."EMAIL" ;;
  }

  dimension: first_name {
    type: string
    sql: ${TABLE}."FIRST_NAME" ;;
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

  dimension: last_name {
    type: string
    sql: ${TABLE}."LAST_NAME" ;;
  }

  dimension: mattress_purchaser {
    type: yesno
    sql: ${TABLE}."MATTRESS_PURCHASER" ;;
  }

  dimension: opt_in_method {
    type: string
    sql: ${TABLE}."OPT_IN_METHOD" ;;
  }

  dimension: phone_number {
    type: string
    sql: ${TABLE}."PHONE_NUMBER" ;;
  }

  dimension: state {
    type: string
    sql: ${TABLE}."STATE" ;;
  }

  dimension_group: subscribed {
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
    sql: ${TABLE}."SUBSCRIBED" ;;
  }

  dimension: textword_id {
    type: number
    sql: ${TABLE}."TEXTWORD_ID" ;;
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
    drill_fields: [first_name, last_name]
  }
}
