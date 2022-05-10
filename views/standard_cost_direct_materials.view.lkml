view: standard_cost_direct_materials {
  derived_table: {
    sql:
      select
          item_id,
          max(case when location_id = 4 then standard_cost else null end) as sc_west,
          max(case when location_id = 111 then standard_cost else null end) as sc_south,
          max(case when location_id not in (4, 111) then standard_cost else null end) as sc_else,
         coalesce(sc_west, sc_south, sc_else) as standard_cost
      from
          analytics.production.inventory
      where
          on_hand > 0
      group by 1 ;;
      }

  dimension: item_id {
    primary_key: yes
    type:  string
    hidden:  yes
    sql:${TABLE}.item_id ;; }

  dimension: dm_standard_cost {
    type:  number
    label: "Direct Materials Standard Cost"
    value_format: "$#,##0.00"
    sql:${TABLE}.STANDARD_COST ;; }

}
