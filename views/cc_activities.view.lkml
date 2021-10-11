view: cc_activities {
 derived_table: {
  sql:
    --calls (RPT Skills/Incontact)
    select 'call' as activity_type
        , case when c.campaign = 'Sales Team Phone' --and c.skill <> 'Sales Xfer (From Support)'
          then 'sales' else 'support' end as team
        , c.contacted as created
        , a.name as agent_name
        , a.email as agent_email
        , c.handle_time
        , case when c.handle_time > 0 then 'F' else 'T' end as missed
        , c.skill
        , null as email
        ,a.incontact_id
    from (
      select row_number () over (partition by c.contacted, c.contact_id order by agent_id desc) as rownum
          , c.*
      from customer_care.rpt_skill_with_disposition_count c
      )  c
    left join customer_care.agent_lkp a on a.incontact_id = c.agent_id
    where c.rownum = 1
    --and c.contacted::date between '2020-06-01' and '2020-06-30'
    union

    --chats (zendesk tickets)
    select 'chat' as activity_type
        , case
            when c.department_name ilike '%Sales%' then 'sales'
            when c.department_name ilike '%Support%' then 'support'
            when a.team_type ilike '%Sales%' then 'sales'
            when a.team_type ilike '%Chat%' then 'support'
            else 'sales' end as team
        , c.created as created
        , a.name as agent_name
        , a.email as agent_email
        , c.duration
        , c.missed
        , c.department_name as skill
        , c.visitor_email
        ,a.incontact_id
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
        ,a.incontact_id
    from customer_care.zendesk_ticket t
    left join customer_care.agent_lkp a on a.zendesk_id = t.assignee_id
    left join analytics_stage.zendesk.user u on u.id = t.requester_id
    left join analytics_stage.zendesk_sell.users uu on uu.user_id = a.zendesk_sell_user_id
    where t.via_channel in ('email','facebook','web')

    union
    ---missed chats in moving to liveperson
    select 'chat' as activity_type
        , 'sales' as team
        , chat_date as created
        , null as agent_name
        , null as agent_email
        , null as duration
        , 'F' as missed
        , 'MissedChat' as subject
        , null as email
        , metric as incontact_id
    from analytics.csv_uploads.missed_chats_temp

  ;;}

# OLD SQL

#     select case when ta.tag = 'nic_phone' then 'call'
#         when c.chat_id is not null then 'chat'
#         when t.via_channel in ('email','facebook') then 'email' end as activity_type
#         , t.created
#         , t.status
#         , coalesce(c.department_name, t.subject) as department_name
#         , null as inbound
#         , c.duration
#         , a.name as agent_name
#         , a.email as agent_email
#         , case when a.zendesk_sell_user_id is not null and uu.created <= t.created then 'sales' when a.zendesk_id is null then 'none' else 'support' end as team
#         , u.email
#         , u.phone
#         , a.created as user_created
#     from customer_care.zendesk_ticket t
#     left join analytics_stage.zendesk.ticket_tag ta on ta.ticket_id = t.ticket_id and ta.tag = 'nic_phone'
#     left join customer_care.v_zendesk_chats c on c.zendesk_ticket_id = t.ticket_id
#     left join customer_care.agent_lkp a on a.zendesk_id = t.assignee_id
#     left join analytics_stage.zendesk.user u on u.id = t.requester_id
#     left join analytics_stage.zendesk_sell.users uu on uu.user_id = a.zendesk_sell_user_id
#     where --t.created::date = '2019-06-24' and
#         case when ta.tag = 'nic_phone' then 'call'
#         when c.chat_id is not null then 'chat'
#         when t.via_channel in ('email','facebook') then 'email' end is not null
#         and a.zendesk_sell_user_id is not null

# --ACTIVITIES
# select z.activity_type
#     , z.created
#     , z.status
#     , z.department_name
#     , z.inbound
#     , z.duration
#     , a.name as agent_name
#     , a.email as agent_email
#     --, a.zendesk_sell_user_id
#     , case when a.zendesk_sell_user_id is not null and a.created <= z.created then 'sales' when a.zendesk_id is null then 'none' else 'support' end as team
#     , u.email
#     , u.phone
# from (
# --CHATS
#   select 'chat' as activity_type , t.ticket_id, t.assignee_id, t.requester_id, c.created, t.status, c.department_name, 'Yes' as inbound, c.duration
#   from customer_care.v_zendesk_chats c
#   left join customer_care.zendesk_ticket t on t.ticket_id = c.zendesk_ticket_id
#   --where c.created::date = '2020-06-18'
#   UNION ALL
#   --Emails
#   select via_channel as activity_type, ticket_id, assignee_id, requester_id, created, status, subject, 'Yes' as inbound, null as duration
#   from customer_care.zendesk_ticket
#   where --created::date = '2020-06-18' and
#       via_channel in ('email','facebook')
# ) z
# left join customer_care.agent_lkp a on a.zendesk_id = z.assignee_id
# left join analytics_stage.zendesk.user u on u.id = z.requester_id
# union all
# select 'call' as activity_type
#     , c.contacted
#     --, c.agent_id
#     , c.skill as status
#     , c.campaign as department_name
#     , CASE WHEN substring((c.contact_info_to),0,3) = '888' THEN 'Yes' ELSE 'No' END as inbound
#     , c.handle_time
#     , a.name as agent_name
#     , a.email as agent_email
#     --, a.zendesk_sell_user_id
#     , case when a.zendesk_sell_user_id is not null and a.created <= c.contacted then 'sales' when a.zendesk_id is null then 'none' else 'support' end as team
#     , cc.email
#     , c.contact_info_from
# from customer_care.RPT_SKILL_WITH_DISPOSITION_COUNT c
# left join customer_care.agent_lkp a on a.incontact_id = c.agent_id
# left join customer_care.zendesk_sell_contact cc on
#   replace(replace(replace(replace(replace(replace(replace((cc.mobile)::text,'-',''),'1 ',''),'+81 ',''),'+',''),'(',''),')',''),' ','')
#   = replace(replace(replace(replace(replace(replace(replace((c.contact_info_from)::text,'-',''),'1 ',''),'+81 ',''),'+',''),'(',''),')',''),' ','')
# --where c.reported::date = '2020-06-18'

  dimension: pk {
    label: "Primary Key"
    type: string
    primary_key: yes
    sql: ${activity_type} || ${TABLE}.created || ${TABLE}.incontact_id ;;
  }

  dimension: incontact_id {
    label: "InContact ID"
    type: number
    value_format_name: id
    sql: ${TABLE}.incontact_id ;;
  }
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
    type: sum
    sql: case when ${activity_type} = 'chat' and ${skill} = 'MissedChat' then ${incontact_id}
    when ${activity_type} = 'chat' then 1 else 0 end;;
  }

  measure: chats {
    type: sum
    sql: case when ${skill} = 'MissedChat' then ${incontact_id}
      when ${activity_type} = 'chat' then 1 else 0 end ;;
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
