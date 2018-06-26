view: customer_table {
  sql_table_name: ANALYTICS_STAGE.NETSUITE_STG.CUSTOMERS ;;

    dimension: customer_id {
      hidden: yes
      type:number
      sql: ${TABLE}.customer_id ;;
    }

    dimension: companyname {
      label: "Wholesale customer name"
      type: string
      sql: ${TABLE}.companyname ;;
    }

    dimension: mf_or_other {
      label: "Mattress Firm"
      description: "Toggle to select Mattress Firm"
      type: yesno
      sql: ${customer_id}=2662 ;;
    }
}
