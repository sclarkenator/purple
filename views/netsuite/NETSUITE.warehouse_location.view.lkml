view: warehouse_location {
  sql_table_name: analytics.sales.LOCATION ;;

    dimension: location_id {
      hidden: no
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

  dimension: warehouse_bucket {
    label: "Warehouse Buckets"
    description: "Warehouses used by Purple (PWest and Mainfreight), White Glove (Nehds, Ryder, XPO, Pilot, Speedy, FragilePak), Other"
    type: string
    sql: case
      when ${location_id} = '4' or  ${location_id} = '71' or ${location_id} = '75' or ${location_id} = '101' or ${location_id} = '111' then 'Purple'
      when ${location_id} = '58' or  ${location_id} = '59' or ${location_id} = '63' or ${location_id} = '76'
        or ${location_id} = '116' or ${location_id} = '121'or ${location_id} = '146'or ${location_id} = '149' or ${location_id} = '155' or ${location_id} = '158' or ${location_Active}='162'
        or ${location_id} = '170' or ${location_id} = '176' then 'White Glove'
      else 'Other' end ;;
  }

  dimension: production_location{
    label: "Production Location"
    description: "Warehouse Locations for Production (100-Purple West, 150-Alpine, 200-Purple South); Source: Looker Calculation"
    type: string
    case: {
      when: { sql: ${location_id} = '4'  or ${location_id} = '41';; label: "Purple West"}
      when: { sql: ${location_id} = '111' ;; label: "Purple South"}
      when: { sql: ${location_id} = '5' ;; label: "Alpine"}
    }
  }
}
