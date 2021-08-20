view: headcount {
  derived_table: {
    sql:
      select cast(z.date as date) as date
        ,y.*
      from util.warehouse_date z
      left join customer_care.agent_lkp y on y.created::date <= z.date and nvl(y.inactive::date,current_date::date) > z.date
      where z.date between '2019-01-01' and current_date
    ;;
  }

  dimension: pk {
    primary_key: yes
    hidden: yes
    sql: concat(${TABLE}.date, ${TABLE}.incontact_id) ;;
  }

  dimension: date {
    label: "Headcount Date"
    type: date
    sql: ${TABLE}.date ;;
  }

  dimension: incontact_id {
    label: "InContact ID"
    group_label: "* IDs"
    type: number
    hidden: yes
    value_format_name: id
    sql: ${TABLE}.incontact_id ;;
  }

  dimension: agent_name {
    hidden: yes
    sql: ${TABLE}.name ;;
  }

  measure: headcount {
    label: "Headcount"
    type: count
    drill_fields: [agent_name]
  }
}
