view: cc_activities {
 derived_table: {sql:
    select case when ta.tag = 'nic_phone' then 'call'
        when c.chat_id is not null then 'chat'
        when t.via_channel in ('email','facebook') then 'email' end as activity_type
        , t.created
        , t.status
        , coalesce(c.department_name, t.subject) as department_name
        , null as inbound
        , c.duration
        , a.name as agent_name
        , a.email as agent_email
        , case when a.zendesk_sell_user_id is not null and a.created <= t.created then 'sales' when a.zendesk_id is null then 'none' else 'support' end as team
        , u.email
        , u.phone
    from customer_care.zendesk_ticket t
    left join analytics_stage.zendesk.ticket_tag ta on ta.ticket_id = t.ticket_id and ta.tag = 'nic_phone'
    left join customer_care.v_zendesk_chats c on c.zendesk_ticket_id = t.ticket_id
    left join customer_care.agent_lkp a on a.zendesk_id = t.assignee_id
    left join analytics_stage.zendesk.user u on u.id = t.requester_id
    where --t.created::date = '2020-06-24' and
        case when ta.tag = 'nic_phone' then 'call'
        when c.chat_id is not null then 'chat'
        when t.via_channel in ('email','facebook') then 'email' end is not null

   ;;}
# OLD SQL
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



  dimension: activity_type {
    type:  string
    sql: ${TABLE}.activity_type ;;
  }

  dimension_group: activity {
    type: time
    timeframes: [raw, date, day_of_week, day_of_month, day_of_year, week, week_of_year, month, month_name, quarter, quarter_of_year, year]
    sql: ${TABLE}.created::date ;; }

  dimension: status {
    type:  string
    sql: ${TABLE}.status ;;
  }

  dimension: inbound {
    type:  string
    sql: ${TABLE}.inbound ;;
  }

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

  dimension: phone {
    type:  string
    sql: ${TABLE}.phone ;;
  }

  measure: count {
    type: count
  }

  measure: duration {
    type: sum
    sql: ${TABLE}.duration ;;
  }


}
