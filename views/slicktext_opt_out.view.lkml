view: slicktext_opt_out {
  sql_table_name: MARKETING.SLICKTEXT_OPT_OUT ;;

  dimension: birthdate {
    type: string
    sql: ${TABLE}."BIRTHDATE" ;;
    hidden: yes
  }

  dimension: city {
    type: string
    sql: ${TABLE}."CITY" ;;
    hidden: yes
  }

  dimension: contact_id {
    type: number
    sql: ${TABLE}."CONTACT_ID" ;;
    primary_key: yes
    hidden: yes
  }

  dimension: country {
    type: string
    map_layer_name: countries
    sql: ${TABLE}."COUNTRY" ;;
    hidden: yes
  }

  dimension: email {
    type: string
    sql: ${TABLE}."EMAIL" ;;
    hidden: yes
  }

  dimension: first_name {
    type: string
    sql: ${TABLE}."FIRST_NAME" ;;
    hidden: yes
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
    type: string
    sql: ${TABLE}."LAST_NAME" ;;
    hidden: yes
  }

  dimension: mattress_purchaser {
    type: string
    sql: ${TABLE}."MATTRESS_PURCHASER" ;;
    hidden: yes
  }

  dimension: opt_in_method {
    type: string
    sql: ${TABLE}."OPT_IN_METHOD" ;;
    hidden: yes
  }

  dimension_group: opt_out {
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
    sql: ${TABLE}."OPT_OUT" ;;
  }

  dimension: phone_number {
    type: string
    sql: ${TABLE}."PHONE_NUMBER" ;;
    hidden: yes
  }

  dimension: state {
    type: string
    sql: ${TABLE}."STATE" ;;
    hidden: yes
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
    type: number
    sql: ${TABLE}."TEXTWORD_ID" ;;
    hidden: yes
  }

  dimension_group: update_ts {
    type: time
    hidden: yes
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
    hidden: yes
  }

  measure: count {
    label: "Count of slicktext opt out rows"
    type: count
    hidden: yes
    drill_fields: [first_name, last_name]
  }
}
