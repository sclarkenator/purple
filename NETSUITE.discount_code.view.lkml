view: discount_code {
  sql_table_name: SALES.DISCOUNT_CODE ;;

  dimension: discount_code_id {
    primary_key: yes
    hidden:  yes
    type: number
    sql: ${TABLE}.DISCOUNT_CODE_ID ;;
  }

  dimension: created {
    hidden: yes
    type: string
    sql: ${TABLE}.CREATED ;;
  }

  dimension: discount_reason {
    description: "Reason for retroactive discount"
    type: string
    sql: ${TABLE}.DESCRIPTION ;;
  }
}
