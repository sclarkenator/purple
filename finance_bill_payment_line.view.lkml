view: finance_bill_payment_line {

  sql_table_name: finance.bill_payment_line;;

  dimension: bill_payment_id{
    description: "Bill id"
    type:  number
    sql: ${TABLE}.BILL_payment_ID ;;
  }

  dimension: bill_payment_line_id {
    type:  number
    sql: ${TABLE}.bill_payment_line_id;;
  }
  dimension: company {
    type:  string
    sql: ${TABLE}.company;;
  }

  dimension: primary_key {
    primary_key: yes
    sql: CONCAT(${bill_payment_id}, ${bill_payment_line_id}) ;;
  }



 }
