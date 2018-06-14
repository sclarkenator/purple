view: discount_code {
  sql_table_name: SALES.DISCOUNT_CODE ;;

  dimension: discount_code_id {
    primary_key: yes
    type: number
    sql: ${TABLE}.DISCOUNT_CODE_ID ;;
  }

  dimension: created {
    type: string
    sql: ${TABLE}.CREATED ;;
  }

  dimension: description {
    type: string
    sql: ${TABLE}.DESCRIPTION ;;
  }

  measure: count {
    type: count
    drill_fields: [discount_code_id, refund_line.count, retroactive_discount.count]
  }
}
