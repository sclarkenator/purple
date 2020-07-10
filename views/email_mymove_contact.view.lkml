view: email_mymove_contact {
  sql_table_name: "MARKETING"."MYMOVE_CONTACT"
    ;;

  dimension: address_1 {
    type: string
    sql: ${TABLE}."ADDRESS_1" ;;
  }

  dimension: address_2 {
    type: string
    sql: ${TABLE}."ADDRESS_2" ;;
  }

  dimension: city {
    type: string
    sql: ${TABLE}."CITY" ;;
  }

  dimension: cordial_uploaded {
    type: yesno
    sql: ${TABLE}."CORDIAL_UPLOADED" ;;
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
    sql: CAST(${TABLE}."CREATED" AS TIMESTAMP_NTZ) ;;
  }

  dimension: email {
    type: string
    primary_key: yes
    sql: ${TABLE}."EMAIL" ;;
  }

  dimension: in {
    label: "*In Dataset"
    type: yesno
    sql: ${email} is not null ;;
  }

  dimension: before {
    label: "Before Netsuite"
    type: yesno
    sql: ${created_date} < ${sales_order.created_date} ;;
  }


  dimension: first_name {
    type: string
    sql: ${TABLE}."FIRST_NAME" ;;
  }

  dimension: housing_tenure {
    type: string
    sql: ${TABLE}."HOUSING_TENURE" ;;
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
    sql: CAST(${TABLE}."INSERT_TS" AS TIMESTAMP_NTZ) ;;
  }

  dimension: last_name {
    type: string
    sql: ${TABLE}."LAST_NAME" ;;
  }

  dimension: postal_code {
    type: string
    sql: ${TABLE}."POSTAL_CODE" ;;
  }

  dimension: postal_code_plus4 {
    type: string
    sql: ${TABLE}."POSTAL_CODE_PLUS4" ;;
  }

  dimension: state {
    type: string
    sql: ${TABLE}."STATE" ;;
  }

  measure: count {
    type: count
    drill_fields: [last_name, first_name]
  }
}
