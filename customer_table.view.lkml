view: customer_table {
  sql_table_name: ANALYTICS_STAGE.NETSUITE_STG.CUSTOMERS ;;

    dimension: customer_id {
      type:number
      sql: ${TABLE}.customer_id ;;
    }

    dimension: companyname {
      type: string
      sql: ${TABLE}.companyname ;;
    }

  dimension: name {
    type: string
    sql: ${TABLE}.name ;;
  }

}
