view: video_sales_drafts {
  derived_table: {
    sql:
    select distinct
      d.name as draft_order,
      replace(array_agg(distinct s.related_tranid) over(partition by d.name)::string, '[]', '') as converted_order,
      t.value as user,
      d.status,
      d.total_price,
      d.created_at::date as draft_date,
      l.mattress_flag

    from analytics_stage.shopify_us_ft.draft_order d

        left join analytics_stage.shopify_us_ft.draft_order_tag t
            on d.id::number = t.draft_order_id::number

        left join (
            select distinct draft_order_id, 'Yes' as mattress_flag
            from analytics_stage.shopify_us_ft.draft_order_line l
            where l.title ilike '%mattress%'
            ) l
            on d.id = l.draft_order_id

        left join (
            select *
            from ANALYTICS.SALES.SALES_ORDER s
            ) s
            on d.order_id::string = s.etail_order_id

    where ((value ='LoftonE'
            and d.created_at::date between '2021-11-08' and dateadd(days, -1, current_date()))
        --or (value is null
        --    and d.created_at::date between '2021-11-08' and dateadd(days, -1, current_date()))
        or (value ='autumn'
            and d.created_at::date between '2021-11-26' and '2021-12-01')

        or d.name in (
            '#D245349',
            '#D241067',
            '#D246194',
            '#D238316',
            '#D240235',
            '#D244182',
            '#D245412',
            '#D245413',
            '#D245610',
            '#D246279',
            '#D246588',
            '#D246660',
            '#D247365'
           ))
       and (value <> 'BulkOrders'
            or value is null)

    order by d.name
    ;;
  }

  ##########################################################################################
  ##########################################################################################
  ## GENERAL DIMENSIONS

  dimension: draft_order {
    label: "Draft Order"
    description: "Draft order number."
    primary_key: yes
    # group_label: ""
    type: string
    sql: ${TABLE}.draft_order ;;
  }

  dimension: converted_order {
    label: "Converted Order"
    description: "Netsuite Order Number."
    # group_label: ""
    type: string
    sql: ${TABLE}.converted_order ;;
  }

  dimension: user {
    label: "Order Agent"
    description: "Name of user credited with creating draft order."
    # group_label: ""
    type: string
    sql: ${TABLE}.user ;;
  }

  dimension: status {
    label: "Order Status"
    description: "Whether draft is open, or the order has been completed."
    # group_label: ""
    type: string
    sql: ${TABLE}.status ;;
  }

  dimension: total_price {
    label: "Total Price"
    description: "Total order value."
    # group_label: ""
    type: number
    value_format_name: usd
    sql: ${TABLE}.total_price ;;
  }

  dimension: mattress_flag {
    label: "Mattress Order Flag"
    description: "Flags orders that include a mattress."
    # group_label: ""
    type: yesno
    sql: ${TABLE}.mattress_flag = 'Yes' ;;
  }

  dimension_group: draft_date {
    label: "Draft Created"
    description: "Date when draft was generated."
    type: time
    sql: ${TABLE}.draft_date ;;
    timeframes: [
      date,
      week,
      month,
      quarter,
      year
    ]
  }

  ##########################################################################################
  ##########################################################################################
  ## MEASURES

  measure: AOV {
    label: "AOV"
    description: "Average Order Value"
    type: average
    value_format_name: usd
    sql: case when ${status} = 'completed' then ${total_price} end ;;
  }

  measure: AMOV {
    label: "AMOV"
    description: "Average Mattress Order Value"
    type: average
    value_format_name: usd
    sql: case when ${mattress_flag} = 'Yes'
      and ${status} = 'completed' then ${total_price} end ;;
  }

  measure: AOV_count {
    label: "Order Count"
    description: "Average Order Value"
    type: count_distinct
    sql: case when ${status} = 'completed' then ${converted_order} end ;;
  }

  measure: AMOV_count {
    label: "Mattress Order Count"
    description: "Average Mattress Order Value"
    type: count_distinct
    sql: case when ${mattress_flag} = 'Yes'
      and ${status} = 'completed' then ${converted_order} end ;;
  }

  measure: draft_count {
    label: "Draft Order Count"
    description: "Count of drafts created"
    type: count_distinct
    sql: ${draft_order} ;;
  }

measure: sales_conversion {
  label: "Draft Conversation Rate"
  description: "Percent of draft orders converted to orders."
  type: number
  value_format_name: percent_2
  sql: count(distinct ${converted_order}) / count(distinct draft_order) ;;
}

}
