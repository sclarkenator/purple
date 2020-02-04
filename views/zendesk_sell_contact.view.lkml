view: zendesk_sell_contact {
  sql_table_name: "CUSTOMER_CARE"."ZENDESK_SELL_CONTACT"
    ;;

  dimension: city {
    type: string
    sql: ${TABLE}."CITY" ;;
  }

  dimension: contact_id {
    type: number
    sql: ${TABLE}."CONTACT_ID" ;;
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

  dimension: creator_id {
    type: number
    sql: ${TABLE}."CREATOR_ID" ;;
  }

  dimension: customer_status {
    type: string
    sql: ${TABLE}."CUSTOMER_STATUS" ;;
  }

  dimension: description {
    type: string
    sql: ${TABLE}."DESCRIPTION" ;;
  }

  dimension: email {
    type: string
    sql: ${TABLE}."EMAIL" ;;
  }

  dimension: first_name {
    type: string
    sql: ${TABLE}."FIRST_NAME" ;;
  }

  dimension: is_organization {
    type: string
    sql: ${TABLE}."IS_ORGANIZATION" ;;
  }

  dimension_group: last_contact {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}."LAST_CONTACT" ;;
  }

  dimension: last_name {
    type: string
    sql: ${TABLE}."LAST_NAME" ;;
  }

  dimension: line1 {
    type: string
    sql: ${TABLE}."LINE1" ;;
  }

  dimension: mobile {
    type: string
    sql: ${TABLE}."MOBILE" ;;
  }

  dimension: name {
    type: string
    sql: ${TABLE}."NAME" ;;
  }

  dimension: owner_id {
    type: number
    sql: ${TABLE}."OWNER_ID" ;;
  }

  dimension: state {
    type: string
    sql: ${TABLE}."STATE" ;;
  }

  dimension: tags {
    type: string
    sql: ${TABLE}."TAGS" ;;
  }

  dimension_group: updated {
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
    sql: ${TABLE}."UPDATED_AT" ;;
  }

  dimension: zip_code {
    type: zipcode
    sql: ${TABLE}."ZIP_CODE" ;;
  }

  measure: count {
    type: count
    drill_fields: [first_name, name, last_name]
  }
}
