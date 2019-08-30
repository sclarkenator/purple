view: finance_bill_payment {

  sql_table_name: finance.bill_payment;;

  dimension: bill_payment_id{
    description: "Bill id"
    type:  number
    sql: ${TABLE}.BILL_payment_ID ;;
    primary_key:  yes
  }


  dimension: company {
    type:  string
    sql: ${TABLE}.company;;
  }

  dimension_group: trandate{
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
    sql: ${TABLE}.trandate ;;
  }


}
