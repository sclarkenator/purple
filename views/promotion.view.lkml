view: promotion {
  sql_table_name: ANALYTICS.MARKETING.V_promotion ;;
  #derived_table: {sql:select * from marketing.promotion where not deleted ;;}


  dimension: id {
    primary_key: yes
    type: string
    hidden: yes
    sql: ${TABLE}."ID" ;;
  }

  dimension: deleted {
    type: yesno
    hidden: yes
    sql: ${TABLE}."DELETED" ;;
  }

  dimension: description {
    #label: "Promotion Period Description"
    #group_label: " Advanced"
    type: string
    sql: ${TABLE}."DESCRIPTION" ;;
  }

  dimension_group: end {
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
    convert_tz: no
    #hidden: yes
    datatype: date
    sql: ${TABLE}."END" ;;
  }

   dimension: name {
    type: string
    #label: "Promotion Period Name"
    #group_label: " Advanced"
    sql: ${TABLE}."NAME" ;;
  }

  dimension_group: start {
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
    convert_tz: no
    #hidden: yes
    datatype: date
    sql: ${TABLE}."START" ;;
  }

  dimension: type {
    type: string
    #label: "Promotion Period Type"
    #group_label: " Advanced"
    sql: ${TABLE}."TYPE" ;;
  }

  measure: count {
    type: count
    #hidden: yes
    drill_fields: [id, name]
  }
}
