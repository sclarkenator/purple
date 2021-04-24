view: v_new_roa {
  sql_table_name: "SALES"."V_NEW_ROA"
    ;;

  measure: roa_amt {
    type: sum
    sql: ${TABLE}."ROA_AMT" ;;
  }

  dimension: roa_date {
    type: date
    primary_key: yes
    convert_tz: no
    datatype: date
    sql: ${TABLE}."ROA_DATE" ;;
  }

}
