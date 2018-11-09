view: dtc_fulfill_sla {
  derived_table: {
    sql: select order_id
      , order_date
      , case when ful = el and el > 0 then 1 else 0 end SLA_MET
      , case when el > 0 then 1 else 0 end ELIGIBLE_ORDER
    from (
      select order_id
        , max(order_Date) order_Date
        , sum(fulfilled_flg) ful
        , sum(eligible) el
      from (
        select sl.order_id
        , sl.item_id
        , to_date(sl.created) order_date
        , c.cancelled
        , case when sl.fulfilled < dateadd(d,5,sl.created) then 1 else 0 end fulfilled_flg
        , case when c.cancelled is not null and c.cancelled < dateadd(d,5,sl.created) then 0 else 1 end eligible
      from sales_order_line sl
      left join cancelled_order c on c.item_id = sl.item_id and c.order_id = sl.order_id and c.system = sl.system
      where to_date(sl.created) >= '2018-01-01'
      )
      group by 1
    )  ;;}

  dimension_group: order {
    view_label: "SLA achievement"
    label: "Order"
    description:  "Date order was placed"
    type: time
    timeframes: [
      date,
      week,
      month,
      quarter,
      year,
      day_of_week ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.order_date ;; }

  dimension: sla_filter {
    label: "30-day SLA filter"
    view_label: "x - report filters"
    description: "Filter to keep days within SLA window suppressed in visualization"
    type: yesno
    sql: ${order_date} > dateadd(day,-35,current_date) and ${order_date} < dateadd(day,-5,current_date) ;; }

  dimension: order_id {
    hidden:  yes
    primary_key: yes
    type: string
    sql: ${TABLE}.order_id ;; }

  dimension: sla_achieved {
    view_label: "SLA achievement"
    label: "SLA achieved (y/n)"
    description: "Was this customer's entire order fulfilled in 5-day SLA window?"
    type: yesno
    sql: ${TABLE}.sla_met = 1 ;;  }

  measure: SLA_MET {
    view_label: "SLA achievement"
    label: "SLA achieved"
    hidden:  yes
    type: sum
    sql: ${TABLE}.sla_met ;;  }

  measure: ELIGIBLE_ORDERS {
    view_label: "SLA achievement"
    label: "SLA achieved"
    hidden: yes
    type: sum
    sql: ${TABLE}.eligible_order ;;  }

  measure: SLA_RATE {
    label: "SLA achievement"
    view_label: "SLA achievement"
    description: "What percent of complete, eligible orders are fulfilled in 5-day window?"
    type: number
    value_format_name: percent_0
    sql: ${SLA_MET}/nullif(${ELIGIBLE_ORDERS},0) ;;  }
}
