view: warehouse_location {
  sql_table_name: ANALYTICS_STAGE.NETSUITE_STG.LOCATIONS ;;

    dimension: location_id {
      hidden: yes
      type:number
      sql: ${TABLE}.location_id ;;
    }

    dimension: location_name {
      label: "Warehouse name"
      type: string
      sql: ${TABLE}.name ;;
    }
}
