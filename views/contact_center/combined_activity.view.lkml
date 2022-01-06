view: combined_activities {
  derived_table: {
    sql:
        select distinct c.chat_id::string as id,
            c.created::date as activity_date,
            case when c.department_name ilike '%Sales%' then 'sales'
              when c.department_name ilike '%support%' then 'support'
              when c.department_name ilike '%srt%' then 'srt'
              when a.team_type = 'Sales' then 'sales'
              when a.team_type = 'Chat' then 'support'
              when a.team_type = 'SRT' then 'srt'
              else 'sales' end as team_type,
            'Chat' as activity_type,
            case when c.missed = 'T' then true
                else false end as missed


        from customer_care.v_zendesk_chats c

            left join customer_care.agent_lkp a
                on c.agent_id::string = a.zendesk_id::string

        union all

        select distinct
            l.conversation_id as id,
            l.started::date as activity_date,
            lower(s.name) as type,
            'Chat' as activity_type,
            false as missed

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
            'Email' as activity_type,
            false as missed

        from customer_care.zendesk_ticket t

            left join customer_care.agent_lkp a
                on a.zendesk_id = t.assignee_id

            left join analytics_stage.zendesk.user u
                on u.id = t.requester_id

            left join analytics_stage.zendesk_sell.users uu
                on uu.user_id = a.zendesk_sell_user_id

        where t.via_channel in ('email','facebook','web')

        union all

        select distinct
            c.contact_id::string as id,
            c.start_ts_mst::date as activity_date,
            case when c.campaign_name ilike 'sales%' then 'sales'
              else 'support' end as team_type,
            'Call' as activity_type,
            case when c.handled = true then false
                else true end as missed

        from (
            select *,
                row_number () over (partition by c.contact_id order by c.start_ts_mst desc) as rn
            from Analytics.customer_care.v_contacts_phone c
            ) c

        where skill_name not in ('Test IB', 'Test Line')
            and rn = 1
    ;;
  }



  ##########################################################################################
  ##########################################################################################
  ## DIMENSIONS

  dimension: id {
    label: "ID"
    sql: ${TABLE}.id ;;
    primary_key: yes
  }

  dimension_group: activity_date {
    label: "Activity"
    type: time
    sql: ${TABLE}.activity_date ;;
    timeframes: [
      date,
      week,
      month,
      quarter,
      year,
      month_name,
      month_num
    ]
  }

  dimension: activity_type {
    label: "Activity Type"
    sql: ${TABLE}.activity_type ;;
  }

  dimension: missed {
    label: "Missed"
    type: yesno
    sql: ${TABLE}.missed ;;
  }

  dimension: team_type {
    label: "Team Type"
    sql: ${TABLE}.team_type ;;
  }

  ##########################################################################################
  ##########################################################################################
  ## MEASURES

  measure: count {
    label: "Activity Count"
    type: count_distinct
    sql: ${TABLE}.id ;;
    drill_fields: [activity_date_date, activity_type, id, team_type]
  }

  measure: count_sales {
    label: "Activity Count (Sales)"
    type: count_distinct
    sql: ${TABLE}.id ;;
    filters: [team_type: "sales"]
  }

  measure: count_support {
    label: "Activity Count (Support)"
    type: count_distinct
    sql: ${TABLE}.id ;;
    filters: [team_type: "support"]
  }

  measure: count_srt {
    label: "Activity Count (SRT)"
    type: count_distinct
    sql: ${TABLE}.id ;;
    filters: [team_type: "srt"]
  }

}
