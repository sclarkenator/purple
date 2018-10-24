view: warehouse_location {
  sql_table_name: ANALYTICS_STAGE.netsuite.LOCATIONS ;;

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

  dimension: location_name_manna_grouped {
    label: "Warehouse name (manna grouped)"
    type: string
    sql: case when lower(${TABLE}.name) like ('%manna%') then 'Manna (all)' else ${TABLE}.name end;;
  }
}
