view: narvar_customer_feedback {


  sql_table_name: CUSTOMER_CARE.NARVAR_CUSTOMER_FEEDBACK ;;

  dimension: tracking_id {
    type: string
    sql: ${TABLE}."TRACKING_ID" ;;

  }

  dimension: tranid {
    label: "Transaction ID"
    hidden: yes
    type: string
    # link: {
    #   label: "NetSuite"
    #   url: "https://system.na2.netsuite.com/app/accounting/transactions/salesord.nl?id={{order_id._value}}&whence="
    #   icon_url: "https://www.google.com/s2/favicons?domain=www.netsuite.com"
    # }
    sql: ${TABLE}."ORDER_ID" ;;
    primary_key: yes
  }

  dimension_group: created {
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
    sql: ${TABLE}."CREATED" ;;
  }

  dimension: ship {
    type: date
    sql: ${TABLE}."SHIP" ;;
  }

  dimension: delivery {
    type: date
    sql: ${TABLE}."DELIVERY" ;;
  }

  dimension: star_rating {
    type: number
    sql: ${TABLE}."STAR_RATING" ;;
  }

  dimension: status {
    type: string
    sql: ${TABLE}."STATUS" ;;
  }

  dimension: customer_comment {
    type: string
    sql: ${TABLE}."CUSTOMER_COMMENT" ;;
  }

  dimension: row_id {
    hidden: yes
    type: number
    sql: ${TABLE}."ROW_ID" ;;
  }

  dimension: zendesk_loaded {
    hidden: yes
    type: yesno
    sql: ${TABLE}."ZENDESK_LOADED" ;;
  }

  dimension_group: insert_ts {
    hidden: yes
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
    sql: ${TABLE}."INSERT_TS" ;;
  }

  dimension_group: update_ts {
    hidden: yes
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
    sql: ${TABLE}."UPDATE_TS" ;;
  }

  measure: count {
    type: count
  }

  measure: average_star_rating{
    type: average
    sql: ${star_rating} ;;
    value_format: "0.##"
  }
 }
