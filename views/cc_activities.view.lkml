view: cc_activities {
 derived_table: {
  sql:
    --calls (Incontact Phone)
      select distinct
        'call' as activity_type,
        case when c.campaign_name ilike 'sales%' then 'sales'
          else 'support' end as team,
        c.start_ts_mst::date as created,
        a.name as agent_name,
        a.email as agent_email,
        c.handle_time as duration,
        case when c.handled = true then false
          else true end as missed,
        c.skill_name as skill,
        null as email,
        a.incontact_id,
        c.contact_id::string as activity_id

      from (
            select *,
                row_number () over (partition by c.contact_id order by c.start_ts_mst desc) as rn
            from Analytics.customer_care.v_contacts_phone c
            ) c
        left join customer_care.agent_lkp a on a.incontact_id = c.agent_id
        where skill_name not in ('Test IB', 'Test Line')
            and rn = 1

    union all

    --chats (zendesk tickets)
    select distinct 'chat' as activity_type,
      case when c.department_name ilike '%Sales%' then 'sales'
        when c.department_name ilike '%support%' then 'support'
        when c.department_name ilike '%srt%' then 'srt'
        when a.team_type = 'Sales' then 'sales'
        when a.team_type = 'Chat' then 'support'
        when a.team_type = 'SRT' then 'srt'
        else 'sales' end as team,
      c.created as created,
      a.name as agent_name,
      a.email as agent_email,
      c.duration,
      c.missed,
      'ZD Chat' as skill,
      c.visitor_email,
      a.incontact_id,
      chat_id::string as activity_id

    from customer_care.v_zendesk_chats c

      left join customer_care.agent_lkp a
          on c.agent_id::string = a.zendesk_id::string

    union all

      --messaging chats (liveperson converations)
    select distinct 'chat' as activity_type
        ,case when s.name = 'Sales' then 'sales'
          when s.name = 'Support' then 'support'
          else null end as team
        , lp.ended as created
        , a.name as agent_name
        , a.email as agent_email
        , null as duration
        , 'F' as missed
        , 'LP Conversation' as skill
        , null as email
        , a.incontact_id
        , lp.conversation_id::string as activity_id
    from liveperson.conversation lp
      left join liveperson.skill s
        on s.skill_id = lp.last_skill_id
      left join liveperson.agent ag
        on ag.agent_id = lp.last_agent_id
      left join customer_care.agent_lkp a
        on a.zendesk_id = ag.employee_id
      left join analytics_stage.zendesk_sell.users uu
        on uu.user_id = a.zendesk_sell_user_id
    where lp.ended > '2021-09-08'
      and a.name not ilike '%-bot'
      and a.name not ilike '%virtual%'

    union all

    --emails/facebook (zendesk tickets)
    select 'email' as activity_type,
      case when a.zendesk_sell_user_id is not null and uu.created <= t.created then 'sales'
          when a.zendesk_id is null then 'none'
          else 'support' end as team,
      t.created as created,
      a.name as agent_name,
      a.email as agent_email,
      null as duration,
      'F' as missed,
      team as skill,
      u.email,
      a.incontact_id,
      t.ticket_id::string as activity_id
    from customer_care.zendesk_ticket t
      left join customer_care.agent_lkp a
        on a.zendesk_id = t.assignee_id
      left join analytics_stage.zendesk.user u
        on u.id = t.requester_id
      left join analytics_stage.zendesk_sell.users uu
        on uu.user_id = a.zendesk_sell_user_id
    where t.via_channel in ('email','facebook','web')


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

  dimension: activity_id {
    label: "Activity ID"
    type: number
    sql: ${TABLE}.activity_id ;;
    hidden: yes
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
    timeframes: [raw, date, day_of_week, day_of_month, day_of_year,hour_of_day, week, week_of_year, month, month_name, quarter, quarter_of_year, year,hour, minute30]
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
    sql: case when ${TABLE}.team = 'sales' then 'sales' when ${TABLE}.team = 'support' then 'support' else 'other' end ;;
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
    type: count_distinct
    sql: ${activity_id} ;;
  }

  measure: chats_old {
    type: sum
    sql: case when ${activity_type} = 'chat' then 1 else 0 end ;;
  }

  measure: chats {
    type: count_distinct
    sql: ${activity_id} ;;
    filters: [activity_type: "chat"]
  }

  measure: calls_old {
    type: sum
    sql: case when ${activity_type} = 'call' then 1 else 0 end ;;
  }

  measure: calls {
    type: count_distinct
    sql: ${activity_id} ;;
    filters: [activity_type: "call"]
  }

  measure: emails_old {
    type: sum
    sql: case when ${activity_type} = 'email' then 1 else 0 end ;;
  }

  measure: emails {
    type: count_distinct
    sql: ${activity_id} ;;
    filters: [activity_type: "email"]
  }

  measure: duration {
    type: sum
    sql: ${TABLE}.duration ;;
  }


}
