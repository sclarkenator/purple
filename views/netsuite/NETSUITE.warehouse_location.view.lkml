view: warehouse_location {
  sql_table_name: ANALYTICS_STAGE.netsuite.LOCATIONS ;;

    dimension: location_id {
      hidden: yes
      type:number
      sql: ${TABLE}.location_id ;; }

    dimension: location_name {
      label: "Warehouse Name"
      type: string
      sql: ${TABLE}.name ;; }

  dimension: location_Active {
    label: "* Inactive Locations Included (Yes/ No)"
    type: string
    sql: ${TABLE}.ISINACTIVE;; }

  dimension: location_name_manna_grouped {
    label: "Warehouse Name (manna grouped)"
    hidden: yes
    type: string
    sql: case when lower(${TABLE}.name) like ('%manna%') then 'Manna (all)' else ${TABLE}.name end;; }


  dimension: primary_key {
    primary_key: yes
    hidden:  yes
    sql: CONCAT(${TABLE}.location_id,${TABLE}.ISINACTIVE) ;;
    #NOT STRICTLY UNIQUE, COULD BE DUPLICATES
  }

}
