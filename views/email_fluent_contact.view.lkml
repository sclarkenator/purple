view: email_fluent_contact {
  sql_table_name: "ANALYTICS_STAGE"."MARKETING_STAGE"."FLUENT_CONTACT" ;;

  dimension: email {
    type: string
    primary_key: yes
    sql:  ${TABLE}.email ;;
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
    sql: ${TABLE}.first_name ;;
  }

  dimension: last_name {
    type: string
    sql: ${TABLE}.last_name ;;
  }

  dimension: targeting_strategy {
    type:  string
    sql: ${TABLE}.targeting_strategy ;;
  }

  dimension_group: created {
    type: time
    timeframes: [
      date,
      week,
      month,
      quarter,
      year
    ]
    sql:${TABLE}."CREATED" ;;
  }

  measure: count {
    type: count
  }

}
