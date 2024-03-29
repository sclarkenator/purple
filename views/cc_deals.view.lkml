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

  dimension: user_id {
    label: "Zendesk Sell User ID"
    type: number
    value_format_name: id
    sql: ${TABLE}.user_id ;;
  }

  dimension: deal_id {
    primary_key: yes
    type:  string
    sql: ${TABLE}.deal_id ;;
  }

  dimension_group: created {
    type: time
    timeframes: [raw, date, day_of_week, day_of_week_index, day_of_month, day_of_year, week, week_of_year, month, month_name, quarter, quarter_of_year, year]
    sql: ${TABLE}.created:: date ;; }

  dimension_group: created_time {
    type: time
    timeframes: [raw, date, day_of_week, day_of_month, day_of_year, hour_of_day, week, week_of_year, month, month_name, quarter, quarter_of_year, year]
    sql: ${TABLE}.created ;; }

 dimension: until_today {
    type: yesno
    sql: ${created_day_of_week_index} < date_part(dow,current_date()) AND ${created_day_of_week_index} >= 0;;
  }

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
    sql:
      case
        when ${TABLE}.source_name ilike ('%chat%')
          or ${TABLE}.source_name in ('MyMove') then 'chat'
        when ${TABLE}.source_name ilike ('%call%')
          or ${TABLE}.source_name in ('Magazine Ad','Transfer from Support','888Purple') then 'call'
        when ${TABLE}.source_name ilike ('%email%')
          or ${TABLE}.source_name in ('Abandoned Cart Campaign','Bulk','MyMOVE')
          or ${TABLE}.source_name ilike ('%facebook%')  then 'email'
        else 'other'
      end
    ;;
  }

  dimension: stage_name {
    type:  string
    sql: ${TABLE}.stage_name ;;
  }

  dimension: order_id {
    type:  string
    hidden: yes
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
