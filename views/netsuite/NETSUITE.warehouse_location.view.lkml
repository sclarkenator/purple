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

  dimension: carrier {
    label: "Carrier (expected)"
    description: "Derived field based on fulfillment location.
    Source:netsuite.warehouse_location"
    #hidden: yes
    type: string
    sql: case
          when ${location_name} ilike '%mainfreight%' then 'MainFreight'
          when ${location_name} ilike '%xpo%' then 'XPO'
          when ${location_name} ilike '%pilot%' then 'Pilot'
          when ${location_name} is null then 'FBA'
          when ${location_name} ilike '%100-%' then 'Purple'
          when ${location_name} ilike '%le store%' or ${location_name} ilike '%howroom%' then 'Store take-with'
          else 'Other' end ;;
  }

  dimension: DTC_carrier {
    label: "Carrier (Grouping)"
    description: "From Netsuite sales order line, the carrier field grouped into Purple, XPO, and Pilot.
    Source:netsuite.warehouse_location"
    hidden: no
    type: string
    sql:  CASE WHEN upper(coalesce(${carrier},'')) not in ('XPO','MANNA','PILOT','MAINFREIGHT') THEN 'Purple' Else ${carrier} END;;
  }

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
