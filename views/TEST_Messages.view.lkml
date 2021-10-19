view: test_messages {
derived_table: {
sql:
--calls (RPT Skills/Incontact)
select distinct 'call' as activity_type
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
) c
left join customer_care.agent_lkp a on a.incontact_id = c.agent_id
where c.rownum = 1
and direction = 'Inbound'
--and c.contacted::date between '2020-06-01' and '2020-06-30'
union all





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
, 'ZD Chat' as skill
, c.visitor_email
,a.incontact_id
from customer_care.v_zendesk_chats c
left join customer_care.zendesk_ticket t on c.zendesk_ticket_id = t.ticket_id
left join customer_care.agent_lkp a on a.zendesk_id = t.assignee_id
left join analytics_stage.zendesk.user u on u.id = t.requester_id
left join analytics_stage.zendesk_sell.users uu on uu.user_id = a.zendesk_sell_user_id
union all




--emails/facebook (zendesk tickets)
select 'email' as activity_type
, case when a.zendesk_sell_user_id is not null and uu.created <= t.created then 'sales' when a.zendesk_id is null then 'none' else 'support' end as team
, t.created as created
, a.name as agent_name
, a.email as agent_email
, null as duration
, 'F' as missed
, team as skill
, u.email
,a.incontact_id
from customer_care.zendesk_ticket t
left join customer_care.agent_lkp a on a.zendesk_id = t.assignee_id
left join analytics_stage.zendesk.user u on u.id = t.requester_id
left join analytics_stage.zendesk_sell.users uu on uu.user_id = a.zendesk_sell_user_id
where t.via_channel in ('email','facebook','web')
union all



--messaging (liveperson converations)
select 'messaging' as activity_type
,case
when s.name = 'Sales' then 'sales'
when s.name = 'Support' then 'support' else null end as team
, lp.ended as created
, a.name as agent_name
, a.email as agent_email
, null as duration
, 'F' as missed
, 'LP Conversation' as skill
, null as email
, a.incontact_id
from liveperson.conversation lp
left join liveperson.skill s on s.skill_id = lp.last_skill_id
left join liveperson.agent ag on ag.employee_id = lp.last_agent_id
left join customer_care.agent_lkp a on a.incontact_id = ag.employee_id
left join analytics_stage.zendesk_sell.users uu on uu.user_id = a.zendesk_sell_user_id
where lp.ended > '2021-09-08'

;;
  }
dimension: created {
  sql: created::date ;;
  type: date
}
dimension: activity_type {
  sql: activity_type ;;
  type: string
}

dimension: skill {
  sql: skill ;;
  type: string
}

  dimension: team {
    sql: team ;;
    type: string
  }
  measure: count {
    type: count
  }
  }
