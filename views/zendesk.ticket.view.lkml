view: ticket {

  sql_table_name: (select * from analytics_stage.zendesk.ticket
                    --filtering out channels that are not meaningful to customer care. Will need to be added back if other groups need them.
                    where (lower(via_channel) != 'api'
                            or lower(via_channel) != 'chats'
                            or lower(via_channel) != 'sample_ticket'
                            or lower(via_channel) != 'voice'))
                    ;;

  measure: count {
    type: count
    label: "Ticket Count"
    drill_fields: [detail*]
  }

  dimension: id {
    type: number
    primary_key: yes
    sql: ${TABLE}."ID" ;;
  }

  dimension: url {
    type: string
    hidden: yes
    sql: ${TABLE}."URL" ;;
  }

  dimension: external_id {
    type: string
    sql: ${TABLE}."EXTERNAL_ID" ;;
  }

  dimension: via_channel {
    type: string
    sql: ${TABLE}."VIA_CHANNEL" ;;
  }

  dimension: via_source_from_id {
    type: number
    hidden: yes
    sql: ${TABLE}."VIA_SOURCE_FROM_ID" ;;
  }

  dimension: via_source_from_title {
    type: string
    hidden: yes
    sql: ${TABLE}."VIA_SOURCE_FROM_TITLE" ;;
  }

  dimension: via_source_to_name {
    type: string
    sql: ${TABLE}."VIA_SOURCE_TO_NAME" ;;
  }

  dimension: via_source_to_address {
    type: string
    sql: ${TABLE}."VIA_SOURCE_TO_ADDRESS" ;;
  }

  dimension: via_source_rel {
    type: string
    sql: ${TABLE}."VIA_SOURCE_REL" ;;
  }

  dimension_group: created_at {
    type: time
    hidden: yes
    sql: ${TABLE}."CREATED_AT" ;;
  }

  dimension_group: ticket_created {
    ## at some point this should probably be moved into snowflake.
    type: time
    description: "Date the ticket came in to Purple"
    sql: case when lower(${TABLE}."CUSTOM_FRESHDESK_CREATED_DATE") = 'x' then null
          when ${TABLE}."CUSTOM_FRESHDESK_CREATED_DATE" is null then ${TABLE}."CREATED_AT"
          else ${TABLE}."CUSTOM_FRESHDESK_CREATED_DATE" end  ;;
  }

  dimension_group: updated_at {
    type: time
    sql: ${TABLE}."UPDATED_AT" ;;
  }

  dimension: type {
    type: string
    sql: ${TABLE}."TYPE" ;;
  }

  dimension: subject {
    type: string
    sql: ${TABLE}."SUBJECT" ;;
  }

  dimension: description {
    type: string
    sql: ${TABLE}."DESCRIPTION" ;;
  }

  dimension: priority {
    type: string
    sql: ${TABLE}."PRIORITY" ;;
  }

  dimension: status {
    type: string
    sql: ${TABLE}."STATUS" ;;
  }

  dimension: recipient {
    type: string
    sql: ${TABLE}."RECIPIENT" ;;
  }

  dimension: requester_id {
    type: number
    sql: ${TABLE}."REQUESTER_ID" ;;
  }

  dimension: submitter_id {
    type: number
    sql: ${TABLE}."SUBMITTER_ID" ;;
  }

  dimension: assignee_id {
    type: number
    hidden: yes
    sql: ${TABLE}."ASSIGNEE_ID" ;;
  }

  dimension: organization_id {
    type: number
    sql: ${TABLE}."ORGANIZATION_ID" ;;
  }

  dimension: group_id {
    type: number
    hidden: yes
    sql: ${TABLE}."GROUP_ID" ;;
  }

  dimension: forum_topic_id {
    type: number
    hidden: yes
    sql: ${TABLE}."FORUM_TOPIC_ID" ;;
  }

  dimension: problem_id {
    type: number
    hidden: yes
    sql: ${TABLE}."PROBLEM_ID" ;;
  }

  dimension: has_incidents {
    type: string
    sql: ${TABLE}."HAS_INCIDENTS" ;;
  }

  dimension: is_public {
    type: string
    sql: ${TABLE}."IS_PUBLIC" ;;
  }

  dimension_group: due_at {
    type: time
    sql: ${TABLE}."DUE_AT" ;;
  }

  dimension: ticket_form_id {
    type: number
    sql: ${TABLE}."TICKET_FORM_ID" ;;
  }

  dimension: brand_id {
    type: number
    hidden: yes
    sql: ${TABLE}."BRAND_ID" ;;
  }

  dimension: allow_channelback {
    type: string
    sql: ${TABLE}."ALLOW_CHANNELBACK" ;;
  }

  dimension: custom_total_time_spent_sec_ {
    type: number
    sql: ${TABLE}."CUSTOM_TOTAL_TIME_SPENT_SEC_" ;;
  }

  dimension: custom_freshdesk_ticket_id {
    type: number
    sql: ${TABLE}."CUSTOM_FRESHDESK_TICKET_ID" ;;
  }

  dimension: custom_disposition {
    type: string
    sql: lower(replace(${TABLE}."CUSTOM_DISPOSITION",'_',' ')) ;;
  }

  dimension: custom_freshdesk_created_date {
    type: string
    hidden: yes
    sql: ${TABLE}."CUSTOM_FRESHDESK_CREATED_DATE" ;;
  }

  dimension: custom_sync_to_net_suite {
    type: string
    hidden: yes
    sql: ${TABLE}."CUSTOM_SYNC_TO_NET_SUITE" ;;
  }

  dimension: custom_time_spent_last_update_sec_ {
    type: number
    sql: ${TABLE}."CUSTOM_TIME_SPENT_LAST_UPDATE_SEC_" ;;
  }

  dimension_group: _fivetran_synced {
    type: time
    hidden: yes
    sql: ${TABLE}."_FIVETRAN_SYNCED" ;;
  }

  dimension: custom_length_of_call {
    type: string
    sql: ${TABLE}."CUSTOM_LENGTH_OF_CALL" ;;
  }

  dimension: custom_disposition_call {
    type: string
    sql: ${TABLE}."CUSTOM_DISPOSITION_CALL" ;;
  }

  dimension: custom_skill_name {
    type: string
    sql: ${TABLE}."CUSTOM_SKILL_NAME" ;;
  }

  dimension: custom_disposition_comments {
    type: string
    sql: ${TABLE}."CUSTOM_DISPOSITION_COMMENTS" ;;
  }

  dimension: custom_warranty_type {
    type: string
    sql: ${TABLE}."CUSTOM_WARRANTY_TYPE" ;;
  }

  set: detail {
    fields: [
      id,
      url,
      external_id,
      via_channel,
      via_source_from_id,
      via_source_from_title,
      via_source_to_name,
      via_source_to_address,
      via_source_rel,
      created_at_time,
      updated_at_time,
      type,
      subject,
      description,
      priority,
      status,
      recipient,
      requester_id,
      submitter_id,
      assignee_id,
      organization_id,
      group_id,
      forum_topic_id,
      problem_id,
      has_incidents,
      is_public,
      due_at_time,
      ticket_form_id,
      brand_id,
      allow_channelback,
      custom_total_time_spent_sec_,
      custom_freshdesk_ticket_id,
      custom_disposition,
      custom_freshdesk_created_date,
      custom_sync_to_net_suite,
      custom_time_spent_last_update_sec_,
      _fivetran_synced_time,
      custom_length_of_call,
      custom_disposition_call,
      custom_skill_name,
      custom_disposition_comments,
      custom_warranty_type
    ]
  }
}
