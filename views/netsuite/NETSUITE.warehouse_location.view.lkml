view: warehouse_location {
  sql_table_name: analytics.sales.LOCATION ;;

    dimension: location_id {
      hidden: yes
      description: "Source: netsuite.location"
      type:number
      sql: ${TABLE}.location_id ;; }

    dimension: location_name {
      label: "Warehouse Name"
      description: "Source: netsuite.location"
      type: string
      sql: ${TABLE}.location ;; }

  dimension: location_Active {
    label: "* Inactive Locations Included (Yes/ No)"
    description: "Source: netsuite.location"
    type: string
    sql: ${TABLE}.INACTIVE = 1;; }

  dimension: location_name_manna_grouped {
    label: "Warehouse Name (manna grouped)"
    description: "Source: netsuite.location"
    hidden: yes
    type: string
    sql: case when lower(${TABLE}.location) like ('%manna%') then 'Manna (all)' else ${TABLE}.location end;; }


  dimension: primary_key {
    primary_key: yes
    hidden:  yes
    sql: CONCAT(${TABLE}.location_id,${TABLE}.INACTIVE) ;;
    #NOT STRICTLY UNIQUE, COULD BE DUPLICATES
  }

}
