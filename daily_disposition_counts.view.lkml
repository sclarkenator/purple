view: daily_disposition_counts {
  derived_table: {
    sql: select case when a.disposition is null then b.disposition
        when b.disposition is null then a.disposition
        else a.disposition end as final_disposition
    --, a.disposition
    --, b.disposition
    , case when a.reported is null then b.ticket_date
        when b.ticket_date is null then a.reported
        else a.reported end as final_date
    --, reported
    --, ticket_date
    , call_count
    , ticket_count
from (select lower(disposition) disposition
        , reported
        , count(*) call_count
      from customer_care.rpt_skill_with_disposition_count rpt
      group by 1, 2) a

full outer join (select lower(replace(t.custom_disposition, '_', ' ')) as disposition
            , (case when lower(t.CUSTOM_FRESHDESK_CREATED_DATE) = 'x' then null
                when t.CUSTOM_FRESHDESK_CREATED_DATE is null then t.CREATED_AT
                else t.CUSTOM_FRESHDESK_CREATED_DATE end)::date as ticket_date
            , count(t.id) ticket_count
        from analytics_stage.zendesk.ticket t
                 full outer join "ANALYTICS_STAGE"."ZENDESK"."GROUP" g on g.id = t.group_id
        where (lower(t.via_channel) != 'api'
                or lower(t.via_channel) != 'chats'
                or lower(t.via_channel) != 'sample_ticket'
                or lower(t.via_channel) != 'voice')
               or (lower(g.name) != 'comms dept'
                      or lower(g.name) != 'leadership'
                      or lower(g.name) != 'chat' )
group by 1, 2)  b on b.disposition = a.disposition and b.ticket_date = a.reported
 ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: pk {
    type: string
    hidden: yes
    primary_key: yes
    sql: ${TABLE}."FINAL_DISPOSITION" ||  ${TABLE}."FINAL_DATE" ;;
  }

  dimension: disposition {
    type: string
    sql: ${TABLE}."FINAL_DISPOSITION" ;;
  }

  dimension_group: interaction {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}."FINAL_DATE" ;;
  }

  dimension: call_count_dim {
    type: number
    hidden: yes
    sql: ${TABLE}."CALL_COUNT" ;;
  }

  dimension: ticket_count_dim {
    type: number
    hidden: yes
    sql: ${TABLE}."TICKET_COUNT" ;;
  }

  measure: call_count {
    type: sum
    sql: coalesce(${TABLE}."CALL_COUNT", 0) ;;
  }

  measure: ticket_count {
    type: sum
    sql: coalesce(${TABLE}."TICKET_COUNT", 0) ;;
  }

  set: detail {
    fields: [disposition, call_count, ticket_count]
  }
}
