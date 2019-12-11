view: standard_cost {
  derived_table: {
    sql:
      select item_id
        , max(standard_cost) as cost
      from sales.item_standard_cost
      group by item_id ;;
  }

  dimension: item_id {
    type:  string
    primary_key: yes
    hidden:  yes
    sql:${TABLE}.item_id ;; }

  dimension: standard_cost {
    hidden: yes
    label: "Standard Cost"
    type:  number
    value_format: "$#,##0"
    sql:${TABLE}.cost ;; }

}
