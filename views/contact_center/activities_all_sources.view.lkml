view: activities_all_sources {
  derived_table: {
sql:
    --calls (RPT Skills/Incontact)    select
        'call' as activity_type
        ,case when c.campaign_name = 'Sales Team Phone'
          then 'sales' else 'support' end as team
        , a.name as agent_name
        , a.email as agent_email
        , c.handle_time
        , case when c.handle_time > 0 then 'F' else 'T' end as missed
        , c.skill_name as skill
        , null as email
        ,c.agent_id
    -- select distinct media_type

    from Analytics.customer_care.v_contacts_phone  c

    left join customer_care.agent_lkp a
        on a.incontact_id = c.agent_id
    union

    --chats (zendesk tickets)
    select 'chat' as activity_type
        , case when c.department_name ilike '%Sales%' then 'sales' else 'support' end as team
        , c.created as created
        , a.name as agent_name
        , a.email as agent_email
        , c.duration
        , c.missed
        , c.department_name as skill
        , c.visitor_email
    from customer_care.v_zendesk_chats c
    left join customer_care.zendesk_ticket t on c.zendesk_ticket_id = t.ticket_id
    left join customer_care.agent_lkp a on a.zendesk_id = t.assignee_id
    left join analytics_stage.zendesk.user u on u.id = t.requester_id
    left join analytics_stage.zendesk_sell.users uu on uu.user_id = a.zendesk_sell_user_id
    union

    --emails/facebook (zendesk tickets)
    select  'email' as activity_type
        , case when a.zendesk_sell_user_id is not null and uu.created <= t.created then 'sales' when a.zendesk_id is null then 'none' else 'support' end as team
        , t.created as created
        , a.name as agent_name
        , a.email as agent_email
        , null as duration
        , 'F' as missed
        , t.subject
        , u.email
    from customer_care.zendesk_ticket t
    left join customer_care.agent_lkp a on a.zendesk_id = t.assignee_id
    left join analytics_stage.zendesk.user u on u.id = t.requester_id
    left join analytics_stage.zendesk_sell.users uu on uu.user_id = a.zendesk_sell_user_id
    where t.via_channel in ('email','facebook','web')
  ;;}


  dimension: activity_type {
    type:  string
    sql: ${TABLE}.activity_type ;;
  }

  dimension_group: activity {
    type: time
    timeframes: [raw, date, day_of_week, day_of_month, day_of_year, week, day_of_week_index, week_of_year, month, month_name, quarter, quarter_of_year, year]
    sql: ${TABLE}.created::date  ;; }

  dimension: until_today {
    type: yesno
    sql: ${activity_day_of_week_index} < date_part(dow,current_date()) AND ${activity_day_of_week_index} >= 0;;
  }
  dimension: prev_week{
    group_label: "Activity Date"
    label: "z - Previous Week"
    type: yesno
    sql:  date_trunc(week, ${TABLE}.created::date) = dateadd(week, -1, date_trunc(week, current_date)) ;; }

  dimension_group: activity_time {
    type: time
    hidden: no
    timeframes: [raw, date, day_of_week, day_of_month, day_of_year,hour_of_day, week, week_of_year, month, month_name, quarter, quarter_of_year, year,hour]
    sql: ${TABLE}.created  ;; }


  dimension: duration_dim {
    type:  string
    sql: ${TABLE}.duration ;;
  }

  dimension: agent_name {
    type:  string
    sql: ${TABLE}.agent_name ;;
  }

  dimension: agent_email {
    type:  string
    sql: lower(${TABLE}.agent_email) ;;
  }

  dimension: team {
    type:  string
    sql: ${TABLE}.team ;;
  }

  dimension: team_clean {
    type:  string
    sql: case when ${TABLE}.team = 'sales' then 'sales' else 'support' end ;;
  }

  dimension: email {
    type:  string
    sql: ${TABLE}.email ;;
  }

  dimension: skill {
    type:  string
    sql: ${TABLE}.skill ;;
  }

  dimension: missed {
    type:  yesno
    sql: ${TABLE}.missed = 'T' ;;
  }

  measure: count {
    type: count
  }

  measure: chats {
    type: sum
    sql: case when ${activity_type} = 'chat' then 1 else 0 end ;;
  }

  measure: calls {
    type: sum
    sql: case when ${activity_type} = 'call' then 1 else 0 end ;;
  }

  measure: emails {
    type: sum
    sql: case when ${activity_type} = 'email' then 1 else 0 end ;;
  }

  measure: duration {
    type: sum
    sql: ${TABLE}.duration ;;
  }
}
}
