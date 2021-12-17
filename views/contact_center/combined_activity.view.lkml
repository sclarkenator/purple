view: combined_activity {
  derived_table: {
    sql: select distinct c.chat_id::string as id,
    c.created::date as activity_date,
    case when c.department_name = 'Sales Chat' then 'sales'
        when c.department_name ilike '%support%' then 'support'
        when a.team_type = 'Sales' then 'sales'
        when a.team_type = 'Chat' then 'support'
        else 'sales' end as team_type,
    'chat' as activity_type

from customer_care.v_zendesk_chats c

    left join customer_care.agent_lkp a
        on c.agent_id::string = a.zendesk_id::string

where c.missed = 'F'

union all

select distinct
    l.conversation_id as id,
    l.started::date as activity_date,
    s.name as type,
    'chat' as activity_type

from liveperson.conversation l

    left join liveperson.skill s
        on l.last_skill_id = s.skill_id

where s.name in ('Sales', 'Support', 'SRT')
    and started::date >= '2021-09-08'

union all

select distinct
   t. ticket_id::string as id,
    t.created::date as activity_date,
    case when a.zendesk_sell_user_id is not null and uu.created <= t.created then 'sales'
        when a.zendesk_id is null then 'none'
        else 'support' end as team_type,
    'email' as activity_type

from customer_care.zendesk_ticket t

    left join customer_care.agent_lkp a
        on a.zendesk_id = t.assignee_id

    left join analytics_stage.zendesk.user u
        on u.id = t.requester_id

    left join analytics_stage.zendesk_sell.users uu
        on uu.user_id = a.zendesk_sell_user_id

where t.via_channel in ('email','facebook','web')

union all

select
    c.contact_id::string as id,
    c.contacted::date as activity_date,
    case when c.campaign = 'Sales Team Phone' then 'sales'
        else 'support' end as team_type,
    'call' as activity_type

from (
    select row_number () over (partition by c.contacted, c.contact_id order by agent_id desc) as rownum
      , c.*
    from customer_care.rpt_skill_with_disposition_count c
    )  c

    left join customer_care.agent_lkp a
        on a.incontact_id = c.agent_id

where c.rownum = 1 ;;
  }

  ##########################################################################################
  ##########################################################################################
  ## DIMENSIONS

  dimension: id {
    sql: ${TABLE}.id ;;
  }

  dimension_group: activity_date {
    type: time
    sql: ${TABLE}.activity_date ;;
    timeframes: [
      date,
      week,
      month,
      quarter,
      year
    ]
  }

  dimension: team_type {
    sql: ${TABLE}.team_type ;;
  }

  dimension: activity_type {
    sql: ${TABLE}.activity_type ;;
  }

  ##########################################################################################
  ##########################################################################################
  ## MEASURES

  measure: count {
    label: "Activity Count"
    type: count_distinct
    sql: ${TABLE}.id ;;
  }

  measure: count_sales {
    label: "Activity Count (Sales)"
    type: count_distinct
    sql: case when ${team_type} = 'sales' then ${TABLE}.id end ;;
  }

  measure: count_support {
    label: "Activity Count (Support)"
    type: count_distinct
    sql: case when ${team_type} = 'support' then ${TABLE}.id end ;;
  }

  measure: count_srt {
    label: "Activity Count (SRT)"
    type: count_distinct
    sql: case when ${team_type} = 'srt' then ${TABLE}.id end ;;
  }

  # measure: count_email {

  # }

  }
