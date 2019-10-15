view: slicktext_textword {
  sql_table_name: MARKETING.SLICKTEXT_TEXTWORD ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    hidden: yes
    type: number
    sql: ${TABLE}."ID" ;;
  }

  dimension_group: added {
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
    sql: ${TABLE}."ADDED" ;;
  }

  dimension: age_requirement {
    hidden: yes
    type: number
    sql: ${TABLE}."AGE_REQUIREMENT" ;;
  }

  dimension: auto_reply {
    hidden: yes
    type: string
    sql: ${TABLE}."AUTO_REPLY" ;;
  }

  dimension: brand_email {
    hidden: yes
    type: string
    sql: ${TABLE}."BRAND_EMAIL" ;;
  }

  dimension: brand_name {
    hidden: yes
    type: string
    sql: ${TABLE}."BRAND_NAME" ;;
  }

  dimension: brand_spam_email {
    hidden: yes
    type: string
    sql: ${TABLE}."BRAND_SPAM_EMAIL" ;;
  }

  dimension: brand_website {
    hidden: yes
    type: string
    sql: ${TABLE}."BRAND_WEBSITE" ;;
  }

  dimension: contacts_count {
    hidden: yes
    type: number
    sql: ${TABLE}."CONTACTS_COUNT" ;;
  }

  dimension_group: deleted {
    type: time
    hidden: yes
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
    sql: ${TABLE}."DELETED" ;;
  }

  dimension: double_opt_in {
    hidden: yes
    type: yesno
    sql: ${TABLE}."DOUBLE_OPT_IN" ;;
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

  dimension: opt_outs {
    hidden: yes
    type: number
    sql: ${TABLE}."OPT_OUTS" ;;
  }

  dimension: terms_link {
    hidden: yes
    type: string
    sql: ${TABLE}."TERMS_LINK" ;;
  }

  dimension: text_number {
    hidden: yes
    type: string
    sql: ${TABLE}."TEXT_NUMBER" ;;
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

  dimension: word {
    hidden: yes
    type: string
    sql: ${TABLE}."WORD" ;;
  }

  measure: count {
    hidden: yes
    label: "Count of slicktext text word rows"
    type: count
    drill_fields: [id, brand_name]
  }
}
