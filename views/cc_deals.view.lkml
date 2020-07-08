view: cc_deals {
  derived_table: {
    sql:
      -- DEALS
      select d.deal_id
        , d.contact_id
        , c.email
        , c.name
        , d.user_id
        , u.email as agent_email
        , u.name as agent
        , d.created_at as created
        , d.source_name
        , d.stage_name
        , d.order_id
      from customer_care.zendesk_sell_deal d
      left join customer_care.zendesk_sell_contact c on c.contact_id = d.contact_id
      left join customer_care.zendesk_sell_user u on u.user_id = d.user_id
    ;;
  }

  dimension: deal_id {
    primary_key: yes
    type:  string
    sql: ${TABLE}.deal_id ;;
  }

  dimension_group: created {
    type: time
    timeframes: [raw, date, day_of_week, day_of_month, day_of_year, week, week_of_year, month, month_name, quarter, quarter_of_year, year]
    sql: ${TABLE}.created ;; }

  dimension: email {
    type:  string
    sql: ${TABLE}.email ;;
  }

  dimension: agent_email {
    type:  string
    sql: lower(${TABLE}.agent_email) ;;
  }

  dimension: agent {
    type:  string
    sql: ${TABLE}.agent ;;
  }

  dimension: source_name {
    type:  string
    sql: ${TABLE}.source_name ;;
  }

  dimension: source_clean {
    type:  string
    sql: case when ${TABLE}.source_name ilike ('%chat%') then 'chat'
      when ${TABLE}.source_name ilike ('%call%') or ${TABLE}.source_name in ('Magazine Ad','Transfer from Support') then 'call'
      when ${TABLE}.source_name ilike ('%email%') or ${TABLE}.source_name in ('Abandoned Cart Campaign','Bulk')
        or ${TABLE}.source_name ilike ('%facebook%')  then 'email'
      else 'other' end;;
  }

  dimension: stage_name {
    type:  string
    sql: ${TABLE}.stage_name ;;
  }

  dimension: team_clean {
    type:  string
    sql: case when ${TABLE}.team = 'sales' then 'sales' else 'support' end ;;
  }

  dimension: order_id {
    type:  string
    sql: ${TABLE}.order_id ;;
  }

  measure: count {
    type: count
  }

  measure: days_to_order {
    type: average
    value_format: "0.0"
    sql: datediff('day',${created_date},${sales_order.created_date}) ;;
  }

}
