view: zendesk_ticket {
  sql_table_name: "CUSTOMER_CARE"."ZENDESK_TICKET"
    ;;

  dimension: allow_channelback {
    type: yesno
    sql: ${TABLE}."ALLOW_CHANNELBACK" ;;
  }

  dimension: assignee_id {
    type: number
    sql: ${TABLE}."ASSIGNEE_ID" ;;
  }

  dimension_group: created {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: CAST(${TABLE}."CREATED" AS TIMESTAMP_NTZ) ;;
  }

  dimension: description {
    type: string
    sql: ${TABLE}."DESCRIPTION" ;;
  }

  dimension: primary_disposition {
    type: string
    sql: ${TABLE}."PRIMARY_DISPOSITION" ;;
  }

  dimension: secondary_disposition {
    type: string
    sql: ${TABLE}."SECONDARY_DISPOSITION" ;;
  }

  dimension: disposition_call {
    type: string
    sql: ${TABLE}."DISPOSITION_CALL" ;;
  }

  dimension: disposition_comments {
    type: string
    sql: ${TABLE}."DISPOSITION_COMMENTS" ;;
  }

  dimension: requester_role {
    type: string
    sql: ${TABLE}."REQUESTER_ROLE" ;;
  }

  dimension: submitter_role {
    type: string
    sql: ${TABLE}."SUBMITTER_ROLE" ;;
  }

  dimension: product {
    type: string
    sql: ${TABLE}."PRODUCT" ;;
  }

  dimension: first_response_comment_order {
    type: number
    sql: ${TABLE}."FIRST_RESPONSE_COMMENT_ORDER" ;;
  }

  dimension: first_response_minute {
    type: number
    sql: ${TABLE}."FIRST_RESPONSE_MINUTE" ;;
  }

  dimension: first_response_ticket_comment_id {
    type: number
    sql: ${TABLE}."FIRST_RESPONSE_TICKET_COMMENT_ID" ;;
  }

  dimension: group_id {
    type: number
    sql: ${TABLE}."GROUP_ID" ;;
  }

  dimension: has_incidents {
    type: yesno
    sql: ${TABLE}."HAS_INCIDENTS" ;;
  }

  dimension: is_public {
    type: yesno
    sql: ${TABLE}."IS_PUBLIC" ;;
  }

  dimension: length_of_call {
    type: string
    sql: ${TABLE}."LENGTH_OF_CALL" ;;
  }

  dimension: priority {
    type: string
    sql: ${TABLE}."PRIORITY" ;;
  }

  dimension: requester_id {
    type: number
    sql: ${TABLE}."REQUESTER_ID" ;;
  }

  dimension: skill_name {
    type: string
    sql: ${TABLE}."SKILL_NAME" ;;
  }

  dimension: status {
    type: string
    sql: ${TABLE}."STATUS" ;;
  }

  dimension: subject {
    type: string
    sql: ${TABLE}."SUBJECT" ;;
  }

  dimension: system_location {
    type: string
    sql: ${TABLE}."SYSTEM_LOCATION" ;;
  }

  dimension: ticket_form_id {
    type: number
    sql: ${TABLE}."TICKET_FORM_ID" ;;
  }

  dimension: ticket_id {
    group_label: " Advanced"
    label: "Ticket ID"
    primary_key: yes
    type: number
    link: {
      label: "Zendesk"
      url: "https://purplesupport.zendesk.com/agent/tickets/{{value}}"
      icon_url: "https://zendesk.com/favicon.ico"
    }
    description: "This is Zendesk's internal ID. This will be a hyperlink to the ticket in Zendesk."
    sql: ${TABLE}."TICKET_ID" ;;
  }

  dimension: time_spent_last_update {
    type: number
    sql: ${TABLE}."TIME_SPENT_LAST_UPDATE" ;;
  }

  dimension: total_time_spent {
    type: number
    sql: ${TABLE}."TOTAL_TIME_SPENT" ;;
  }

  dimension: url {
    type: string
    sql: ${TABLE}."URL" ;;
  }

  dimension: via_channel {
    type: string
    sql: ${TABLE}."VIA_CHANNEL" ;;
  }

  measure: count {
    type: count
    drill_fields: [skill_name]
  }
}
