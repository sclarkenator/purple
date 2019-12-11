view: slicktext_contact {
  sql_table_name: MARKETING.SLICKTEXT_CONTACT ;;

  dimension: birthdate {
    hidden: yes
    type: string
    sql: ${TABLE}."BIRTHDATE" ;;
  }

  dimension: city {
    hidden: yes
    type: string
    sql: ${TABLE}."CITY" ;;
  }

  dimension: contact_id {
    hidden: yes
    type: number
    sql: ${TABLE}."CONTACT_ID" ;;
    primary_key: yes
  }

  dimension: country {
    hidden: yes
    type: string
    map_layer_name: countries
    sql: ${TABLE}."COUNTRY" ;;
  }

  dimension: email {
    hidden: yes
    type: string
    sql: ${TABLE}."EMAIL" ;;
  }

  dimension: first_name {
    hidden: yes
    type: string
    sql: ${TABLE}."FIRST_NAME" ;;
  }

  dimension_group: insert_ts {
    hidden: yes
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
    hidden: yes
    type: string
    sql: ${TABLE}."LAST_NAME" ;;
  }

  dimension: mattress_purchaser {
    hidden: yes
    type: yesno
    sql: ${TABLE}."MATTRESS_PURCHASER" ;;
  }

  dimension: opt_in_method {
    hidden: yes
    type: string
    sql: ${TABLE}."OPT_IN_METHOD" ;;
  }

  dimension: phone_number {
    hidden: yes
    type: string
    sql: ${TABLE}."PHONE_NUMBER" ;;
  }

  dimension: state {
    hidden: yes
    type: string
    sql: ${TABLE}."STATE" ;;
  }

  dimension_group: subscribed {
    hidden: yes
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
    hidden: yes
    type: number
    sql: ${TABLE}."TEXTWORD_ID" ;;
  }

  dimension_group: update_ts {
    hidden: yes
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
    hidden: yes
    type: zipcode
    sql: ${TABLE}."ZIPCODE" ;;
  }

  measure: count {
    hidden: yes
    label: "Count of slicktext contact rows"
    type: count
    drill_fields: [first_name, last_name]
  }
}
